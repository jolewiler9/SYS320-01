#!/bin/bash
ip addr | grep -oE 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $2}' | grep -v '127.0.0.1'
