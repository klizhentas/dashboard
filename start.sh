#!/bin/bash
sudo docker run -d -p 80:80 -p 8125:8125/udp -p 8083:8083 -p 8086:8086 mailgun/dashboard
