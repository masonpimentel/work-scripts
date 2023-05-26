#!/bin/bash

# A Simple Install Script to add xealth-devtool
# git hooks to all $XEALTH_ROOT/xealth-* git repos.

echo "Hooks Installed:"
for entry in $XEALTH_ROOT/xealth-*
do
  if [[ -d $entry/.git ]]
  then
    cp ./commit-msg $entry/.git/hooks
    cp ./pre-commit $entry/.git/hooks
    echo " - $entry"
  fi
done
