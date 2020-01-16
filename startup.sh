#!/bin/bash

if [ "$ES_HTTP_URL" != "" ]; then
    export RUN_ELASTICSEARCH=false
    echo "Elasticsearch won't run"
else
    echo "Elasticsearch will run"
fi

INIT_FILE=/initialized
if ! [ -f "$INIT_FILE" ]; then

    if [ "$NODE_NAME" != "" ]; then
        echo "scheduler.target.name=$NODE_NAME"
        sed "s/scheduler.target.name=/scheduler.target.name=$NODE_NAME/g" -i /etc/fess/fess_config.properties
        touch $INIT_FILE
    fi

fi

/usr/share/fess/run.sh
