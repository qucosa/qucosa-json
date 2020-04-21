#!/bin/bash
bats_version=`bats -v`
if [[ $? = 127 ]]
then
  echo "Bats is not installed"
  exit 1
else
  echo "Using $bats_version"
fi

./justify > /dev/null 2>&1
if [[ $? = 127 ]]
then
  echo "Justify is not installed"
  exit 1
else
  echo "Justify is present"
fi

echo "Testing..."
bats tests