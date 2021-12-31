set InsertBufferDist 1000                   ; # ADVANCED : Search radius for buffer insertion on the existing route for fixing a long net
set Long_net_PRObuffer {}                   ; # ADVANCED : Buffer that can be inserted for long net fixing 
set Long_net_PROinverter {}                 ; # ADVANCED : Inverter that can be inserted for long net fixing

config_shell -echo_script false
config_messages -type info -max_messages 0 -message_id UI33 -max_log_messages 0
set list_setup [FindCritDeltaDelayDriver 300 300 $MGC_maxLengthParam $Long_net_PRObuffer $InsertBufferDist scr/delta_setup.tcl reports/delta_setup.rpt]
set list_hold [FindCritDeltaDelayDriver_hold 300 300 $MGC_maxLengthParam $Long_net_PRObuffer $InsertBufferDist scr/delta_hold.tcl reports/delta_hold.rpt]
set coll1 [add_to_collection -add [get_nets -of $list_setup] -objects [get_nets -of $list_hold] -unique]
set long_nets [filter_collection -expression "@max_pin_to_pin_wire_length > $MGC_maxLengthParam" -objects $coll1]

optimize_route -white_space_driven -repair_route -max_length $MGC_maxLengthParam -cell_name_prefix "LONG_SI_BUF" \
-max_distance_to_wire 30 -nets $long_nets -buffer $Long_net_PRObuffer -inverter $Long_net_PROinverter -use_inverter true

config_place_detail -name optimize_displacement_threshold -value 0
place_detail
run_route_timing -mode repair -cpu 16

set list_setup_or [FindCritDeltaDelayDriver 300 300 $MGC_maxLengthParam $Long_net_PRObuffer $InsertBufferDist scr/delta_setup_or.tcl reports/delta_setup_or.rpt]
set list_hold_or [FindCritDeltaDelayDriver_hold 300 300 $MGC_maxLengthParam $Long_net_PRObuffer $InsertBufferDist scr/delta_hold_or.tcl reports/delta_hold_or.rpt]
config_name_rules -cell_prefix "Long_SI_BUF_CB"
source scr/delta_setup_or.tcl 
source scr/delta_hold_or.tcl 
config_place_detail -name optimize_displacement_threshold -value 0
place_detail
run_route_timing -mode repair -cpu 16
set long_net_buf [get_cells -filter @name =~ *LONG_SI_BUF*]
set_property -name is_size_only -value true $long_net_buf
set_property -name is_fixed_origin -value true $long_net_buf

set list_setup_final [FindCritDeltaDelayDriver 300 300 $MGC_maxLengthParam $Long_net_PRObuffer $InsertBufferDist scr/delta_setup_final.tcl reports/delta_setup_final.rpt]
set list_hold_final [FindCritDeltaDelayDriver_hold 300 300 $MGC_maxLengthParam $Long_net_PRObuffer $InsertBufferDist scr/delta_hold_final.tcl reports/delta_hold_final.rpt]
config_messages -reset
config_name_rules -cell_prefix "POST_ROUTE_INCR"
