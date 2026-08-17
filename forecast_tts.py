import numpy as np
import soundfile as sf
from pykokoro import PipelineConfig, build_pipeline
from pykokoro.generation_config import GenerationConfig

INPUT_FILE = "key_messages.txt"
OUTPUT_FILE = "output/forecast.wav"
VOICE = "bm_daniel"
SPEED = 1.2
#SAMPLE_RATE = 24000

with open(INPUT_FILE, "r", encoding="utf-8") as file:
    text = file.read()


generation = GenerationConfig(speed=SPEED)
pipeline = build_pipeline(
        config=PipelineConfig(
            voice=VOICE,
            generation=generation)
        )

res = pipeline.run(text)
res.save_wav(OUTPUT_FILE)
res.release_audio()
pipeline.close()
