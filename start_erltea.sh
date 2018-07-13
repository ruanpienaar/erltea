#!/bin/bash
set -x
DIR=`dirname $0`

mv trace_file_* old/

if [ "$#" -lt "3" ]; then
    echo " Usage "
    echo "./start_erltea.sh SECONDS MESSAGE_COUNT TRACES TRACES ..."
    exit 1
fi

# $1 - max trace time in seconds
# $2 - max trace messages
# $@ ( Rest of args ) - Trace patterns seperated by spaces ( as specified by redbug ).

# Check if nodes file has newline at the end, if not add it...
x=$(tail -c 1 nodes)
if [ "$x" != "" ]
    then echo >> nodes
fi

# Loop over each entry, and start a trace erlang node
while read LINE; do 
    NODE=`echo $LINE | awk '{ print $1 }'`
    COOKIE=`echo $LINE | awk '{ print $2 }'`
    erl -pa $DIR/_build/default/deps/*/ebin -name "trace_node_$NODE" \
    -config sys.config -proto_dist hawk_tcp \
    -noinput -noshell \
    -run erltea trace "$NODE" "$COOKIE" "$@" > "trace_file_$NODE.txt" &
done < nodes

# if multitail installed, start multitail on current trace files
sleep 1
./multitail/multitail trace_file_*
