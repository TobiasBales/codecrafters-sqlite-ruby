database_file_path = ARGV[0]
command = ARGV[1]

if command == ".dbinfo"
  File.open(database_file_path, "rb") do |database_file|
    puts "Logs from your program will appear here"

    database_file.seek(16)  # Skip the first 16 bytes of the header
    page_size = database_file.read(2).unpack("n")[0]
    write_format = database_file.read(1).unpack("C")[0]
    read_format = database_file.read(1).unpack("C")[0]
    puts "database page size: #{page_size}"
    puts "write format: #{write_format}"
    puts "read format: #{read_format}"
  end
end
