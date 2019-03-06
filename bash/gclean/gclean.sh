#!/bin/bash

# File gclean.sh
# @brief
#  Script for automating removal of build output dirs

# Get settings variables
# $searchDir - dir where script will search
# $searchStr - matching string
source $HOME/scripts/bash/gclean/settings.sh

a=$(ls $searchDir | grep $searchStr)
arr=($a)

# Check if result is empty, in that case exit
if [[ -z ${arr[0]} ]]; then
	echo "Did not find any match for $searchStr in $searchDir"
	exit
fi

# Found one or multiple matches, ask user what should be removed
nrOfMatches=${#arr[@]}
echo "Found $nrOfMatches matching result(s):"
for (( c=0; c<$nrOfMatches; c++ )); do
    read -p "Remove ${arr[c]}? (y/n): " yn
    case $yn in
        [Yy]* ) i=${#field[@]}; field[$i]=${arr[c]};;
        [Nn]* ) ;;
        * ) echo "Skipping ${arr[c]}, please answer y or n";; # If awnser was not Yy or Nn
    esac
done
# Get number of dirs to be deleted
nrOfDirs=${#field[@]}

# Loop over number of dires to be deleted, 0 or more
for (( c=0; c<$nrOfDirs; c++ )); do
	echo -en "Deleting ${field[$c]}..."

    # send rm command to foreground
    rm -rf $"$searchDir/${field[$c]}"&

    # check if foreground process is still active
	while ps |grep $! &>/dev/null; do
	        echo -n "." # Keep printing dots (.) until process is terminated
	        sleep 2
	done
	echo " Done"
done
