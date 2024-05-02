function gff
    if set -q argv[1]
        git pull --ff-only origin $argv
    else
        git pull --ff-only origin (git branch --show-current)
    end
end
