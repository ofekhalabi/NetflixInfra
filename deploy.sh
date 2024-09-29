#!/bin/bash
sudo cat nginx-config > /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx.service
if [ -e /home/ubuntu/nginx-config ]; then
  rm /home/ubuntu/nginx-config
fi
