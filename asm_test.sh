#!/bin/sh
# dependacies if on 64-bit machine nasm lib32gcc-4.8-dev 
nasm -felf out.asm -o out.o 
gcc -m32 out.o -o out 
