SRC=main.tex

all:
	xelatex $(SRC)
	#rubber --module xelatex --pdf $(SRC)

clean:
	rm -f main.pdf main.aux main.log
