#!/usr/bin/env bash

URL="https://forecast.weather.gov/product.php?site=BOU&issuedby=BOU&product=AFD&format=txt&version=1&glossary=1"
curl -s $URL | htmlq 'pre.glossaryProduct' --text > afd.txt
awk -f afd.awk afd.txt
