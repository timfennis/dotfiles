function fftest
    docker compose exec php-fpm composer fftest $argv
    set -l s $status
    if test $s -eq 0
        notify-send -u low PHPUnit "Tests passed ✅"
    else
        notify-send -u critical PHPUnit "Tests failed ❌"
    end
    return $s
end
