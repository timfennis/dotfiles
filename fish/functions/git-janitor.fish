function git-janitor -d "Clean up stale local branches"
    set -l main_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if test -z "$main_branch"
        set main_branch main
    end

    set -l current_branch (git branch --show-current)

    # Prune remote tracking branches that no longer exist
    echo "Fetching and pruning..."
    git fetch --prune

    # Phase 1: delete branches that are merged into the main branch
    set -l merged (git branch --merged $main_branch | string trim | string match -v "$current_branch" | string match -v "$main_branch")

    if test (count $merged) -gt 0
        echo ""
        echo "Deleting merged branches:"
        for branch in $merged
            git branch -d $branch
        end
    else
        echo "No merged branches to clean up."
    end

    # Phase 2: delete remaining branches older than a cutoff
    set -l remaining (git branch | string trim | string match -v "$current_branch" | string match -v "$main_branch")

    if test (count $remaining) -eq 0
        echo "No remaining branches to review."
        return
    end

    # Default to 3 months, or accept argument like "git janitor 2weeks" / "git janitor 6months"
    set -l cutoff $argv[1]
    if test -z "$cutoff"
        set cutoff "3 months ago"
    else
        # Normalize e.g. "2weeks" -> "2 weeks ago", "6months" -> "6 months ago"
        set cutoff (string replace -r '(\d+)\s*' '$1 ' $cutoff)" ago"
    end

    set -l cutoff_epoch (date -d "$cutoff" +%s 2>/dev/null)
    if test -z "$cutoff_epoch"
        echo "Invalid age: $argv[1] (try e.g. '2weeks', '6months', '1year')"
        return 1
    end

    set -l stale
    set -l fresh
    for branch in $remaining
        set -l epoch (git log -1 --format='%ct' $branch 2>/dev/null)
        if test -z "$epoch"
            set -a stale $branch
            continue
        end
        if test $epoch -lt $cutoff_epoch
            set -a stale $branch
        else
            set -a fresh $branch
        end
    end

    if test (count $stale) -eq 0
        echo ""
        echo "No branches older than "(date -d "$cutoff" +%Y-%m-%d)"."
        echo (count $fresh)" branches are newer — keeping them."
        return
    end

    echo ""
    echo (count $stale)" branches older than "(date -d "$cutoff" +%Y-%m-%d)":"
    for branch in $stale
        set -l date (git log -1 --format='%cr' $branch)
        printf "  %s (%s)\n" $branch $date
    end

    if test (count $fresh) -gt 0
        echo ""
        echo "Keeping "(count $fresh)" newer branches."
    end

    echo ""
    read -P "Delete these "(count $stale)" branches? [y/N] " confirm
    if test "$confirm" = y -o "$confirm" = Y
        for branch in $stale
            git branch -D $branch
        end
    else
        echo "Skipped."
    end
end
