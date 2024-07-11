#!/bin/bash

# This script is designed to update the version number in a local JSON file (VERSION.json)
# with the latest version number for Radarr for Linux, which it fetches from the Radarr API.
# It uses the 'curl' command to fetch the latest version, 'jq' to parse and manipulate JSON data,
# and 'tee' to write the output back to VERSION.json.

url="https://services.sonarr.tv/v1/releases"

response_json=$(curl -fsSL "${url}" | jq -e '.["v4-stable"]') || exit 1
version=$(jq -re .version <<< "${response_json}")
branch=$(jq -re .branch <<< "${response_json}")
amd64_url=$(jq -re '.linuxMusl.x64.archive.url' <<< "${response_json}")
arm64_url=$(jq -re .linuxMusl.arm64.archive.url <<< "${response_json}")
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg branch "${branch}" \
    --arg amd64_url "${amd64_url}" \
    --arg arm64_url "${arm64_url}" \
    '.version = $version | .branch = $branch | .amd64_url = $amd64_url | .arm64_url = $arm64_url' <<< "${json}" | tee VERSION.json
