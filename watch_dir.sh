#!/usr/bin/bash

SLEEP_TIME=5

if [[ -n $1 ]]; then SLEEP_TIME=$1; fi


CONTENTS=
OLD_CONTENTS=

while [[ 1 ]]; do

    OLD_CONTENTS=$CONTENTS
    CONTENTS=`ls`

    if [[ $OLD_CONTENTS != $CONTENTS ]]; then
    
        echo $CONTENTS

    fi

    sleep $SLEEP_TIME;

done;
