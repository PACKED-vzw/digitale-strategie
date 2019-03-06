#!/bin/bash
#
# author: Nastasia Vanderperren (PACKED/VIAA)
# goal: do a brunnhilde analysis on a parent folder
#
#############################

# variables
parent=$1
base=$2

# brunnhilde
brunnhilde.py --hash MD5 --noclam --scanarchives $parent ~/Desktop/$base

