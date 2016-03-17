# erltea
#### Erlang trace utility
---
Why are you getting TEA?, when you asked for COFFEE?
Stop pulling your hair out, use tracing :)

Currently erltea uses Redbug found in eper, for doing the remote tracing.

#### Getting Started
---
Add your nodes to the nodes file, ( NewLine Seperated, with a NewLine at the end ).
```
node1@host1.somewhere
node2@host2.somewhere
```
start tracing by using the schnell script ;)
write the trace pattern in double quotes, 
have a look at the [Redbug Trace Pattern examples](https://github.com/massemanet/eper/blob/master/src/redbug.erl#L78).
```bash
./erltea.sh Cookie TrcPattern1 TrcPattern2 ... ...
./erltea.sh cookie "ets -> return;stack"
```
and expect traces in the traces directory.
