############# Configuration Voltage Settings #############
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

############# SPI Configuration Settings #################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design] 
set_property CONFIG_MODE SPIx4 [current_design] 
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design] 
####################### Clock ##########################
set_property -dict { PACKAGE_PIN R4    IOSTANDARD DIFF_SSTL15 } [get_ports {sys_clk_p}]
create_clock -period 5.00 -waveform {0 2.5} [get_ports {sys_clk_p}]
# Only the positive side of the differential pait needs to be constrined. AR57109 #

################### Push Buttons #######################
set_property -dict {PACKAGE_PIN F15    IOSTANDARD LVCMOS33} [get_ports {rst_n}]
set_property -dict {PACKAGE_PIN L19    IOSTANDARD LVCMOS33} [get_ports {btn_n[0]}]
set_property -dict {PACKAGE_PIN L20    IOSTANDARD LVCMOS33} [get_ports {btn_n[1]}]
set_property -dict {PACKAGE_PIN K17    IOSTANDARD LVCMOS33} [get_ports {btn_n[2]}]
set_property -dict {PACKAGE_PIN J17    IOSTANDARD LVCMOS33} [get_ports {btn_n[3]}]

###################### USB UART ########################
set_property -dict { PACKAGE_PIN L14    IOSTANDARD LVCMOS33 } [get_ports { uart_rx }];
set_property -dict { PACKAGE_PIN L15    IOSTANDARD LVCMOS33 } [get_ports { uart_tx }];

######################### LEDs #########################
set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { led[3] }];
