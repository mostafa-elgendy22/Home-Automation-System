#~/bin/bash

vlib work
vcom ../counter.vhd
vcom ../decoder.vhd
vcom ../register.vhd
vcom ../priority_encoder.vhd
vcom ../home_automation_system.vhd
vmap -c
vsim -do ../../home_automation_system.do