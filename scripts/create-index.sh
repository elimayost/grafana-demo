#!/usr/bin/env bash

USERNAME="$1"
PASSWORD="$2"
INDEX_NAME="$3"

curl -sk -u "${USERNAME}":"${PASSWORD}" https://localhost:9200/"${INDEX_NAME}" \
  -XPUT \
  -H 'Content-Type: application/json' \
  --data-binary @- << EOF
{
  "settings": {
    "index": {
      "max_result_window": 50000
    }
  },
  "mappings": {
    "properties": {
      "attacktype1_txt": {
        "type": "keyword",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "city": {
        "type": "keyword",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "country_txt": {
        "type": "keyword",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "eventid": {
        "type": "long"
      },
      "gname": {
        "type": "keyword",
        "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
        }
      },
      "iday": {
        "type": "keyword"
      },
      "imonth": {
        "type": "keyword"
      },
      "individual": {
        "type": "long"
      },
      "iyear": {
        "type": "keyword"
      },
      "weekday": {
        "type": "keyword"
      },
      "weekday_value": {
        "type": "keyword"
      },
      "latitude": {
        "type": "float"
      },
      "longitude": {
        "type": "float"
      },
      "nkill": {
        "type": "long"
      },
      "region_txt": {
        "type": "keyword",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "success": {
        "type": "long"
      },
      "suicide": {
        "type": "long"
      },
      "targtype1_txt": {
        "type": "keyword",
        "fields": {
          "keyword": {
            "type": "keyword",
              "ignore_above": 256
          }
        }
      },
      "timestamp": {
        "type": "date"
      },
      "weaptype1_txt": {
        "type": "keyword",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      }
    }
  }
}
EOF
