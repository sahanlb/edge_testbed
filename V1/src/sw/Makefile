SOURCE	= test.c
OUTPUT_NAME = firmware
CONFIG = rv32i
ABI = ilp32
LINKER = firmware.ld
# CROSS = riscv64-linux-gnu-
CROSS = riscv64-unknown-elf-
CROSSCFLAGS = -O3 -Wno-int-conversion -march=$(CONFIG) -mabi=$(ABI) -ffreestanding -nostdlib
# CROSSLDFLAGS = -march=$(CONFIG) -mabi=$(ABI) -ffreestanding -nostdlib -mbig-endian -Wl,-M
CROSSLDFLAGS = -march=$(CONFIG) -mabi=$(ABI) -ffreestanding -nostdlib -Wl,-M
UART_PORT = ttyUSB1


.PHONY: all
all:	$(OUTPUT_NAME).hex


$(OUTPUT_NAME).o: $(SOURCE)
	#$(CROSS)gcc $(CROSSCFLAGS) -c -o $@  $<
	$(CROSS)gcc $(CROSSCFLAGS) -O0 -c -o $@  $<
	
$(OUTPUT_NAME).elf: $(OUTPUT_NAME).o
	$(CROSS)gcc $(CROSSLDFLAGS) -T $(LINKER) -o $@   Reset_Handler.S $<
	
    
$(OUTPUT_NAME).hex: $(OUTPUT_NAME).elf
	$(CROSS)objcopy -O verilog $< /dev/stdout > $@
	#$(CROSS)objcopy -O verilog --verilog-data-width=4 $< /dev/stdout > $@
	#$(CROSS)objcopy -O verilog --gap-fill 00000000 --verilog-data-width=4 --reverse-bytes=4 $< /dev/stdout > $@

wordaddr: $(OUTPUT_NAME).elf
	$(CROSS)objcopy -O verilog --verilog-data-width=4 $(OUTPUT_NAME).elf /dev/stdout > $(OUTPUT_NAME)_wordaddr.hex



.PHONY: dump
dump: $(OUTPUT_NAME).o $(OUTPUT_NAME).elf
	$(CROSS)objdump -S $(OUTPUT_NAME).o | less > $(OUTPUT_NAME).o.dump
	$(CROSS)objdump -S $(OUTPUT_NAME).elf | less > $(OUTPUT_NAME).elf.dump
	
.PHONY: load
load: $(OUTPUT_NAME).hex
	python3 load.py $(UART_PORT)
	
.PHONY: clean
clean:
	rm *.o
	rm *.elf
	rm *.hex
	rm *.dump
