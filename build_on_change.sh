#!/bin/bash

BUILD_COMMAND="pdflatex -halt-on-error"
SLEEP_TIME=5
CHKSUM_COMMAND="md5sum"

function do_build
{
    $BUILD_COMMAND $1;
}


do_build $1

FILE_CHKSUM=$( $CHKSUM_COMMAND $1 );
OLD_CHKSUM=$FILE_CHKSUM;

while [[ 1 ]]; do
    FILE_CHKSUM=$( $CHKSUM_COMMAND $1 );
    if [[ $FILE_CHKSUM != $OLD_CHKSUM ]]; then
	do_build $1
	OLD_CHKSUM=$FILE_CHKSUM;
    fi
    sleep $SLEEP_TIME;
done

