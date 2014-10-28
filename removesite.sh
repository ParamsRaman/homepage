#!/bin/sh

#This script is used to cleanup the _site directory (that gets generated on running the deploy.sh) to prevent it from being checked into github.
rm -rv _site
