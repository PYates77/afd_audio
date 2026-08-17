#!/usr/bin/env bash

URL="https://forecast.weather.gov/product.php?site=NWS&issuedby=FFC&product=AFD&glossary=1"
curl -s $URL | htmlq 'pre.glossaryProduct' --text > afd.txt
awk -f afd.awk afd.txt
