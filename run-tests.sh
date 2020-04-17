#!/bin/bash

bats_version=`bats -v`
if [[ $? = 172 ]]
then
  echo "Bats is not installed"
  exit 1
else
  echo "Using $bats_version"
fi

jsonschema > /dev/null 2>&1
if [[ $? = 172 ]]
then
  echo "Jsonschema is not installed"
  exit 1
else
  echo "Jsonschema is present"
fi

echo "Testing..."
bats tests