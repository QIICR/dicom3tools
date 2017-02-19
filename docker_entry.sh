#!/bin/bash

CLIs=`cd /usr/src/dicom3tools/bin/1.4.9.8.x8664/;find . -type f -perm 755 | cut -d'/' -f 2 | tr '\n' ' '`

requestedCLI=/usr/src/dicom3tools/bin/1.4.9.8.x8664/${1}

if [ $# -lt 1 ]; then
  echo "Usage: docker run -v<HOST DIRECTORY>:<CONTAINER DIRECTORY> qiicr/dicom3tools <dicom3tools tool> <arguments>"
  echo "Recognized dicom3tools commands: ${CLIs}"
else
  if [ -x $requestedCLI ]; then
    $requestedCLI ${@:2}
  else
    echo "Command not recognized! Recognized dicom3tools commands: ${CLIs}"
  fi
fi
