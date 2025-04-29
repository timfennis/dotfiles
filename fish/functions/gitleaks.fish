function gitleaks
    docker run -v (pwd):/app -w /app ghcr.io/gitleaks/gitleaks:latest git -v
end
