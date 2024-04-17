function grm
    git reset (git merge-base origin/master (git branch --show-current))
end
