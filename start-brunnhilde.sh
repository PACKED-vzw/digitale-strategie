#!/bin/bash
#
# author: Nastasia Vanderperren (PACKED/VIAA)
# goal: do a brunnhilde analysis on a parent folder
#
#############################

# variables
parent=$1
destination=~/Desktop
base=$2

# brunnhilde
brunnhilde.py --hash MD5 --noclam --scanarchives $parent $destination $base

