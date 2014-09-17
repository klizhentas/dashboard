#!/bin/bash
sudo docker run -p 80:80 -p 8125:8125/udp -p 8083:8083 mailgun/dashboard
