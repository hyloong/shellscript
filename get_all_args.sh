#!/bin/bash
n=1
for args in $@
do
	args[$n]=${args}
	echo "${args[$n]}"
	n=$((n+1))
done
