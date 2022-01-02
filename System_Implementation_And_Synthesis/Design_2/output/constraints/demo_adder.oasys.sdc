#
# Created by 
<<<<<<< HEAD:System_Implementation_And_Synthesis/Design_2/output/constraints/demo_adder.oasys.sdc
#   ../bin/Linux-x86_64-O/oasysGui 19.2-p002 on Sun Dec 26 00:06:27 2021
=======
#   ../bin/Linux-x86_64-O/oasysGui 19.2-p002 on Sat Jan  1 15:00:29 2022
>>>>>>> 0490c21c7128018cc7ad6d8cb6dbeb3b66c2f472:System_Implementation_And_Synthesis/output/constraints/module.oasys.sdc
# (C) Mentor Graphics Corporation
#
set_units -time ns -capacitance ff -resistance kohm -power nW -voltage V -current mA
create_clock -period 1 -waveform {0 0.5} -name vsysclk 
<<<<<<< HEAD:System_Implementation_And_Synthesis/Design_2/output/constraints/demo_adder.oasys.sdc
create_clock -period 1.5 -waveform {0 0.75} -name sysclk [get_ports clk]
=======
create_clock -period 0.9 -waveform {0 0.45} -name sysclk [get_ports clk]
set_false_path -from [get_ports reset]
>>>>>>> 0490c21c7128018cc7ad6d8cb6dbeb3b66c2f472:System_Implementation_And_Synthesis/output/constraints/module.oasys.sdc
group_path -name I2R -from [list [get_ports {temperature[0]}] [get_ports {temperature[1]}] [get_ports {temperature[2]}] [get_ports {temperature[3]}] [get_ports {temperature[4]}] [get_ports {temperature[5]}] [get_ports ST] [get_ports SW] [get_ports SFA] [get_ports SRD] [get_ports SFD] [get_ports reset] [get_ports clk]]
group_path -name I2O -from [list [get_ports {temperature[0]}] [get_ports {temperature[1]}] [get_ports {temperature[2]}] [get_ports {temperature[3]}] [get_ports {temperature[4]}] [get_ports {temperature[5]}] [get_ports ST] [get_ports SW] [get_ports SFA] [get_ports SRD] [get_ports SFD] [get_ports reset] [get_ports clk]]  -to [list [get_ports {display[0]}] [get_ports {display[1]}] [get_ports {display[2]}] [get_ports cooler] [get_ports heater] [get_ports window_buzzer] [get_ports alarm_buzzer] [get_ports rear_door] [get_ports front_door]]
group_path -name R2O -to [list [get_ports {display[0]}] [get_ports {display[1]}] [get_ports {display[2]}] [get_ports cooler] [get_ports heater] [get_ports window_buzzer] [get_ports alarm_buzzer] [get_ports rear_door] [get_ports front_door]]
set_load 10 [get_ports front_door]
set_load 10 [get_ports rear_door]
set_load 10 [get_ports alarm_buzzer]
set_load 10 [get_ports window_buzzer]
set_load 10 [get_ports heater]
set_load 10 [get_ports cooler]
set_load 10 [get_ports {display[2]}]
set_load 10 [get_ports {display[1]}]
set_load 10 [get_ports {display[0]}]
set_input_transition 0.1 [get_ports clk]
set_input_transition 0.1 [get_ports reset]
set_input_transition 0.1 [get_ports SFD]
set_input_transition 0.1 [get_ports SRD]
set_input_transition 0.1 [get_ports SFA]
set_input_transition 0.1 [get_ports SW]
set_input_transition 0.1 [get_ports ST]
set_input_transition 0.1 [get_ports {temperature[5]}]
set_input_transition 0.1 [get_ports {temperature[4]}]
set_input_transition 0.1 [get_ports {temperature[3]}]
set_input_transition 0.1 [get_ports {temperature[2]}]
set_input_transition 0.1 [get_ports {temperature[1]}]
set_input_transition 0.1 [get_ports {temperature[0]}]
set_input_delay 0.7 [get_ports clk]
set_input_delay 0.7 [get_ports reset]
set_input_delay 0.7 [get_ports SFD]
set_input_delay 0.7 [get_ports SRD]
set_input_delay 0.7 [get_ports SFA]
set_input_delay 0.7 [get_ports SW]
set_input_delay 0.7 [get_ports ST]
set_input_delay 0.7 [get_ports {temperature[5]}]
set_input_delay 0.7 [get_ports {temperature[4]}]
set_input_delay 0.7 [get_ports {temperature[3]}]
set_input_delay 0.7 [get_ports {temperature[2]}]
set_input_delay 0.7 [get_ports {temperature[1]}]
set_input_delay 0.7 [get_ports {temperature[0]}]
set_output_delay 0.3 -clock vsysclk [get_ports front_door]
set_output_delay 0.3 -clock vsysclk [get_ports rear_door]
set_output_delay 0.3 -clock vsysclk [get_ports alarm_buzzer]
set_output_delay 0.3 -clock vsysclk [get_ports window_buzzer]
set_output_delay 0.3 -clock vsysclk [get_ports heater]
set_output_delay 0.3 -clock vsysclk [get_ports cooler]
set_output_delay 0.3 -clock vsysclk [get_ports {display[2]}]
set_output_delay 0.3 -clock vsysclk [get_ports {display[1]}]
set_output_delay 0.3 -clock vsysclk [get_ports {display[0]}]
set_max_area 0.0
set_max_dynamic_power 0.0
set_max_leakage_power 0.0
set_operating_conditions  -library  [get_libs {NangateOpenCellLibrary}] -max  typical
