# Therac-25-x86 (A combination of the C port & x86-64 Assembly)

A recreation of the Therac-25 radiation therapy machine's software in x86-64 assembly with aid from the C port.  Essentially, the 8 second race condition and safety logic is rewritten in assembly while still using a C terminal.

## The learning process

To make this possible, I had to learn computer architectural concepts along the way as I did it (since I am usually a higher level dev).  So that meant I had to learn about CPU registers, how the equations flow (instruction Destination, Source), memory stacking, prologing, calling convention rules for AMD64, and CPU flag registers.

Please note that I did use some AI as a reference guide to help simplify concepts so please do not be mad.  But I did read it to understand crucial concepts further while I typed it.

I first had to understand how variables move between a C file and raw assembly files.  This is where I had to learn to use `global` to export memory addresses, and `extern` to assure the compiler that it existed in my assembly file.  Heh, now I understand why I got those "multiple definition" linker errors.

Another crucial thing I found is that modern Linux randomizes where code is sitting in memory for security reasons.  Which is why I got linker error `relocation against symbol can not be used when making a PIE object`.  In assembly, it needed to look at fixed addresses to find the variables, this is where I learned about the `-no-pie` flag to keep the variables where I put them.

Another bug I found is when testing the MALFUNCTION 54 trigger, it prints a tiny number like 2 rads, right now I am too lazy and tired to fix it so I might update it whenever I have time.

## Prerequisities

### For Ubuntu / Debian / Linux Mint
```bash
sudo apt update
sudo apt install nasm build-essential libncurses5-dev libncursesw5-dev
```

### Fedora / RHEL / CentOS
```bash
sudo dnf install nasm gcc make ncurses-devel
```

### Arch Linux
```bash
sudo pacman -S nasm gcc make ncurses
```

## Building

```bash

# 1 Compile the driver
gcc -Wall -O0 -c therac.c -o therac.o

# 2 Use NASM to assemble the layers
nasm -f elf64 asm/data.s -o out/data.o
nasm -f elf64 asm/computeMode.s -o out/computeMode.o
nasm -f elf64 asm/doBeam.s -o out/doBeam.o

# 3 Link everything
gcc -no-pie therac.o out/data.o out/computeMode.o out/doBeam.o -o therac25 -lcurses

# 4 Run 

./therac25
```
## Quick start commands 

Instructions are quoted from therac.c and therac-25 python port dev [amstelchen](https://github.com/amstelchen/Therac-25):

BEAM TYPE:

    (empty)
    "X": Megavolt X-ray
    "E": Electron-beam therapy

("field light" mode was supposely not implemented in the C source code)

COMMAND:

    "b" or "B" - Start treatment
    "q" or "Q" - Quit program

## Licenses

Therac-25-x86 assembly port is licensed under the [MIT](https://github.com/OniOkami666/Therac-25-x86/blob/master/LICENSE.md) license

The original C implementation is licensed under the [MIT](https://github.com/amstelchen/Therac-25/blob/master/LICENSE) license as well.

## Credits

[amstelchen](https://github.com/amstelchen/Therac-25) - For the original therac.c code and inspiration from his python port of the therac.c code