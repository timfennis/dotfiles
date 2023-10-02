function gpf
    if count $argv >0
        git push -f origin $argv
    else
        git push -f origin (git branch --show-current)
    end
end
