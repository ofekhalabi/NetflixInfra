#!/bin/bash
sudo cp nginx-config /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx.service

