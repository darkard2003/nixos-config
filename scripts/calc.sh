#!/bin/bash

res=''
for ((;;)); do
  # Use a more descriptive prompt
  out=$(wofi -d --prompt="Calculator" --search="$res")
  
  # Exit if user cancels or provides empty input
  if [[ -z $out ]]; then
    break
  fi
  
  # Skip if input is the same as previous result (avoid infinite loop)
  if [[ "$out" == "$res" ]]; then
    continue
  fi
  
  # Calculate result with error handling
  if res=$(echo "scale=10; $out" | bc -l 2>/dev/null); then
    # Check if bc returned an error (empty result)
    if [[ -z $res ]]; then
      res="Error: Invalid expression"
    fi
  else
    res="Error: Invalid input"
  fi
done

