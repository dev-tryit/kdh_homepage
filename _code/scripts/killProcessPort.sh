#!/bin/bash

print($1)
info=$(lsof -t -i:$1)
kill -9 $info