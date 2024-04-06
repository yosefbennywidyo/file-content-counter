require 'digest'

class FileContentCounter
  CURRENT_FILE = File.basename(__FILE__)

  def initialize(directory)
    @directory = directory
  end

  def count_files_with_same_content
    begin
      file_contents = Hash.new { |hash, key| hash[key] = { count: 0, files: [], content: nil, total_files: nil, total_size: nil } }
      total_files = 0
      total_size  = 0

      Dir.glob(File.join(@directory, '**', '*')).each do |file_path|
        next unless File.file?(file_path)
        next if File.basename(file_path) == CURRENT_FILE
        total_files += 1
        total_size  += File.size(file_path)

        content  = File.read(file_path)
        checksum = Digest::SHA256.hexdigest(content)
        
        file_contents[checksum][:content] = content if file_contents[checksum][:count] == 0
        file_contents[checksum][:count] += 1
        file_contents[checksum][:files] << file_path
        file_contents[checksum][:total_files] = total_files
        file_contents[checksum][:total_size]  = total_size
      end

      [file_contents, total_files, total_size]
    
    rescue => e
      puts "An error occurred: #{e.message}"
      puts e.backtrace.join("\n")
      nil
    end
  end

  def human_readable_size(size_in_bytes)
    units = %w[bytes KB MB GB TB]

    return '0 bytes' if size_in_bytes.nil? || size_in_bytes.zero?

    unit_index = (Math.log(size_in_bytes) / Math.log(1024)).to_i
    unit_index = units.length - 1 if unit_index > units.length - 1

    '%.2f %s' % [size_in_bytes.to_f / 1024**unit_index, units[unit_index]]
  end

end

directory = ARGV[0] || '.' 
counter = FileContentCounter.new(directory)
result = counter.count_files_with_same_content

if result
  file_contents, total_files, total_size = result
  puts ""
  puts ""
  puts ""
  puts "Total files within directory        : #{total_files}"
  puts "Total size of files within directory: #{counter.human_readable_size(total_size)}"

  puts "\nFiles with the same content:"
  file_contents.each do |checksum, data|
    puts "Content   : #{data[:content]}"
    puts "Occurences: #{data[:count]}"
    puts "Total size: #{counter.human_readable_size(data[:total_size])}"
    puts "Files     : #{data[:files]}"
    puts ""
  end
else
  puts "Failed to count files with same content. Check the error message above."
end
