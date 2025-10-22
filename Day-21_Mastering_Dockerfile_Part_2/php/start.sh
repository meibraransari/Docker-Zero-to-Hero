#!/bin/bash
# start all the services
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
