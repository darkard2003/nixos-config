#!/bin/bash

# Default actions
GENERATE_IMAGE=true
GENERATE_CONFIG=true

# Parse command-line options
while getopts "ic" opt; do
    case $opt in
        i)
            GENERATE_CONFIG=false
            ;;
        c)
            GENERATE_IMAGE=false
            ;;
        \?)
            echo "Usage: $0 [-i] [-c] <image_path>"
            echo "  -i: Only generate the blurred image. Requires <image_path>."
            echo "  -c: Only generate the swaylock config file. <image_path> is optional."
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

IMAGE_PATH="$1"
OUTPUT_DIR="/home/dark/arch-config/swaylock"
BLURRED_IMAGE="$OUTPUT_DIR/lockscreen_blur.png"
CONFIG_FILE="$OUTPUT_DIR/config"
COLORS_FILE="$OUTPUT_DIR/colors.sh"
TEMPLATE_FILE="$OUTPUT_DIR/template"

# Check if an image path is provided when required
if [ "$GENERATE_IMAGE" = true ] && [ -z "$IMAGE_PATH" ]; then
    echo "Error: <image_path> is required when generating the image or both."
    echo "Usage: $0 [-i] [-c] <image_path>"
    echo "  -i: Only generate the blurred image. Requires <image_path>."
    echo "  -c: Only generate the swaylock config file. <image_path> is optional."
    exit 1
fi

# 1. Blur the image (if GENERATE_IMAGE is true)
if [ "$GENERATE_IMAGE" = true ]; then
    echo "Blurring image: $IMAGE_PATH"
    magick "$IMAGE_PATH" -filter Gaussian -resize 20% -define filter:sigma=10.0 -modulate 90,100,100 -resize 2560x1600! "$BLURRED_IMAGE"
fi

# 2. Generate the config file (if GENERATE_CONFIG is true)
if [ "$GENERATE_CONFIG" = true ]; then
    echo "Loading colors from $COLORS_FILE"
    source "$COLORS_FILE"

    # Function to clean color codes (remove # and convert to uppercase)
    clean_color() {
        local color="$1"
        # Remove '#' and convert to uppercase
        echo "$(echo "$color" | sed 's/#//g' | tr '[:lower:]' '[:upper:]')"
    }

    # Pre-process colors with alpha values
    BG_COLOR=$(clean_color "$background")
    FG_COLOR=$(clean_color "$foreground")
    COLOR0_CLEAN=$(clean_color "$color0")
    COLOR1_CLEAN=$(clean_color "$color1")
    COLOR2_CLEAN=$(clean_color "$color2")
    COLOR3_CLEAN=$(clean_color "$color3")
    COLOR4_CLEAN=$(clean_color "$color4")
    COLOR5_CLEAN=$(clean_color "$color5")
    COLOR6_CLEAN=$(clean_color "$color6")
    COLOR7_CLEAN=$(clean_color "$color7")
    COLOR8_CLEAN=$(clean_color "$color8")
    COLOR9_CLEAN=$(clean_color "$color9")
    COLOR10_CLEAN=$(clean_color "$color10")
    COLOR11_CLEAN=$(clean_color "$color11")
    COLOR12_CLEAN=$(clean_color "$color12")
    COLOR13_CLEAN=$(clean_color "$color13")
    COLOR14_CLEAN=$(clean_color "$color14")
    COLOR15_CLEAN=$(clean_color "$color15")

    echo "Generating swaylock config to $CONFIG_FILE"
    sed -e "s|{lockscreen_image_path}|$BLURRED_IMAGE|g" \
        -e "s|{background}|${BG_COLOR}|g" \
        -e "s|{foreground}|${FG_COLOR}|g" \
        -e "s|{color0}|${COLOR0_CLEAN}|g" \
        -e "s|{color1}|${COLOR1_CLEAN}|g" \
        -e "s|{color2}|${COLOR2_CLEAN}|g" \
        -e "s|{color3}|${COLOR3_CLEAN}|g" \
        -e "s|{color4}|${COLOR4_CLEAN}|g" \
        -e "s|{color5}|${COLOR5_CLEAN}|g" \
        -e "s|{color6}|${COLOR6_CLEAN}|g" \
        -e "s|{color7}|${COLOR7_CLEAN}|g" \
        -e "s|{color8}|${COLOR8_CLEAN}|g" \
        -e "s|{color9}|${COLOR9_CLEAN}|g" \
        -e "s|{color10}|${COLOR10_CLEAN}|g" \
        -e "s|{color11}|${COLOR11_CLEAN}|g" \
        -e "s|{color12}|${COLOR12_CLEAN}|g" \
        -e "s|{color13}|${COLOR13_CLEAN}|g" \
        -e "s|{color14}|${COLOR14_CLEAN}|g" \
        -e "s|{color15}|${COLOR15_CLEAN}|g" \
        "$TEMPLATE_FILE" > "$CONFIG_FILE"

    echo "Swaylock config generated successfully!"
fi
