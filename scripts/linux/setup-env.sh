#!/bin/bash

mkdir -p /${HOME}/meteor/<%= appName %>/
mkdir -p /${HOME}/meteor/<%= appName %>/config
mkdir -p /${HOME}/meteor/<%= appName %>/tmp

sudo npm install -g forever userdown wait-for-mongo node-gyp
