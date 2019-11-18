example: example.asm
	yasm -g dwarf2 -f elf64 example.asm -l example.lst
	ld -g -o example example.o
clean:
	rm -f example example.lst example.o
