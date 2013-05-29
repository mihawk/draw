REBAR := ./rebar
DIALYZER := dialyzer
DIALYZER_APPS := kernel stdlib sasl inets crypto public_key ssl
ERL_LIBS=deps
APP := draw 

.PHONY: deps test rel

all: app

app: deps
	@env ERL_LIBS=$(ERL_LIBS) $(REBAR) compile

deps:  $(REBAR)
	@$(REBAR) get-deps

clean:  $(REBAR)
	@$(REBAR) clean

rel: app
	@cd rel && ../$(REBAR) generate

dist: rel
	@mkdir -p dist && tar -zcf dist/$(APP).tar.gz -C rel $(APP)

test: $(REBAR) app
	@$(REBAR) eunit skip_deps=true suites=$(SUITE)

ct: $(REBAR)
	@$(REBAR) ct skip_deps=true

build-plt:
	@$(DIALYZER) --build_plt --output_plt .draw_dialyzer.plt --apps $(DIALYZER_APPS)

dialyze:
	@$(DIALYZER) --src src --plt .draw_dialyzer.plt -Werror_handling \
		-Wrace_conditions -Wunmatched_returns # -Wunderspecs

docs: $(REBAR)
	./deps/edown/edown_make -config priv/edown.config -pa deps/edown/ebin

