
######################################################################
# 
#  ------------------------------------------------------------------
#   Design    : module
#  ------------------------------------------------------------------
#     SDC timing constraint file
#  ------------------------------------------------------------------
#


set pad_load            0.01  
set transition          0.001
set io_clock_period     1.0

set clock_period 1



create_clock -name vsysclk -period ${io_clock_period} 

create_clock -name sysclk -period ${clock_period} [ get_ports clk ]

set_false_path   -from [ get_ports reset_n ]

set_false_path   -from [ get_ports reset ]

set_load                ${pad_load}   [ all_outputs ]
set_input_transition    ${transition} [ all_inputs ]
set_input_delay 0.2 [all_inputs]

set_output_delay -clock vsysclk [ expr 0.05 * ${io_clock_period} ] [ all_outputs ] 
 #   [ remove_from_collection [ all_outputs ] [ get_ports { usb_plus usb_minus }] ]

set_max_area 0.0
set_max_capacitance 0.0
set_max_delay 0.0 
set_max_dynamic_power 0.0
set_max_leakage_power 0.0
set_max_time_borrow 0.0
set_max_transition 0.0









