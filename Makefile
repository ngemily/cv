SRC=main.tex

ENTRIES := $(patsubst %.yaml,%.tex,$(wildcard yaml/*.yaml))

all: $(ENTRIES)
	rubber --pdf $(SRC)

%.tex : %.yaml
	python scripts/compile.py scripts/templates $< $@

clean:
	rm -f main.pdf *.aux *.log yaml/*.tex
