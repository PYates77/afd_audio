import numpy as np
from pykokoro import PipelineConfig, build_pipeline
from pykokoro.generation_config import GenerationConfig
import wave

KEY_MESSAGES_FILE = "output/key_messages.txt"
DISCUSSION_FILE = "output/discussion.txt"
KEY_MESSAGES_OUTPUT = "output/key_messages.wav"
DISCUSSION_OUTPUT = "output/discussion.wav"
FULL_FORECAST_OUTPUT = "output/forecast.wav"
VOICE = "bm_daniel"
SPEED = 1.2
#SAMPLE_RATE = 24000

with open(KEY_MESSAGES_FILE, "r", encoding="utf-8") as file:
    key_messages_text = file.read()

with open(DISCUSSION_FILE, "r", encoding="utf-8") as file:
    discussion_text = file.read()

generation = GenerationConfig(
        speed=SPEED,
        lang='en',
        #pause_mode="auto",
        #pause_clause=0.08,  # Pause after clauses (commas)
        #pause_sentence=1.0,  # Pause after sentences
        #pause_paragraph=1.2,  # Pause after paragraphs
        #pause_variance=0.02,  # Add natural variance
        #random_seed=42,  # For reproducible results (optional)
        )

pipeline = build_pipeline(
        config=PipelineConfig(
            voice=VOICE,
            generation=generation)
        )

res = pipeline.run(key_messages_text)
res.save_wav(KEY_MESSAGES_OUTPUT)
res.release_audio()

res = pipeline.run(discussion_text)
res.save_wav(DISCUSSION_OUTPUT)
res.release_audio()

pipeline.close()

import wave

input_files = [
    "key_messages.wav",
    "discussion.wav",
]

# concat wav files
with wave.open(FULL_FORECAST_OUTPUT, "wb") as output:
    with wave.open(KEY_MESSAGES_OUTPUT, "rb") as f:
        output.setparams(f.getparams())
        output.writeframes(f.readframes(f.getnframes()))

    with wave.open(DISCUSSION_OUTPUT, "rb") as f:
        output.writeframes(f.readframes(f.getnframes()))
