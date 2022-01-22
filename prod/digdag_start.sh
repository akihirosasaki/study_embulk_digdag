#!/usr/bin/env bash

digdag server --config /etc/server.properties --task-log /var/lib/digdag/logs/tasks -b 0.0.0.0 --database digdag
