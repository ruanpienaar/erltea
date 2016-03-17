# erltea
Erlang trace utility

Why are you getting TEA?, when you asked for COFFEE?
Stop pulling your hair out, use tracing :)

The current implementation uses Redbug found in eper.

Add your nodes to the nodes file, ( NewLine Seperated ).

node1@host1.somewhere
node2@host2.somewhere

start tracing by using the schnell script ;)

./erltea.sh Cookie TrcPattern1 TrcPattern2 ... ...
./erltea.sh cookie "ets -> return;stack"

and expect traces in the traces directory.