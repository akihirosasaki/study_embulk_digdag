#!/usr/bin/env bash

sleep 30
digdag server --config /etc/server.properties --task-log /var/lib/digdag/logs/tasks -b 0.0.0.0 --database digdag

sleep 30
digdag push test --project /tmp/digdag/