./script.sh
./WCTC.o -i ../tests/test.java -s aditya.s
gcc -c aditya.s -o test.o
gcc test.o -o test
./test