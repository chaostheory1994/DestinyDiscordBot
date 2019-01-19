#!/bin/bash

OUTPUT_DIR="/tmp"
WEBHOOK_URL=""

FILE_URL="$(curl https://www.niris.tv/blog/weekly-reset | grep '<img.*weekly-reset.* />' | grep -Po ' src="\K.*?(?=")' | sed 's/\?.*//')"
OUTPUT_FILE="$OUTPUT_DIR$(echo $FILE_URL | grep -Po '/[^/]*\.[a-z]*$')"

echo Found: $FILE_URL
echo Saving to: $OUTPUT_FILE

if [ -f $OUTPUT_FILE ]; then
	echo $OUTPUT_FILE already exists.
else
	echo Downloading
	wget --output-document="$OUTPUT_FILE" $FILE_URL

	if [ -f $OUTPUT_FILE ]; then
		echo Sending $OUTPUT_FILE to discord
		curl -F "weekly-reset=@$OUTPUT_FILE" $WEBHOOK_URL
	else
		echo Something went wrong. Did not download picture.
	fi
fi
