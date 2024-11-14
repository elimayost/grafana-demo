#!/usr/bin/env bash

curl -sk -u "${USERNAME}:${PASSWORD}" "https://localhost:9200/${INDEX_NAME}/_bulk" \
  -H 'Content-Type: application/x-ndjson' \
  -XPOST \
  --data-binary @data/gtd.ndjson | jq
