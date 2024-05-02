function git-clean
    # Backup current branch
    set current_branch (git rev-parse --abbrev-ref HEAD)

    # Switch to master branch
    git checkout master

    # Fetch all branches merged into master
    set merged_branches (git branch --merged master | grep -v '^\*' | grep -v 'master' | sed 's/^\s*//')

    # Iterate over merged branches and delete them
    for branch in $merged_branches
        git branch -d $branch
        # echo "Deleted branch $branch"
    end

    echo "Attempting to switch back to $current_branch"
    git checkout $current_branch
end
