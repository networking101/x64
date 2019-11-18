14.2: 14.2.asm
	yasm -g dwarf2 -f elf64 14.2.asm -l 14.2.lst
	yasm -g dwarf2 -f elf64 stats.asm -l stats.lst
	ld -g -o 14.2 14.2.o stats.o
clean:
	rm -f 14.2 14.2.o 14.2.lst stats.o stats.lst
