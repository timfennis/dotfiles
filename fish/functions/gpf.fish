function gpf
    if set -q argv[1]
        git push -f origin $argv
    else
        git push -f origin (git branch --show-current)
    end
end
