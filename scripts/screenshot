#!/bin/bash

# Constants
PICTURES_DIR="$(xdg-user-dir PICTURES)"

openScreenshot(){
    kitty --app-id="user-dialog" --config="/dev/null" -e bash -c "kitten icat '$1'; read -p 'press enter to close...'" 
}

copyText(){
  tesseract "$1" - | wl-copy
}

saveScreenshot(){
  local filename="$1"
  local filepath="$2"

  local save_dir="${PICTURES_DIR}/Screenshot"

  if [ ! -d $save_dir ]; then
    mkdir -p $save_dir
  fi


  local savepath="${PICTURES_DIR}/Screenshot/$filename"
  mv "$filepath" "$savepath"

  notify-send "Screenshot" "Screenshot saved to $savepath"
  
}

notify_and_open() {
    local filename="$1"
    local tmp_path="$2"

    wl-copy < "$tmp_path"

    action=$(notify-send -A "open=Open" -A "save=Save" -A "copy=Copy Text" "Screenshot" "Screenshot $filename taken")

    if [ "$action" = "save" ]; then
      saveScreenshot "$filename" "$tmp_path"
    elif [ "$action" = "copy" ]; then
      copyText "$tmp_path"
    fi
}

take_screenshot() {
    local mode="$1"
    local filename=$(date +"%S:%M:%H_%d-%m-%Y_grim.png")
    local tmp_path="/tmp/$filename"
    
    if [ "$mode" = "full" ]; then
        grim "$tmp_path"
    else
        grim -g "$(slurp)" "$tmp_path"
    fi

    if [ -f "$tmp_path" ]; then
        notify_and_open "$filename" "$tmp_path"
    else
        notify-send "Screenshot failed"
        return 1
    fi
}

if [ "$1" = "full" ]; then
    take_screenshot "full"
else
    take_screenshot "partial"
fi
