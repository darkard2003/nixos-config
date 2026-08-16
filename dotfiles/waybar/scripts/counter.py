#!/usr/bin/env python3

import json
import time
import sys

count = 0

while True:
    data = {"text": str(count)}
    sys.stdout.write(json.dumps(data) + "\n")
    sys.stdout.flush()
    count += 1
    time.sleep(1)
    
