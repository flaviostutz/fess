#!/bin/bash

if [ "$ES_HTTP_URL" != "" ]; then
    export RUN_ELASTICSEARCH=false
    echo "Elasticsearch won't run"
else
    echo "Elasticsearch will run"
fi

/usr/share/fess/run.sh
