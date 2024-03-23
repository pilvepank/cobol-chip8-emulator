all:
	cobc -free -x -Wall -Icopybooks src/chip8_core.cbl -o chip8_core
	cobc -free -x -Wall -Icopybooks tests/chip8_test.cbl -o chip8_test
test:
	./chip8_test
clean:
	rm -f chip8_core chip8_test *.exe *.o
