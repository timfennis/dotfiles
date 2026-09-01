function theme -d "Toggle system dark/light theme (or set with: theme dark|light)"
    switch "$argv[1]"
        case dark light
            set -f scheme prefer-$argv[1]
        case ''
            if test (gsettings get org.gnome.desktop.interface color-scheme) = "'prefer-dark'"
                set -f scheme prefer-light
            else
                set -f scheme prefer-dark
            end
        case '*'
            echo "usage: theme [dark|light]" >&2
            return 1
    end
    gsettings set org.gnome.desktop.interface color-scheme $scheme
    echo $scheme
end
