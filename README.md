# Description

This is a a template project for running D on an stm32f401re.

The project runs on a nucleo 401re. The demo show a blinking led, that can be turned on/off with the user button.

# Dependencies

* [opencm3](https://libopencm3.org/)
* [dpp](https://code.dlang.org/packages/dpp)
* [openocd](https://openocd.org/)

# Building
* Install all dependencies.
* Clone this repository.
* Check all paths in the makefile

`$ make`

`$ make upload`


# Notes

* If things don't work well try `make clean` and build again.
* If you need to generate the linker script again, run `make link`. Then adjust the resulting script to fit your need, and copy to `stm32f401re.ld`
* Only tested and working with LDC2
