#!/usr/bin/env awk -f

# skip blank lines globally
#/^[[:space:]]*$/ { next }

BEGIN {
    weekday["Mon"] = "Monday"
    weekday["Tue"] = "Tuesday"
    weekday["Wed"] = "Wednesday"
    weekday["Thu"] = "Thursday"
    weekday["Fri"] = "Friday"
    weekday["Sat"] = "Saturday"
    weekday["Sun"] = "Sunday"

    month["Jan"] = "January"
    month["Feb"] = "February"
    month["Mar"] = "March"
    month["Apr"] = "April"
    month["May"] = "May"
    month["Jun"] = "June"
    month["Jul"] = "July"
    month["Aug"] = "August"
    month["Sep"] = "September"
    month["Oct"] = "October"
    month["Nov"] = "November"
    month["Dec"] = "December"

    timezone["MDT"] = "Mountain Daylight Time"
    timezone["MST"] = "Mountain Standard Time"

    am_pm["AM"] = "A.M."
    am_pm["PM"] = "P.M."
}

function format_timestamp(    timestamp, fields, time, ampm, tz, dow, mon, day, year, hour, minute) {
    if (match($0, /[0-9]+ [AP]M [A-Z]+ [A-Za-z]+ [A-Za-z]+ [0-9]+ [0-9]+/)) {
        timestamp = substr($0, RSTART, RLENGTH)

        split(timestamp, fields, " ")

        time = fields[1]
        ampm = fields[2]
        tz = fields[3]
        dow = fields[4]
        mon = fields[5]
        day = fields[6]
        year = fields[7]

        hour = substr(time, 1, length(time) - 2)
        minute = substr(time, length(time) - 1)

        replacement = hour ":" minute " " am_pm[ampm] ", " weekday[dow] ", " month[mon] " " day ", " year

        $0 = substr($0, 1, RSTART - 1) replacement \
             substr($0, RSTART + RLENGTH)
    }
}

# join lines into paragraphs without unnecessary newlines
# replace backticks with apostrophes
# expand common abbreviations
function read_body(para) {
    while (1) {
        if (!getline) break # read next line, exit on EOF
        if ($0 == "&&") break # stop at end of section

        if ($0 ~ /^[[:space:]]*$/) {
            # if we found a blank line, start a new paragraph
            if (para != "") {
                print para > out
                para = ""
            }
        } else {

            format_timestamp()

            gsub(/`/, "'") # afd uses backticks instead of quotes for contractions for some reason

            # expand abbreviations
            gsub(/\<N\>/, "north")
            gsub(/\<NNE\>/, "north-northeast")
            gsub(/\<NE\>/, "northeast")
            gsub(/\<ENE\>/, "east-northeast")
            gsub(/\<E\>/, "east")
            gsub(/\<ESE\>/, "east-southeast")
            gsub(/\<SE\>/, "southeast")
            gsub(/\<SSE\>/, "south-southeast")
            gsub(/\<S\>/, "south")
            gsub(/\<SSW\>/, "south-southwest")
            gsub(/\<SW\>/, "southwest")
            gsub(/\<WSW\>/, "west-southwest")
            gsub(/\<W\>/, "west")
            gsub(/\<WNW\>/, "west-northwest")
            gsub(/\<NW\>/, "northwest")
            gsub(/\<NNW\>/, "north-northwest")

            gsub(/\<aftn\>/, "afternoon")
            gsub(/\<mrng\>/, "morning")
            gsub(/\<chc\>/, "chance")
            gsub(/\<isold\>/, "isolated")
            gsub(/\<PW\>/, "precipitable water")
            gsub(/\<pops\>/, "probability of precipitation")
            gsub(/\<srn\>/, "southern")
            gsub(/\<sern\>/, "southern")
            gsub(/\<nrn\>/, "northern")
            gsub(/\<nern\>/, "northern")
            gsub(/\<ern\>/, "eastern")
            gsub(/\<wern\>/, "western")
            gsub(/\<tstms\>/, "thunderstorms")
            gsub(/\<mtns\>/, "mountains")
            gsub(/\<sfc\>/, "surface")
            gsub(/\<CWA\>/, "County Warning Area")
            gsub(/\<fcst\>/, "forecast")
            gsub(/\<MLCAPE\>/, "ML-CAPE")
            gsub(/\<j\/kg\>/, "joules-per-kilogram")
            gsub(/\<CO\>/, "Colorado")
            gsub(/\<precip\>/, "precipitation")

            gsub(/\<Sat\>/, "Saturday")
            gsub(/\<Sun\>/, "Sunday")
            gsub(/\<Mon\>/, "Monday")
            gsub(/\<Tue\>/, "Tuesday")
            gsub(/\<Wed\>/, "Wednesday")
            gsub(/\<Thu\>/, "Thursday")
            gsub(/\<Fri\>/, "Friday")

            sub(/^[[:space:]]*/, "") # leading spaces
            sub(/[[:space:]]*$/, "") # trailing spaces


            if (para != "") para = para " " $0
            else para = $0
        }
    }

    # flush any remaining paragraph
    if (para != "") {
        print para > out
    }
}

# ---- KEY MESSAGES ----
/^\.KEY MESSAGES/ {
    out = "output/key_messages.txt"

    print "Key Forecast Messages\n" > out
    read_body()
    close(out)
    next
}

# ---- SHORT TERM ----
/^\.SHORT TERM/ {
    out = "output/short_term.txt"

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
    out = "output/long_term.txt"

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
#
# ---- LONG TERM ----
/^\.DISCUSSION/ {
    out = "output/discussion.txt"

    print "Area Forecast Discussion\n" > out
    read_body()
    close(out)
    next
}
