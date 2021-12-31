vsim -gui work.home_automation_system

add wave -position insertpoint  \
sim:/home_automation_system/clk \
sim:/home_automation_system/reset \
sim:/home_automation_system/SFD \
sim:/home_automation_system/SRD \
sim:/home_automation_system/SFA \
sim:/home_automation_system/SW \
sim:/home_automation_system/ST \
sim:/home_automation_system/temperature \
sim:/home_automation_system/front_door \
sim:/home_automation_system/rear_door \
sim:/home_automation_system/alarm_buzzer \
sim:/home_automation_system/window_buzzer \
sim:/home_automation_system/heater \
sim:/home_automation_system/cooler \
sim:/home_automation_system/display \
sim:/home_automation_system/reversed_priority \
sim:/home_automation_system/counter_Q


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

