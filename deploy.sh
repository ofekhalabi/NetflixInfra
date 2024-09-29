#!/bin/bash
sudo cat nginx-config > /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx.service

