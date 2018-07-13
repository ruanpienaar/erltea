# erltea
#### Erlang trace utility
---
Why are you getting TEA?, when you asked for COFFEE?
Stop pulling your hair out, use tracing :)

Currently erltea uses Redbug found in eper, for doing the remote tracing.

### Getting Started

#### Compiling
```
make 
make multitail ( OPTIONAL )
```

---
Add your nodes to the nodes file
Each entry is a node name seperate by space then the cookie for that node.
```
node1@host1.somewhere cookie1
node2@host2.somewhere cookie2
```
start tracing by using the schnell script ;)
write the trace pattern in double quotes, 
have a look at the [Redbug Trace Pattern examples](https://github.com/massemanet/eper/blob/master/src/redbug.erl#L78).

#### Example 1:
Trace all ets lookups where the table is my_table, and stop when either a time of 10s has been reached, or a maximum of 1000 messages.

```bash
./start_erltea.sh 10 1000 "ets:lookup(Tbl, _) when Tbl == my_table -> return"
```

#### Example 2:
Trace all ets lookups and trace all ets:delete calls for 60s or 100 messages
```bash
./start_erltea.sh 60 100 "ets:lookup/2 -> return" "ets:delete/1" "ets:delete/2"
```