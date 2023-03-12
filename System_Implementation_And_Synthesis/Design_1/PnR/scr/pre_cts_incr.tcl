# ================================================
#  NITRO  KIT
#  Task : pre_cts_incr
#  Description: Incremental placement and pre-cts optimization
# ================================================

config_units -value_type distance -units micro

set MGC_flowStage pre_cts_incr
load_utils -name nrf_utils 
nrf_utils::check_flow_variables $MGC_flowStage

# Sets modes and corner for pre_cts_incr:
nrf_utils::configure_scenarios $MGC_flowStage
# Target Library Management: preparing and setting dont use cell list
nrf_utils::configure_target_libs $MGC_flowStage

# QoR
report_variability
report_path_group -sort wns -viol

# Check actual WNS. Skip incremental pass if better than threshold
  if { $MGC_flow_effort == "medium" } {
 
     fk_msg "Running default medium effort incremental prects flow"

     ## N2N Remapping Opt
     if {$MGC_high_effort_remap} {
     run_remap_optimize -effort ultra -skip_dpgr
     place_detail 
     route_global -flow turbo -repair 
     } else {
     optimize -mode local -objective wns -effort expensive 
     place_detail
     route_global -flow turbo -repair
     }
     
     run_rco_wns 
     
     # NDR opt
     config_optimize -nondef_rule [get_objects -type nondef_rule CLOCK_NDR]
     optimize -mode local -objective wns -effort expensive
     config_optimize -nondef_rule ""
     place_detail
     route_global -flow turbo -repair

     optimize -mode post_route -post_route_driven_by {footprint white_space} -objective "wns tns drc" 
     place_detail;
     route_global -flow turbo -repair
     route_global -flow optimize
     report_path_group -violators_only -sort wns
  } else {
     fk_msg "Running low effort incremental prects flow"
     config_optimize -nondef_rule ""
     optimize -mode local -objective "wns tns" -effort expensive 
     place_detail
     route_global -flow turbo -repair

     optimize -mode post_route -post_route_driven_by white_space -objective "wns"
     route_global -flow turbo -repair
     route_global -flow optimize 
     report_path_group -violators_only -sort wns
  } 
