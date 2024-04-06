# File Content Counter

The File Content Counter is a Ruby script that counts the number of files within a directory that have the same content. It also provides information about the total size of files and the content of each group of files with the same content.

## Features

- Counts files with the same content within a directory.
- Displays total files and total size of files within the directory.
- Provides information about files with the same content, including content, occurrences, total size, and file paths.

## Installation

1. Clone the repository to your local machine:

```bash
git clone 
```

2. Navigate to the directory:

```bash
cd file_content_counter
```

3. Usage
Run the script with the following command:

```bash
ruby file_content_counter.rb DIRECTORY_PATH
```

Replace DIRECTORY_PATH with the path of the directory you want to scan. If no directory path is provided, the script will default to the current directory.

Example:

```bash
ruby file_content_counter.rb /path/to/directory
```

## Dependencies
The script requires Ruby and the digest library for hashing functionality.

## Contributing
Contributions are welcome! If you find any bugs or have suggestions for improvements, please open an issue or submit a pull request.
