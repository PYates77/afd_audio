# [NWS Area Forecast Discussion Text To Speech](https://pyates77.github.io/afd_audio/)

A github workflow automatically performs these steps every morning:
* Pull AFD text from NWS website
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

