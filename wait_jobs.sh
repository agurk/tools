#!/usr/bin/bash
#
# Script that waits for all jobs spawned in current shell
# to finish

for job in `jobs -p`
do
	wait $job 2> /dev/null
done
