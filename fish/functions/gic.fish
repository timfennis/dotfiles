function gic -d "Fetch and checkout a branch if there are no changes"
    # Check for unstaged or uncommitted changes
    if test (git status --porcelain | wc -l) -gt 0
        echo "Error: There are unstaged or uncommitted changes." >&2
        return 1
    end

    # Check if a branch name was provided
    if test (count $argv) -eq 0
        echo "Error: Please provide a branch name." >&2
        return 1
    end

    set branch $argv[1]

    # Fetch the specified branch from origin
    git fetch origin $branch

    # Checkout the branch
    git checkout $branch

    # Print success message in green
    echo -e "\033[32mSuccessfully checked out branch $branch\033[0m"
end
