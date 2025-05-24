# Clock Property and Oscillator Pin
create_clock -add -name Clock_125_Mhz_Pin -period 8.00 -waveform {0 4} [get_ports {Clock_125_Mhz}];
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {Clock_125_Mhz}];

# Reset Button
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {Reset}];

# Push Buttons
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {S_SET_Key}];
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {Test_Key}];

# LEDs
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {CPU_Active}];
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {FPGA_OK}];
