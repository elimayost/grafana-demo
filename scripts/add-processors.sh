#!/usr/bin/env bash

curl -sk -u "${USERNAME}:${PASSWORD}" https://localhost:9200/_ingest/pipeline/gtd \
  -H 'Content-Type: application/json' \
  -XPUT \
  --data-binary @- << EOF
{
  "processors": [
    {
      "drop": {
        "if" : "ctx.iday == '0' || ctx.imonth == '0'"
      }
    },
    {
      "script": {
        "source": "\
          if (ctx.imonth.toString().length() == 1) { ctx.imonth = '0' + ctx.imonth; }\
          if (ctx.iday.toString().length() == 1) { ctx.iday = '0' + ctx.iday; }\
          ctx.date = ctx.iday + '/' + ctx.imonth + '/' + ctx.iyear + ' 00:00:00';\
        "
      }
    },
    {
      "date": {
        "field": "date",
        "target_field": "timestamp",
        "formats": ["dd/MM/yyyy HH:mm:ss"]
      }
    },
    {
      "script": {
        "source": "\
          LocalDate dt = LocalDate.parse(ctx.iyear + '-' + ctx.imonth + '-' + ctx.iday);\
          ctx.weekday = dt.getDayOfWeek();\
          ctx.weekday_value = dt.getDayOfWeek().getValue();\
        "
      }
    }
  ]
}
EOF

#curl -sk -u "${USERNAME}:${PASSWORD}" https://localhost:9200/_ingest/pipeline/gtd \
#  -H 'Content-Type: application/json' \
#  -XPUT \
#  --data-binary @- << EOF
#EOF

curl -sk -u "${USERNAME}:${PASSWORD}" "https://localhost:9200/${INDEX_NAME}/_settings" \
  -H 'Content-Type: application/json' \
  -XPUT \
  --data-binary @- << EOF
{
  "settings": {
    "index.default_pipeline": "gtd"
  }
}
EOF
