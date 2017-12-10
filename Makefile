all: calc

%: %.asm
	@nasm -felf $<
	@gcc -m32 $@.o -o calc
	@echo 'make: arquivo executável gerado.'
run:
	./calc

clean:
	rm *.o
	rm calc
	echo 'make: arquivos objeto e executável deletados.'

.SILENT: all run clean
