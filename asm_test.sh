#!/bin/sh
# Used to test an augmented test.asm file that contains some of the main body of 
#the pseudo assembly generated in gen.asm
# dependacies if on 64-bit machine nasm lib32gcc-4.8-dev 
nasm -felf test.asm -o test.o 
gcc -m32 test.o -o test 
