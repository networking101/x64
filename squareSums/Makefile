squareSum: squareSum.asm
	yasm -g dwarf2 -f elf64 squareSum.asm -l squareSum.lst
	ld -g -o squareSum squareSum.o
clean:
	rm -f squareSum squareSum.lst squareSum.o
