# CS 218 Spring 2026 Assignment #5

OBJS		= hw5.o maze.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: hw5

maze.o: maze.asm
	$(ASM) maze.asm -l maze.lst

hw5.o: hw5.asm 
	$(ASM) hw5.asm -l hw5.lst

hw5: hw5.o maze.o
	$(LD) -o hw5 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
