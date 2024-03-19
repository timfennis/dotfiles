function gpf
    if set -q argv[1]
        git push --force-with-lease origin $argv
    else
        git push --force-with-lease origin (git branch --show-current)
    end
end
