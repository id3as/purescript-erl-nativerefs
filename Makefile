.PHONY: all clean repl

default: all

PS_SRC = src
PS_TEST = test
OUTPUT = output
PS_SOURCEFILES = $(shell find -L ${PS_SRC} ${PS_TEST} -type f -name \*.purs)
PS_ERL_FFI = $(shell find -L ${PS_SRC} ${PS_TEST} -type f -name \*.erl)

all: ./erl-src/compiled_ps

./erl-src/compiled_ps: output/.complete
	rm -f $$PWD/erl-src/compiled_ps
	ln -s $$PWD/output $$PWD/erl-src/compiled_ps

output/.complete: $(PS_SOURCEFILES) $(PS_ERL_FFI) .spago
	echo Stuff updated, running spago
	spago -x test.dhall build --purs-args "--censor-codes=ShadowedName" && touch output/.complete

.spago: test.dhall spago.dhall packages.dhall
	spago -x test.dhall install
	touch .spago

clean:
	rm -rf $(OUTPUT)
