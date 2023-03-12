   set_property -name optimize_max_util -value 98 [get_top_partition ]
   set WS_Open 400000 
   set postroute_whitespace_max_open_length $WS_Open

   ## slack margin for hold
   set slack_margin_mode {}                    ; # ADVANCED : Sets margin for hold in PRO for better optimization. It adds slack margin 10p for hold for given mode -> to achieve better correlation
   if {$slack_margin_mode != ""} {
     set_slack_margin 10p -hold -modes $slack_margin_mode
   }
   ## Pass 1
   set enable_last_mile_drc_fix true
   set opt_slew_derate_val 0.05

   ## Pass 2
   optimize -mode post_route -post_route_driven_by {white_space} -objective "drc"  -effort expensive
   optimize -mode post_route -post_route_driven_by {white_space} -objective "wns tns"  
   place_detail 
   route_final -mode simple 
   set enable_last_mile_drc_fix false

   set_property -name is_dont_use -value false -obj [get_lib_cells $MGC_DLY_cells]
   optimize -mode post_route -post_route_driven_by {white_space} -objective hold 
   set_property -name is_dont_use -value true -obj [get_lib_cells $MGC_DLY_cells]
   place_detail

   run_route_timing -mode repair
   report_variability
   
   source scr/long_net_fix.tcl

   # No more than 10u of opens 
   set postroute_whitespace_max_open_length [expr $WS_Open*0.25]
   set_property -name optimize_max_util -value 100 [get_top_partition ]
   set useful_skew_buffer_list [get_lib_cells $MGC_ck_buf_cell_list  $MGC_ck_inv_cell_list]
   if {$useful_skew_buffer_list=={}} {puts "Warning: please document MGC_ck_inv_cell_list or/and MGC_ck_buf_cell_list variables for cells to be used for USQ opt"}
   set_property -name is_dont_use_usq_opt -value true -obj [get_lib_cells ]
   set_property -name is_dont_use_usq_opt -value false -obj [get_lib_cells $useful_skew_buffer_list]
   set_clock_network -allow_tree size -allow_reg size -nets {clear_dont_route clear_dont_modify}
   config_optimize -enable_useful_skew
   set si_ads_number 0
   set si_run_drive false
   set use_skew_opt_in_post_route_tns true; set skewopt_xpe_enable true
   config_optimize -multi_process_count 0
   optimize -mode post_route -post_route_driven_by {white_space} -objective "wns tns" 
   config_optimize -multi_process_count 4 
   set use_skew_opt_in_post_route_tns false; set skewopt_xpe_enable false

   set_property -name is_dont_use -value false -obj [get_lib_cells $MGC_DLY_cells]
   optimize -mode post_route -post_route_driven_by {white_space} -objective hold 
   set_property -name is_dont_use -value true -obj [get_lib_cells $MGC_DLY_cells]
   run_route_timing -mode repair
   
   set_clock_network -allow_tree fix -allow_reg fix -nets dont_route
   config_optimize -enable_useful_skew false
   
   config_optimize -multi_process_count 0 
   optimize -mode footprint -objective {wns hold} 
   config_optimize -multi_process_count 4 
