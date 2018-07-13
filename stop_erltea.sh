#!/bin/bash
set -x
for NODE in `cat nodes`; do
    NODEPREF=`echo $NODE | awk -F'@' '{ print $1 }'`
    ps aux | grep "trace_node_$NODEPREF" | grep -v grep | awk '{ print $2 }' | xargs kill
done
