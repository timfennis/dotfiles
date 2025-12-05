function fp
    if test (count $argv) -lt 1
        echo "usage: fp <file>"
        return 1
    end

    set file $argv[1]

    cargo build --release
    and perf record --call-graph dwarf target/release/ndc $file
    and perf report
end
