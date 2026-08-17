#!/usr/bin/env awk -f

# skip blank lines globally
/^[[:space:]]*$/ { next }

# join lines into paragraphs without unnecessary newlines
function read_body(     para) {
    while (1) {
        if (!getline) break # read next line, exit on EOF
        if ($0 == "&&") break # stop at end of section
        if ($0 ~ /^[[:space:]]*$/) {
            # if we found a blank line, start a new paragraph
            if (para != "") { print para > out; para=""; }
        } else {
            sub(/^[[:space:]]*/,"") # leading spaces
            sub(/[[:space:]]*$/,"") # trailing spaces
            if (para != "") para = para " " $0
            else para = $0
        }
    }

    # flush any remaining paragraph
    if (para != "") { print para > out; para=""; }
}

# ---- KEY MESSAGES ----
/^\.KEY MESSAGES/ {
    out = "key_messages.txt"

    getline # skip "Updated" line
    read_body()
    close(out)
    next
}

# ---- SHORT TERM ----
/^\.SHORT TERM/ {
    out = "short_term.txt"

    getline # time range line
    if ($0 ~ /^\(.*\)$/) {
        gsub(/[()]/, "")
        print $0 "\n" > out
    }

    getline # Issued line
    read_body()
    close(out)
    next
}

# ---- LONG TERM ----
/^\.LONG TERM/ {
    out = "long_term.txt"

    getline            # time range
    if ($0 ~ /^\(.*\)$/) {
        gsub(/[()]/, "")
        print $0 "\n" > out
    }
    getline            # Issued line
    read_body()
    close(out)
    next
}
