.PHONY: compile get-deps update-deps test clean deep-clean

compile: get-deps update-deps
	@rebar compile

beams:
	@rebar compile

get-deps:
	@rebar get-deps

update-deps:
	@rebar update-deps

clean:
	@rm -rf traces/*
	@rebar clean

deep-clean: clean
	@rebar delete-deps

setup_dialyzer:
	dialyzer --build_plt --apps erts kernel stdlib mnesia compiler syntax_tools runtime_tools crypto tools inets ssl webtool public_key observer
	dialyzer --add_to_plt deps/*/ebin

analyze: checkplt
	@rebar skip_deps=true dialyze

buildplt:
	@rebar skip_deps=true build-plt

checkplt: buildplt
	@rebar skip_deps=true check-plt

multitail:
		@which multitail || git clone https://github.com/ruanpienaar/multitail
		@cd multitail && make
		@echo "multitail compiled and binary in $PWD/multitail/multitail"
		@echo "can make install if you want."
