SRC=main.tex

ENTRIES := $(patsubst %.yaml,%.tex,$(wildcard yaml/*.yaml))

all: $(ENTRIES)
	xelatex $(SRC)
	#rubber --module xelatex --pdf $(SRC)

%.tex : %.yaml
	scripts/compile.pl $< $@

clean:
	rm -f main.pdf *.aux *.log yaml/*.tex
