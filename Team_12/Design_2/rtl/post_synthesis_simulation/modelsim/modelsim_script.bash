#~/bin/bash

vlib work
vlog ../NangateOpenCellLibrary.v
vlog ../home_automation_system.syn.v
vmap -c
vsim -do ../home_automation_system.do