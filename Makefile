
CUR_DIR=$(shell pwd)

OPENCM3_DIR=$(HOME)/src/oss/libopencm3

DEVICE=stm32F401re

CC=arm-none-eabi-gcc
DPP=d++
DC=ldc2
LD=arm-none-eabi-ld

LDSCRIPT=generated.stm32F401re.ld

SRCS = demo.d io.d clock.o button.d mcudruntime.d
DPPS = stmbridge.dpp
OBJS = $(patsubst %.dpp,%.o,$(DPPS)) $(patsubst %.d,%.o,$(SRCS))

include $(OPENCM3_DIR)/mk/genlink-config.mk

.PHONY: clean all upload
.SUFFIXES: .dpp
.PRECIOUS: %.d

all: demo

link: $(LDSCRIPT)

demo: $(LDSCRIPT) $(DPPS) $(OBJS)
	$(LD) $(OBJS) --gc-sections -L $(OPENCM3_DIR)/lib/ -lopencm3_stm32f4 -T stm32f401re.ld -o $@.elf

%.d: %.dpp
	$(DPP) --define=STM32F4 --include-path=$(OPENCM3_DIR)/include/ --preprocess-only $<

%.o: %.d
	$(DC) --relocation-model=static -g -march=thumb -mcpu=cortex-m4 --float-abi=hard --betterC -c $<

upload: demo
	openocd -d2 -f board/st_nucleo_f4.cfg -c "program {$<.elf}  verify reset; shutdown;"

include $(OPENCM3_DIR)/mk/genlink-rules.mk

clean:
	rm -f $(OBJS) demo.elf
