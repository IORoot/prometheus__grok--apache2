#!/bin/bash

nohup ./grok_exporter -config londonparkour_apache_errors.yml > /var/log/grok_exporter.log 2>&1 &
