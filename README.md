# [NWS Area Forecast Discussion Text To Speech](https://pyates77.github.io/afd_audio/)

A github workflow automatically performs these steps every morning:
* Pull the Denver/Boulder AFD text from NWS website
* Separate sections and format text (expand abbreviations, for example)
* Generate TTS wav files using pykokoro
* Upload output to github pages

Outputs these plaintext files:
* [afd.txt](https://pyates77.github.io/afd_audio/afd.txt) - unformatted AFD plaintext
* [key_messages.txt](https://pyates77.github.io/afd_audio/key_messages.txt) - formatted key_messages
* [discussion.txt](https://pyates77.github.io/afd_audio/discussion.txt) - formatted discussion

Three wav files are output:
* [forecast.wav](https://pyates77.github.io/afd_audio/forecast.wav)
* [key_messages.wav](https://pyates77.github.io/afd_audio/forecast.wav)
* [discussion.wav](https://pyates77.github.io/afd_audio/forecast.wav)

Human-readable html file: [index.html](https://pyates77.github.io/afd_audio/)

You can, for example, point a homeassistant automation to one of the wav files to automatically play the forecast on a speaker.

## Disclaimer
This project has no affiliation with the National Weather Service (NWS). Use of NWS data in this manner is consistent with [weather.gov guidelines](https://www.weather.gov/disclaimer).

Per guidelines, NWS data is provided as-is with no warranties. All manipulation of the source material imported in this project (including text formatting, abbreviation expansion, and text-to-speech generation) are error-prone and will at times produce unintelligible, misleading, or incorrect interpretations of the data. The tool cannot fix typos or anticipate all formatting variations in the source material. The output of this tool cannot be used for safety-critical applications.

This tool provided on an 'as is' basis, without warranties of any kind, either express or implied. The author expressly disclaims all warranties, whether express or implied, including, but not limited to, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement.
