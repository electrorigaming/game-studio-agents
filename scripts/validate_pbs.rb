#!/usr/bin/env ruby
# Deterministic PBS validator for La Base de Sky.
#
# Usage:
#   ruby validate_pbs.rb all                 # validate every *.txt in PBS/
#   ruby validate_pbs.rb pokemon.txt         # validate a single file
#
# Checks (see .claude/rules/pbs-files.md for the syntax this enforces):
#   - Section syntax: sections start with [ID], fields are "key = value"
#   - Duplicate section IDs within a file
#   - Comma-separated lists must not have a space after the comma
#   - Required fields present per file type
#   - Cross-references: pokemon.txt Evolution/Moves/TutorMoves/EggMoves/Abilities/
#     HiddenAbilities against species/moves/abilities that actually exist;
#     trainers.txt Pokemon/Moves/Item against species/moves/items that exist
#
# Exit status: 0 if no errors found in any validated file, 1 otherwise.

PBS_DIR = File.expand_path("../../la-base-de-sky/LA BASE DE SKY/PBS", __dir__)

REQUIRED_FIELDS = {
  "pokemon.txt" => %w[Name Types BaseStats GenderRatio GrowthRate BaseExp Abilities],
  # Power is intentionally excluded: Status-category moves omit it entirely
  # in the real PBS data (e.g. WITHDRAW/Refugio has no Power field).
  "moves.txt" => %w[Name Type Category Accuracy TotalPP Target],
  "trainers.txt" => [], # validated structurally instead (Pokemon sub-blocks)
}.freeze

# Only these fields are true comma-separated lists. Free-text fields (Name,
# Pokedex, Description, LoseText, etc.) legitimately contain natural-language
# commas followed by a space and must NOT be checked for list spacing.
LIST_FIELDS = %w[
  Types BaseStats EVs EVYield Abilities HiddenAbilities EggGroups Moves
  TutorMoves EggMoves Flags IV Evolution Pokemon
].freeze

Section = Struct.new(:id, :line_no, :fields)

# Parses a flat PBS file (pokemon.txt, moves.txt, abilities.txt, items.txt, ...)
# into an ordered list of Section structs. `fields` maps key => [values...]
# (an array because trainers.txt-style files legitimately repeat keys).
def parse_flat(lines)
  sections = []
  current = nil
  lines.each_with_index do |raw, idx|
    line_no = idx + 1
    line = raw.sub(/\A\xEF\xBB\xBF/, "").rstrip # strip BOM if present
    next if line.empty? || line.start_with?("#")

    if (m = line.match(/\A\[(.+)\]\z/))
      current = Section.new(m[1], line_no, Hash.new { |h, k| h[k] = [] })
      sections << current
      next
    end

    next unless current

    if (m = line.match(/\A(\s*)([A-Za-z0-9_]+)\s*=\s*(.*)\z/))
      indent, key, value = m[1], m[2], m[3]
      current.fields[key] << { value: value, line_no: line_no, indent: indent.length }
    elsif line.strip != ""
      current.fields["__syntax_error__"] << { value: line, line_no: line_no, indent: 0 }
    end
  end
  sections
end

def check_comma_spacing(sections, filename, errors)
  sections.each do |sec|
    sec.fields.each do |key, entries|
      next unless LIST_FIELDS.include?(key)
      entries.each do |e|
        if e[:value] =~ /,\s+\S/
          errors << "#{filename}:#{e[:line_no]} [#{sec.id}] Bad list format in `#{key}`: space after comma"
        end
      end
    end
  end
end

def check_syntax_errors(sections, filename, errors)
  sections.each do |sec|
    (sec.fields["__syntax_error__"] || []).each do |e|
      errors << "#{filename}:#{e[:line_no]} [#{sec.id}] Line is not a valid `key = value` pair: #{e[:value].strip}"
    end
  end
end

def check_duplicate_ids(sections, filename, errors)
  seen = Hash.new(0)
  sections.each { |sec| seen[sec.id] += 1 }
  seen.each do |id, count|
    next if count <= 1
    errors << "#{filename} Duplicate ID: [#{id}] appears #{count} times"
  end
end

def check_required_fields(sections, filename, errors)
  required = REQUIRED_FIELDS[filename]
  return unless required && !required.empty?
  sections.each do |sec|
    required.each do |field|
      next if sec.fields.key?(field)
      errors << "#{filename}:#{sec.line_no} [#{sec.id}] Missing required field: #{field}"
    end
  end
end

def single_value(sec, key)
  entries = sec.fields[key]
  return nil unless entries && !entries.empty?
  entries.first[:value]
end

def check_pokemon_crossrefs(sections, filename, errors)
  species_ids = sections.map(&:id).to_h { |id| [id, true] }
  moves_dir = File.join(PBS_DIR, "moves.txt")
  abilities_dir = File.join(PBS_DIR, "abilities.txt")
  move_ids = File.exist?(moves_dir) ? parse_flat(File.readlines(moves_dir)).map(&:id).to_h { |id| [id, true] } : {}
  ability_ids = File.exist?(abilities_dir) ? parse_flat(File.readlines(abilities_dir)).map(&:id).to_h { |id| [id, true] } : {}

  sections.each do |sec|
    if (evo = single_value(sec, "Evolution"))
      tokens = evo.split(",")
      tokens.each_slice(3) do |target, _method, _param|
        next if target.nil? || target.strip.empty?
        unless species_ids.key?(target)
          errors << "#{filename}:#{sec.line_no} [#{sec.id}] Evolution references unknown species: #{target}"
        end
      end
    end

    if (moves = single_value(sec, "Moves"))
      tokens = moves.split(",")
      tokens.each_slice(2) do |_level, move_name|
        next if move_name.nil?
        unless move_ids.key?(move_name)
          errors << "#{filename}:#{sec.line_no} [#{sec.id}] Moves references unknown move: #{move_name}"
        end
      end
    end

    %w[TutorMoves EggMoves].each do |key|
      next unless (val = single_value(sec, key))
      val.split(",").each do |move_name|
        next if move_name.strip.empty?
        unless move_ids.key?(move_name)
          errors << "#{filename}:#{sec.line_no} [#{sec.id}] #{key} references unknown move: #{move_name}"
        end
      end
    end

    %w[Abilities HiddenAbilities].each do |key|
      next unless (val = single_value(sec, key))
      val.split(",").each do |ability_name|
        next if ability_name.strip.empty?
        unless ability_ids.key?(ability_name)
          errors << "#{filename}:#{sec.line_no} [#{sec.id}] #{key} references unknown ability: #{ability_name}"
        end
      end
    end
  end
end

def check_trainers_crossrefs(sections, filename, errors)
  pokemon_path = File.join(PBS_DIR, "pokemon.txt")
  moves_path = File.join(PBS_DIR, "moves.txt")
  items_path = File.join(PBS_DIR, "items.txt")
  trainer_types_path = File.join(PBS_DIR, "trainer_types.txt")
  species_ids = File.exist?(pokemon_path) ? parse_flat(File.readlines(pokemon_path)).map(&:id).to_h { |id| [id, true] } : {}
  move_ids = File.exist?(moves_path) ? parse_flat(File.readlines(moves_path)).map(&:id).to_h { |id| [id, true] } : {}
  item_ids = File.exist?(items_path) ? parse_flat(File.readlines(items_path)).map(&:id).to_h { |id| [id, true] } : {}
  trainer_type_ids = File.exist?(trainer_types_path) ? parse_flat(File.readlines(trainer_types_path)).map(&:id).to_h { |id| [id, true] } : {}

  sections.each do |sec|
    trainer_type = sec.id.split(",").first
    if trainer_type && !trainer_type_ids.key?(trainer_type)
      errors << "#{filename}:#{sec.line_no} [#{sec.id}] Trainer type not defined in trainer_types.txt: #{trainer_type}"
    end

    (sec.fields["Pokemon"] || []).each do |entry|
      species = entry[:value].split(",").first
      next if species.nil? || species.strip.empty?
      unless species_ids.key?(species)
        errors << "#{filename}:#{entry[:line_no]} [#{sec.id}] Pokemon references unknown species: #{species}"
      end
    end

    (sec.fields["Moves"] || []).each do |entry|
      entry[:value].split(",").each do |move_name|
        next if move_name.strip.empty?
        unless move_ids.key?(move_name)
          errors << "#{filename}:#{entry[:line_no]} [#{sec.id}] Moves references unknown move: #{move_name}"
        end
      end
    end

    (sec.fields["Item"] || []).each do |entry|
      item_name = entry[:value].strip
      next if item_name.empty?
      unless item_ids.key?(item_name)
        errors << "#{filename}:#{entry[:line_no]} [#{sec.id}] Item references unknown item: #{item_name}"
      end
    end
  end
end

# Files whose schema is documented in .claude/rules/pbs-files.md and follows
# the standard "[ID] + key = value" section format with unique IDs. Many other
# PBS/*.txt files (battle facility lists, cup rosters, regional dexes, etc.)
# use ad-hoc sub-formats — semicolon-delimited rows, repeated non-unique tags
# like [Trainer]/[TrainerList] as record separators, or bare name lists under
# a single [0] header. Validating those against the standard schema produces
# false positives, so they're only checked for basic readability, not schema
# conformance.
FULLY_VALIDATED_FILES = %w[pokemon.txt moves.txt trainers.txt abilities.txt items.txt].freeze

def validate_file(path)
  filename = File.basename(path)
  lines = File.readlines(path, encoding: "UTF-8")
  sections = parse_flat(lines)
  errors = []

  unless FULLY_VALIDATED_FILES.include?(filename)
    return [filename, sections.size, errors, :skipped]
  end

  check_syntax_errors(sections, filename, errors)
  check_duplicate_ids(sections, filename, errors)
  check_comma_spacing(sections, filename, errors)
  check_required_fields(sections, filename, errors)

  case filename
  when "pokemon.txt"
    check_pokemon_crossrefs(sections, filename, errors)
  when "trainers.txt"
    check_trainers_crossrefs(sections, filename, errors)
  end

  [filename, sections.size, errors, :validated]
end

def print_report(results)
  puts "PBS Validation Report"
  puts "====================="
  total_errors = 0
  results.each do |filename, count, errors, status|
    puts
    puts "File: #{filename}"
    if status == :skipped
      puts "  · Non-standard format, not schema-validated (see FULLY_VALIDATED_FILES)"
      next
    end
    if errors.empty?
      puts "  ✓ Syntax valid"
      puts "  ✓ #{count} sections defined"
      puts "  ✓ All checked cross-references valid"
    else
      errors.each { |e| puts "  ✗ #{e}" }
      total_errors += errors.size
    end
  end
  puts
  validated = results.reject { |_, _, _, status| status == :skipped }
  files_with_errors = validated.count { |_, _, errors, _| !errors.empty? }
  verdict = files_with_errors.zero? ? "COMPLETE" : "NEEDS FIXES"
  puts "Summary: #{files_with_errors} file(s) with errors, #{validated.size - files_with_errors} file(s) valid, " \
       "#{results.size - validated.size} file(s) skipped (non-standard format) — #{total_errors} total error(s)"
  puts "Verdict: #{verdict}"
  total_errors.zero?
end

arg = ARGV[0] || "all"
targets =
  if arg == "all"
    Dir.glob(File.join(PBS_DIR, "*.txt")).sort
  else
    [File.join(PBS_DIR, arg)]
  end

if targets.empty? || targets.any? { |t| !File.exist?(t) }
  warn "PBS file(s) not found under #{PBS_DIR}"
  exit 1
end

results = targets.map { |path| validate_file(path) }
ok = print_report(results)
exit(ok ? 0 : 1)
