#!/bin/bash

read n
cd ../src
for i in $(seq 1 $n)
do
    ./WCTC.o -i ../tests/test_$i.java -t ../out/tac_$i.txt -s ../out/asm_$i.s
    dot -Tpng tree.gv -o ../out/ast_$i.png
    gcc -c ../out/asm_$i.s -o ../out/obj_$i.o
    gcc ../out/obj_$i.o -o ../out/exec_$i
done
rm tree.gv tac_unopt.txt