function oc-login
    set env prod

    if count $argv >/dev/null
        set env $argv[1]

        if not contains $env prod test
            echo "Error: Unknown environment '$env'. Expected 'prod' or 'test'."
            return 1
        end
    end

    oc login --server=https://api.cluster.chp5-$env.npocloud.nl:6443 --web
end
