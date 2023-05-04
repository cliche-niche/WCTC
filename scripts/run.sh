#!/bin/bash

# ./run.sh <path to java file> (without extension)
cd ../src
./WCTC.o -i $1.java -t ../out/tac_$1.txt -s ../out/asm_$1.s
dot -Tpng tree.gv -o ../out/ast_$1.png
gcc -c ../out/asm_$1.s -o ../out/obj_$1.o
gcc ../out/obj_$1.o -o ../out/exec_$1
rm tree.gv tac_unopt.txt
cd ../out
./exec_$1