#!/bin/bash

cd $(dirname $(realpath @0))

STOW_ARGS=$@

stow $STOW_ARGS -t ~ .
