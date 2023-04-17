gcc -S -w -Og -fverbose-asm ../tests/test.c -o test.s
gcc -c test.s -o test.o
gcc test.o -o test
./test
rm test.o test