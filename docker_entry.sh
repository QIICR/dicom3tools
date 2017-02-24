#!/bin/bash

BIN_DIR=`ls /usr/src/dicom3tools/bin`
CLI_DIR=/usr/src/dicom3tools/bin/${BIN_DIR}

if [ -e $CLI_DIR ]; then

  CLIs=`cd ${CLI_DIR};find . -type f -perm 755 | cut -d'/' -f 2 | tr '\n' ' '`

  requestedCLI=${CLI_DIR}/${1}

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
else
  echo $CLI_DIR does not exist!
fi
