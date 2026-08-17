import datetime
import xml.etree.ElementTree as ET

# Creates a RSS feed with exactly one entry
# This is useful to trick robots into thinking this is a podcast
# for example - google home

AUDIO_URL = "https://pyates77.github.io/afd_audio/forecast.wav"
RSS_URL = "https://pyates77.github.io/afd_audio/forecast.xml"
RSS_FILE = "output/forecast.xml"

today = datetime.date.today()

rss = ET.Element("rss", {"version": "2.0"})

channel = ET.SubElement(rss, "channel")

ET.SubElement(channel, "title").text = "Daily Forecast"
ET.SubElement(channel, "link").text = RSS_URL
ET.SubElement(channel, "description").text = "Daily weather forecast"

item = ET.SubElement(channel, "item")

ET.SubElement(item, "title").text = f"Forecast for {today:%B %d, %Y}"
ET.SubElement(item, "description").text = "Today's weather forecast."

ET.SubElement(item, "pubDate").text = (
    datetime.datetime.now()
    .astimezone()
    .strftime("%a, %d %b %Y %H:%M:%S %z")
)

ET.SubElement(item, "guid").text = f"forecast-{today.isoformat()}"

ET.SubElement(
    item,
    "enclosure",
    {
        "url": AUDIO_URL,
        "type": "audio/wav",
    },
)

tree = ET.ElementTree(rss)
ET.indent(tree, space="    ")
tree.write(RSS_FILE, encoding="utf-8", xml_declaration=True)
