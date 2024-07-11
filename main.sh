#!/bin/bash

printUsage() {
    echo "Usage: $(basename "$0") <directory> <output_file>"
    echo "Example: $(basename "$0") /path/to/codebase codebase-output.md"
}

parse_args() {
    if [ $# -ne 2 ]; then
        echo "Error: Invalid number of arguments."
        exit 1
    fi

    directory="$1"
    output_file="$2"
}

# Map file type for syntax highlighting in markdown code blocks
get_file_type() {
    case "$1" in
    *.java) echo "java" ;;
    *.properties) echo "properties" ;;
    *.py) echo "python" ;;
    *.js) echo "javascript" ;;
    *.html) echo "html" ;;
    *.css) echo "css" ;;
    *.sh) echo "bash" ;;
    *.md) echo "markdown" ;;
    *.go) echo "go" ;;
    *.ts) echo "typescript" ;;
    *.tsx) echo "tsx" ;;
    *.c) echo "c" ;;
    *.cpp | *.cxx | *.cc) echo "cpp" ;; # Covers C++ with common extensions
    *.json) echo "json" ;;
    *.toml) echo "toml" ;;
    *.yaml | *.yml) echo "yaml" ;; # Covers both YAML extensions
    *) echo "" ;;
    esac
}

# copy_to_clipboard() {
#   local text="$1"

#   # Try Linux (xclip)
#   if command -v xclip >/dev/null; then
#     echo "$text" | xclip -selection clipboard
#     echo "Copied to clipboard (Linux)"
#     return 0
#   fi

#   # Try macOS (pbcopy)
#   if command -v pbcopy >/dev/null; then
#     echo "$text" | pbcopy
#     echo "Copied to clipboard (macOS)"
#     return 0
#   fi

#   # Try Windows (WSL, using clip.exe)
#   if command -v clip.exe >/dev/null; then
#     echo "$text" | clip.exe
#     echo "Copied to clipboard (WSL)"
#     return 0
#   fi

#   # Fallback
#   echo "Could not copy to clipboard"
#   return 1
# }

serialize_codebase_markdown() {
    local directory="${1%/}" # strip trailing /
    local output_file="$2"
    local git_temp_init=false
    local start_dir=$(pwd) # Save the starting directory

    # Create or empty the output file
    >"$output_file"

    # Change to the codebase directory
    cd "$directory" || {
        echo "Error: Cannot change to directory $directory"
        return 1
    }

    if [ -f ".gitignore" ]; then
        echo ".gitignore file found and used in $directory"
    fi

    # Add files to the git index
    git add . >/dev/null 2>&1
    # list of files that are not ignored
    files=$(git ls-files --cached --others --exclude-standard)
    # Remove the temporary git repository if it was created
    if [ "$git_temp_init" = true ]; then
        rm -rf .git
    fi

    # Change back to the starting directory
    cd "$start_dir" || {
        echo "Error: Cannot change back to the starting directory $start_dir"
        return 1
    }

    # Process each file and serialize it to markdown
    echo "$files" | while read -r file_path; do
        file_type=$(get_file_type "$directory/$file_path")
        echo "# $directory/$file_path" >>"$output_file"
        if [ -n "$file_type" ]; then
            echo "\`\`\`$file_type" >>"$output_file"
        else
            echo "\`\`\`" >>"$output_file"
        fi
        cat "$directory/$file_path" >>"$output_file"
        echo "\`\`\`" >>"$output_file"
        echo >>"$output_file"
    done
}

parse_args "$@"
serialize_codebase_markdown "$directory" "$output_file"
