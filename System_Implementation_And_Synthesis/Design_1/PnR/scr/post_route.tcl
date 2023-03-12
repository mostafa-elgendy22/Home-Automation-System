# ==========================================================================
#  NITRO KIT
#  Task : post_route_incr
#  Description: incremental post routing optimization with accurate settings
# ==========================================================================


# ===========================================================================================
# TECHNO / LIB / READ
# ===========================================================================================

set MGC_flowStage post_route_incr
fk_msg -set_prompt NRF

source flow_variables.tcl
source scr/kit_utils.tcl

config_shell -echo_script true
config_application -cpus $MGC_cpus
config_timing -cpus $MGC_cpus

# Read db
if { [file exists dbs/libs.db] } {
    ## split_db is true
    read_db -file dbs/libs.db
    config_lib_vias -select -use_generate false
    read_db -file dbs/post_route.db
} else {
    read_db dbs/post_route.db
}

load_utils -name nrf_utils 
nrf_utils::check_flow_variables $MGC_flowStage
load_utils -name save_vars -force
util::save_vars

if { $MGC_powerEffort != "none" && $MGC_saifFile != "" } {
    read_saif -file dbs/post_route.saif.gz
} 

# Target Scenario Management : enabling modes and corners 
# This Proc is in scr/kit_utils.tcl
nrf_utils::configure_scenarios $MGC_flowStage
# Target Library Management: preparing and setting dont use cell list
# This Proc is in scr/kit_utils.tcl
nrf_utils::configure_target_libs $MGC_flowStage


# ===========================================================================================
# GENERIC POSTROUTE PROJECT SETTINGS 
# ===========================================================================================

# Read post cts contraints
#if {$MGC_reload_constraints} {
#  source scr/reload_constraints.tcl
#}

# reset the previously set max_trans constraint
reset_clock_based_max_transition

# Generic configs:
config_default_value -command route_final -argument accept -value number

#config_default_value -command route_final -argument keep_best_run -value true
config_name_rules -cell_prefix POST_ROUTE_INCR

# LP settings
#if {$MGC_MultiVoltage} {
#  source scr/mv_setup_postroute_incr.tcl
#}


# ===========================================================================================
# POSTROUTE INCREMENTAL OPTIMIZATION WITH ACCURATE SETTINGS
# ===========================================================================================

# Extraction settings
set_rcd_model -stage sign_off
config_extraction -coupling_abs_threshold 0.1f
config_extraction -coupling_rel_threshold 1.0
config_extraction -gp_density_threshold 0.2
config_extraction -virtual_max_segment_length 0.2u

# Timing settings
config_si_delay -enable true

# CRPR
set_crpr_spec -crpr_threshold $MGC_crpr_threshold
set_crpr_spec -method graph_based
set_crpr_spec -transition same_transition

####### FLOW 
report_analysis_corner
report_design_mode
report_mcmm_scenarios

config_optimize -enable_dynamic_density_recovery false
config_mpopt -whitespace_recovery false
config_place_detail -name optimize_displacement_threshold -value 0

if {$MGC_flow_effort == "low"} {
  source scr/optimize_postroute_low_effort.tcl
} else {
   source scr/optimize_postroute.tcl
}

# Save db
if { [file exists dbs/libs.db] } {
    ## split_db is true
    write_db -data design -file dbs/post_route_incr_opt.db
} else {
    write_db dbs/post_route_incr_opt.db
}

# SnR routing pass to clean up remaining violations, if any 
check_drc
if {[llength [get_objects -type error -filter "@category == drc"]] > 0} {
  set_clock_network -nets clear_dont_route
  route_final
  route_final -mode full_drc 
  check_drc
  check_lvs
  set_clock_network -nets dont_route
}

# Running check_mv after postRoute opt
#if {$MGC_MultiVoltage} {
#  check_mv
#}

# ===========================================================================================
# END of POST-ROUTE-INCR STAGE
# ===========================================================================================
if { [file exists dbs/libs.db] } {
    ## split_db is true
    write_db -data design -file dbs/post_route_incr.db
} else {
    write_db dbs/post_route_incr.db
}
if { $MGC_powerEffort != "none" && $MGC_saifFile != "" } {
    ## Getting one mode to write saif 
    set saifMode [nrf_get_saif_mode $MGC_powerCorner]
    write_saif dbs/post_route_incr.saif.gz -mode $saifMode
}
nrf_utils::write_reports $MGC_flowStage reports 100

if { [info exists MGC_no_exit] && $MGC_no_exit eq "true" } { 
    #continue
} else {
    exit
}
