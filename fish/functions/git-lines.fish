function git-lines
    set file_ext $argv[1]

    echo "Counting lines per author in current HEAD..."
    if test -n "$file_ext"
        echo "Filtering by *.$file_ext files"
    end

    # Check if inside a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Error: Not inside a git repository."
        return 1
    end

    # Build the list of files, filtered by extension if provided
    if test -n "$file_ext"
        set files (git ls-files | grep -E "\.$file_ext\$")
    else
        set files (git ls-files)
    end

    # Exit early if no matching files
    if test (count $files) -eq 0
        echo "No matching files found."
        return 0
    end

    # Blame and count authors
    printf '%s\n' $files | xargs -d '\n' -n 1 git blame --line-porcelain | grep "^author " 2>/dev/null | sed 's/^author //' | sort | uniq -c | sort -nr | awk '{printf "%s: %s lines\n", $2, $1}'
end
