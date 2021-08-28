from pytube import YouTube
import os

yt = YouTube("https://www.youtube.com/watch?v=h3sdYv3Ky40")

out_file = yt.streams.filter(only_audio=True).first().download()

# os.rename(out_file, "data/music/노라조-형.mp3")
os.rename(out_file, "data/music/웅산-인생.mp3")
