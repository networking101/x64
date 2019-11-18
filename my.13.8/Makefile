my.13.8: my.13.8.asm
	yasm -g dwarf2 -f elf64 my.13.8.asm -l my.13.8.lst
	ld -g -o my.13.8 my.13.8.o
clean:
	rm -f my.13.8 my.13.8.o my.13.8.lst
