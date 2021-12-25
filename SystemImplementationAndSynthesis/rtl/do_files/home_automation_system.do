vsim -gui work.home_automation_system

add wave -position insertpoint  \
sim:/home_automation_system/*


force -freeze sim:/home_automation_system/clk 1 0, 0 {100 ps} -r 200
force -freeze sim:/home_automation_system/reset 1 0
run {200 ps}

force -freeze sim:/home_automation_system/reset 0 0
force -freeze sim:/home_automation_system/SFD 1 0
force -freeze sim:/home_automation_system/SRD 1 0
run {200 ps}

force -freeze sim:/home_automation_system/SFD 0 0
run {1000 ps}

force -freeze sim:/home_automation_system/SFD 1 0
force -freeze sim:/home_automation_system/ST 1 0
force -freeze sim:/home_automation_system/temperature 001000 0
run {400 ps}

