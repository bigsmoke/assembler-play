#!/bin/sh
nasm showimage.asm && cat bootloader showimage image.bmp  > bigstuff.bin && ./boot bigstuff.bin
