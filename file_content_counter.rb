# Import the 'digest' library for hashing functionality
require 'digest'

# Define a class named 'FileContentCounter' to count files with the same content
class FileContentCounter
  # Define a constant to store the name of the current file
  CURRENT_FILE = File.basename(__FILE__)

  # Initialize the FileContentCounter class with a directory path
  def initialize(directory)
    @directory = directory
  end

  # Method to count files with the same content within a directory
  def count_files_with_same_content
    begin
      # Create a hash to store file contents, counts, and other information
      file_contents = Hash.new { |hash, key| hash[key] = { count: 0, files: [], content: nil, total_files: nil, total_size: nil } }
      # Initialize variables to track total files and size
      total_files = 0
      total_size  = 0

      # Iterate through each file in the directory
      Dir.glob(File.join(@directory, '**', '*')).each do |file_path|
        # Skip if file not exist
        next unless File.file?(file_path)
        # Skip if the current file is the script file itself
        next if File.basename(file_path) == CURRENT_FILE

        # Increment total files count and add file size to total size
        total_files += 1
        total_size  += File.size(file_path)

        # Read file content and compute checksum
        content  = File.read(file_path)
        checksum = Digest::SHA256.hexdigest(content)

        # Store file content if it's the first occurrence of the checksum
        file_contents[checksum][:content] = content if file_contents[checksum][:count] == 0
        # Increment the occurrence count for the checksum
        file_contents[checksum][:count] += 1
        # Add file path to the list of files with the same content
        file_contents[checksum][:files] << file_path
        # Update total files and size for the checksum
        file_contents[checksum][:total_files] = total_files
        file_contents[checksum][:total_size]  = total_size
      end

      # Return file contents hash, total files count, and total size
      [file_contents, total_files, total_size]
    
    rescue => e
      # Print error message and backtrace if an exception occurs
      puts "An error occurred: #{e.message}"
      puts e.backtrace.join("\n")
      # Return nil to indicate error
      nil
    end
  end

  # Method to convert file size from bytes to human-readable format
  def human_readable_size(size_in_bytes)
    units = %w[bytes KB MB GB TB]

    return '0 bytes' if size_in_bytes.nil? || size_in_bytes.zero?

    unit_index = (Math.log(size_in_bytes) / Math.log(1024)).to_i
    unit_index = units.length - 1 if unit_index > units.length - 1

    '%.2f %s' % [size_in_bytes.to_f / 1024**unit_index, units[unit_index]]
  end

end

# Get directory path from command-line argument or default to current directory
directory = ARGV[0] || '.'
# Create a FileContentCounter instance with the directory path
counter = FileContentCounter.new(directory)
# Call the count_files_with_same_content method to count files with the same content
result = counter.count_files_with_same_content

# Display results if successful, or error message if failed
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
