#!/usr/bin/bash

SLEEP_TIME=5

if [[ -n $1 ]]; then SLEEP_TIME=$1; fi


CONTENTS=`ls`
OLD_CONTENTS=

function print_dir_listing
{
    date
    if [[ -z $1 ]]; then
	echo "---EMPTY---"
    else
	echo $CONTENTS
    fi
    echo; echo
}

print_dir_listing $CONTENTS

while [[ 1 ]]; do

    OLD_CONTENTS=$CONTENTS
    CONTENTS=`ls`

    if [[ $OLD_CONTENTS != $CONTENTS ]]; then
	print_dir_listing $CONTENTS
    fi

    sleep $SLEEP_TIME;

done;

