#!/bin/bash

jq -r '.timestamp, .message' "$1" |
sed 's|\\n|\n|g; s|\\t|\t|g; s|^\"||g; s|\"$||g; s|\\u001b\[0m||g; s|\\u001b\[1\;31m\\r||g; s|\\u001b\[1\;\?32m||g; s|\\u001b\[36m||g; s|\\u001b\[32m||g'
