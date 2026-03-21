function gitleaks -d "Run git-leaks through Docker"
    docker run -v (pwd):/app -w /app ghcr.io/gitleaks/gitleaks:latest $argv
end
