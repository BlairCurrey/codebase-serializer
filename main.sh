#!/bin/bash

# Function to list files recursively, excluding those in .gitignore
list_files() {
    local dir="$1"
    local gitignore="$dir/.gitignore"
    
    # Check if .gitignore exists
    if [ -f "$gitignore" ]; then
        grep -Ev '^\s*(#|$)' "$gitignore" | while IFS= read -r pattern; do
            exclude_args+=("--exclude=$pattern")
        done
    fi
    
    # List files recursively, excluding those in .gitignore
    find "$dir" -type f "${exclude_args[@]}"
}

# Function to generate output for a single file
generate_output() {
    local file="$1"
    local content=$(< "$file")
    
    echo "------------"
    echo "$file"
    echo "------------"
    echo "$content"
    echo "------------"
}

# Main function
main() {
    local dir="$1"
    local output_file="output.txt"
    local gitignore="$dir/.gitignore"
    
    # Check if .gitignore exists
    if [ -f "$gitignore" ]; then
        echo ".gitignore found at $gitignore"
    else
        echo "No .gitignore found in $dir"
    fi
    
    # Generate directory structure section
    echo "Directory Structure:" > "$output_file"
    tree "$dir" >> "$output_file"
    echo >> "$output_file"
    
    # Iterate over files in the directory
    list_files "$dir" | while IFS= read -r file; do
        generate_output "$file" >> "$output_file"
    done
    
    echo "Output written to $output_file"
}

# Check if directory path is provided as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

main "$1"
