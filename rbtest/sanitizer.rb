def resolve_requires(file_path, processed_files = Set.new)
  return "" unless File.exist?(file_path)
  return "" if processed_files.include?(file_path) # Vérifiez les dépendances circulaires

  content = File.read(file_path)
  processed_files.add(file_path)

  content.gsub!(/^(require|require_relative)\s+['"](.*?)['"]$/) do |match|
    type = $1
    required_file_name = $2
    required_file = type == "require" ? required_file_name + ".rb" : File.join(File.dirname(file_path), required_file_name + ".rb")

    puts "Traitement du fichier : #{required_file}" # Message de débogage

    if File.exist?(required_file)
      resolve_requires(required_file, processed_files)
    else
      match
    end
  end

  content
end

def generate_resolved_file(source_file_path, output_file_path)
  resolved_content = resolve_requires(source_file_path)
  eval(resolved_content)
  File.write(output_file_path, resolved_content)
end

# Utilisation:
source_file_path = "index.rb"
output_file_path = "result.rb"
generate_resolved_file(source_file_path, output_file_path)
