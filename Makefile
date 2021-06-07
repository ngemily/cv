SRC=main.tex

ENTRIES := $(patsubst %.yaml,%.tex,$(wildcard yaml/*.yaml))

all: $(ENTRIES)
	pdflatex $(SRC)

%.tex : %.yaml
	python3 scripts/compile.py scripts/templates $< $@

clean:
	rm -f main.pdf *.aux *.log yaml/*.tex
