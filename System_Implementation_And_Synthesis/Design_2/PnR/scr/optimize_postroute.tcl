place_filler_cells -remove_only
set_property -name is_dont_modify -value false -objects [get_cells -filter "@is_sequential && @is_dont_modify "]

# increase the search radius to allow for more opt
config_optimize -search_radius 10u
## no DDR needed in PRO 
config_optimize -enable_dynamic_density_recovery false
## allow illegal cells else target is not optimized
config_event_handler -command optimize -event start_command -script {debug_opt -gs_num_mistrial 10;set si_ads_number 0} -output_event_message false
#HBC setting
set hold_buf_chain_predictor_passes 3

## enable USQ cells
set useful_skew_buffer_list [get_lib_cells $MGC_ck_buf_cell_list  $MGC_ck_inv_cell_list]
if {$useful_skew_buffer_list=={}} {puts "Warning: please document MGC_ck_inv_cell_list or/and MGC_ck_buf_cell_list variables for cells to be used for USQ opt"}
set_property -name is_dont_use_usq_opt -value true -obj [get_lib_cells ]
set_property -name is_dont_use_usq_opt -value false -obj [get_lib_cells $useful_skew_buffer_list]

## Settings for fast opt - RCD model is set to sign_off already
set_crpr_spec -trim_effort high
config_extraction -include_vertical_parallel_coupling false
config_extraction -search_distance_multiple 6
ta_debug -cc_ratio 0.1

config_postcts_corner -mode set

set_property -name optimize_max_util -objects [get_top_partition] -value 98
set_clock_network -allow_registers size
set_property -name is_dont_modify -value false -objects [get_cells -filter @is_sequential]

# PASS 1:  normal opt
set_property -name is_dont_use -value true -obj [get_lib_cells $MGC_DLY_cells]

update_timing
report_path_group -violators -sort wns
report_variability;
report_timing_complexity

## exclude re-buffering
config_xform -exclude {TrimBufChain}
set_property -name optimize_max_util -objects [get_top_partition] -value 98
optimize -mode post_route -post_route normal -obj "drc" 
place_detail
route_final -mode simple_drc
run_route_timing -run opt -messages verbose -cpus $MGC_cpus -user_params "-opt_max_util 95 -opt_reset_timing false"

set_property -name optimize_max_util -objects [get_top_partition] -value 98
optimize -mode post_route -post_route white_space -obj "wns tns" -effort expensive
run_usqOnly_opt_ws

place_detail
run_route_timing -cpus $MGC_cpus -mode repair
run_route_timing -run_stages si -cpus $MGC_cpus

##
config_optimize -enable_useful_skew true
set use_skew_opt_in_post_route_tns true
set skewopt_xpe_enable true

config_event_handler -command optimize -event start_command -script {debug_opt -gs_num_mistrial 5;set si_ads_number 0} -output_event_message false

config_optimize -multi_process_count 0
optimize -mode post_route -post_route white_space -obj "wns tns" -time_limit 30
config_optimize -multi_process_count 4
place_detail
run_route_timing -cpus $MGC_cpus -mode repair

# Save db
if { [file exists dbs/libs.db] } {
    ## split_db is true
    write_db -data design -file dbs/post_route_incr_pass0.db
} else {
    write_db dbs/post_route_incr_pass0.db
}
#################################################################################

config_postcts_corner -mode reset

set_property -name is_dont_use -value false -obj [get_lib_cells $MGC_DLY_cells]
optimize -mode post_route -post_route white_space -obj "hold" 
set_property -name is_dont_use -value true -obj [get_lib_cells $MGC_DLY_cells]

place_detail 
run_route_timing -cpus $MGC_cpus -mode repair

source scr/long_net_fix.tcl

# Save db
if { [file exists dbs/libs.db] } {
    ## split_db is true
    write_db -data design -file dbs/post_route_incr_pass1.db
} else {
    write_db dbs/post_route_incr_pass1.db
}

###############################
#### Accurate configs #########
###############################

config_extraction -coupling_abs_threshold 0.1f
config_extraction -coupling_rel_threshold 1.0
config_extraction -gp_density_threshold 0.2
config_extraction -virtual_max_segment_length 0.2u

config_extraction -include_vertical_parallel_coupling true
config_extraction -search_distance_multiple 15
ta_debug -cc_ratio 0

update_timing
report_path_group -violators -sort wns
report_variability;
report_timing_complexity

## PASS 2 : USQ opt
set_clock_network -allow_tree size -allow_reg size -nets {clear_dont_route clear_dont_modify}

debug_opt -tns_only -end_pass 1
optimize -mode post_route -post_route white_space -obj {tns} 
place_detail
route_final -mode simple

config_optimize -enable_useful_skew true
set postroute_whitespace_max_open_length 250000
set use_skew_opt_in_post_route_tns true
set skewopt_xpe_enable true

# USQ WNS
config_optimize -multi_process_count 0
optimize -mode post_route -post_route white_space -obj {wns tns} 
config_optimize -multi_process_count 4
config_optimize -enable_useful_skew false
run_route_timing -cpus $MGC_cpus -mode repair 

set_clock_network -allow_registers fix -net {dont_modify}

set_property -name optimize_max_util -objects [get_top_partition] -value 98
config_event_handler -command optimize -event start_command -script {debug_opt -gs_num_mistrial 2;se;set si_ads_number 0} -output_event_message false

# last mile
set enable_last_mile_drc_fix true; set opt_slew_derate_val 0.05
config_optimize -multi_process_count 0
optimize -mode post_route -post_route white_space -obj "wns drc" -effort expensive 
config_optimize -multi_process_count 4
run_route_timing -cpus $MGC_cpus -mode repair 

optimize -mode footprint -obj "wns drc hold" 
