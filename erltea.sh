#!/bin/bash
# $1 - cookie
# $@ - Trace patterns seperated by spaces ( as specified by redbug ).
DIR=`dirname $0`
#killem' ( works on mac though... )
#ps ux | grep beam | grep trace_ | awk '{ print $2 }' | xargs kill

# All of this was created, to facilitate tracing multiple modules from the cmdline.
for NODE in `cat nodes`; do
    echo "$@"
    echo $NODE
    NODEPREF=`echo $NODE | awk -F'@' '{ print $1 }'`
    erl -pa $DIR/ebin -pa $DIR/deps/*/ebin \
    -sname "trace_node_$NODEPREF"  -setcookie $1 \
    -noshell -hidden -run erltea trace "$NODE" "$@" &
done
