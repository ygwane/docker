#!/bin/bash
URL=${1}

if [[ $# -eq 1 ]]
then
  docker run -it --rm wpscanteam/wpscan -u ${URL}
else
  echo "Bad args, enter complete URL like: https://www.wordpress.fr"
  exit 1
fi
