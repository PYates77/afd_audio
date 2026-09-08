#!/usr/bin/env bash
mkdir -p output

URL="https://forecast.weather.gov/product.php?site=BOU&issuedby=BOU&product=AFD&format=txt&version=1&glossary=1"
curl -s $URL | htmlq 'pre.glossaryProduct' --text > output/afd.txt
awk -f afd.awk output/afd.txt

cat > output/index.html <<EOF
<html>
    <h1>Full Forecast</h1>
    <audio controls src="forecast.wav"></audio>
    <h1>Key Messages</h1>
    <audio controls src="key_messages.wav"></audio>
    <p style="white-space: pre-line;">
$(cat output/key_messages.txt)
    </p>
    <h1>Discussion</h1>
    <audio controls src="discussion.wav"></audio>
    <p style="white-space: pre-line;">
$(cat output/discussion.txt)
    </p>
</html>
EOF
