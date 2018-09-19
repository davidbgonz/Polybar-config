#!/usr/bin/env python3

import time, sys
import argparse
import json

# Option for bar size
parser = argparse.ArgumentParser(description='Bar size.')
parser.add_argument('size', metavar='N', type=int, nargs='?', help='bar size in character number')
barSize = parser.parse_args()

# update_progress() : Displays or updates a console progress bar
## Accepts a float between 0 and 1. Any int will be converted to a float.
def update_progress(progress):
    # barLength accepts a size argument, but defaults if no option
    barLength = barSize.size if barSize.size else 40
    status = ""
    if isinstance(progress, int):
        progress = float(progress)
    if not isinstance(progress, float):
        progress = 0
        status = "error: progress var must be float"
    if progress < 0:
        progress = 0
        status = "error: progress var less than 0"
    block = int(round(barLength*progress))
    text = "{0} {1}".format( "%{T7}─%{T-}"*(block) + "%{T7}│%{T-}" + "%{F#545A6F}%{T7}─%{T-}%{F-}"*(barLength-block), status)
    sys.stdout.write(text)
    sys.stdout.flush()

# Read gpmdp playback.json 
with open('/home/david/.config/Google Play Music Desktop Player/json_store/playback.json') as json_file:
    data = json.load(json_file)
    if data["time"]["total"] != 0:
        time_current = data["time"]["current"]
        time_total = data["time"]["total"]
   
    try:
        time_current
        time_total
    except NameError:
        print("Song time not available.")
    else:
        progress = time_current/time_total

# Drive progress bar
        update_progress(progress)

