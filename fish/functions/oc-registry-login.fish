function oc-registry-login -d "Log in to the OpenShift image registry using the current oc session"
    set -l token (oc whoami -t 2>/dev/null)

    if test $status -ne 0 -o -z "$token"
        echo "Error: You need to log in with 'oc login' first." >&2
        return 1
    end

    printf '%s\n' "$token" | docker login -u openshift --password-stdin default-route-openshift-image-registry.apps.cluster.chp5-prod.npocloud.nl
end
