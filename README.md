# TinyDiv
10 MHz to 1PPS frequency divider with ATtiny85

Input
* 10 MHz at CLKI (Pin2)

Outputs
* 1PPS-Output at PB2 (Pin7)
* 10kHz at PB0 (Pin5)
* 10Hz at PB1 (Pin6)

![schematic](schematic.png)

## Build
On Debian-like Linux, compiling the .ASM assembler-sources into a HEX-file that can be written to the ATTiny can be done with avra:

Get avra:
```
sudo apt install avra
```

Compile assembler-sources
```
avra -l div01.lst div01.asm
```
