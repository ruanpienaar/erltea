#!/bin/bash
set -x
DIR=`dirname $0`
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
    erl -pa $DIR/ebin -pa $DIR/deps/*/ebin -sname "trace_node_$NODE" \
    -run erltea trace "$NODE" "$COOKIE" "$@" > "trace_file_$NODE.txt"
    #-noinput -noshell -detached \
done < nodess

# if multitail installed, start multitail on current trace files
# loop over nodes 
# add file to list
# start multitail


# for LINE in `cat nodes`; do
#     N=`echo $LINE | awk '{ print $1 }'`
#     COOKIE=`echo $LINE | awk '{ print $2 }'`
#     echo $N $COOKIE $@
#     # erl -pa $DIR/ebin -pa $DIR/deps/*/ebin -sname "trace_node_$NODE" -setcookie $COOKIE -hidden \
#     # -run erltea trace "$NODE" "$@" > "trace_file_$NODE.txt"
#     #-noinput -noshell -detached \
# done
