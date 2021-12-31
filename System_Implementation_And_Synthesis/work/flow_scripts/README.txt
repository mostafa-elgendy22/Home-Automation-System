# -*- Tcl -*-
# $Revision: 1.16 $

# Revision history
# 1.10 - Update fpr long net fixing flow & Bug fixes

################################################################################
# Steps to get started
################################################################################
  1. set the paths to technology/ascii data in import_variables.tcl
  2. set the flow variables defined in flow_variables.tcl
  3. To run the flow, source the flow file in the following order:
      0_import_design.tcl
      1_place.tcl
      2_clock.tcl
      3_route.tcl
      4_export.tcl 
      scr/post_route.tcl (optional)

##
################################################
# EFFORT LEVEL (defined in design)variables.tcl)
################################################

   MGC_flow_effort - Decides the flow effort levels for all stages

# Low Effort configures the flow in the following way:
  
  1. Disables clock optimization in prects flow
  2. Sets effort level for RPT flow
  3. Enables light pre_cts_incr flow
  4. Disables clock optimization in postcts flow
  5. Enables light run_clock_timing flow 
  6. Skips post_route optimization flow and moves to incremental flow
  3. Enables light post_route_incr flow
 
***recommended for small and less complex designs

###########For medium effort####################

  1. Default prects flow enabled
  2. Sets effort level for RPT as medium
  3. Aggressive post_route_incr optimization

################################################################################
#
# COMMON FILES/SETTINGS
#
################################################################################

   MGC_cpus - Decides the number of CPUs for flow application
   MGC_maxLengthParam  - Max open length which optimization flow may create during buffer removal
   MGC_MaxRouteLayer - Highest routing layer permissible in the flow
   MGC_reload_constraints - Set to true if the user wants to reload the constraints using reload_constraints.tcl
   MGC_modes - All the available modes
   MGC_corners - All the available corners
   MGC_split_db - Set if the user wants to save a split design and lib db
   MGC_MultiVoltage - Set if design is MV
   reload_constraints.tcl - reloads postcts constraints at route and further stages
   MGC_techDontUseCellList :  Cells to be put to dont_use for the design


##################################
#
#0_import_design.tcl
#
##################################
The step reads in the process (ptf or xact) , electrical (.libs), lef  & corner association

##################################
#
#1_place.tcl
#
##################################

The input to the prects flow is the floorplan completed db. 
The user needs to set the following variables in variable.tcl for this flow:

###These variables are MUST to be set:
	

	MGC_activeModes(place) :  Modes to be enabled during the prects optimization flow 
	MGC_analysisCorners(place:setup) : Setup corners to be enabled during the prects flow
	MGC_analysisCorners(cts:ref) : Corner to be specified for clock data opt in prects
	MGC_analysisCorners(place:hold): hold corner to be specified for clock data opt in prects
	MGC_targetLibraries(place) : Cell Libraries which are enabled for place.

###These variables are optional for user:

	MGC_high_effort_remap : Default value=0. Run remapping in 0rc mode. 
	MGC_enable_pre_cts_incr : Default value = false. Source scr/pre_cts_incr.tcl.

###The user can provide:

   ocv.tcl - To update the derates at prects stage

##################################
#
#2_clock.tcl
#
##################################

The input to the Clock stage is the prects / prects incr db.
The user needs to set the following variables in flow_variable.tcl for this stage:


###These variables are MUST to be set:

	MGC_activeModes(clock) :  Modes to be enabled during the Clock stage.
	MGC_analysisCorners(clock:setup) :  Setup corners to be enabled during the Clock stage
	MGC_analysisCorners(clock:hold) :  Hold corners to be enabled during the CTS and Post-CTS flow.
	MGC_analysisCorners(clock:ref) : Specify the reference corner for CTS; the one for which constraints are defined. Scaling will be used to derive constraints in the secondary corners.
	MGC_targetLibraries(clock) :  Cell Libraries which are enabled for Clock stage.
	MGC_techDontUseCellList : Cells to be put to dont_use during Clock stage.

	MGC_CtsBottomPreferredLayer : Specify the bottom metal layer for building CTS. 
	MGC_CtsTopPreferredLayer : Specify teh top metal layer for building CTS.
	MGC_ck_buf_cell_list : acceptable clock buffer list, including AON buffers if needed.
	MGC_ck_inv_cell_list : acceptable clock inverter list, including AON inverters if needed.

###These variables are optional for user:

	MGC_reload_constraints : Default value = 0. Reload the pre-cts constraints.

	MGC_cts_max_trans : Default value = 0.25n. Modify as required.
	MGC_cts_max_leaf_trans : Default value = 0.25n. Modify as required.
	MGC_cts_max_skew : Default value = 0.15n. Modify as required.
	MGC_ck_cg_cell_list : Explicit list of acceptable libcells or acceptable pattern for libcells to be used for clock Gate Optimization during CTS.
	MGC_set_ports_as_clock_leaves : Default value = false. Balance output port with internal FFs.
	MGC_cts_custom_spec : Default value = false. Allow user to customize teh CTS.
	MGC_cts_custom_compile : Default value = false. 
	MGC_clk_halo : Specify CTS halo, if required.
	MGC_add_decap_around_clk_cells : Default value = false. Specify MGC_clk_decap in case insert_clock_decap.tcl is not available.
	MGC_clock_refine_cts : Default value = false. Modify if required. If set to true needed files are { 

	MGC_DLY_cells - List of delay cells which can be used for hold optimization
	MGC_update_virtual_clock_latency - Now that clocks are compiled and routed the user may want to update the virtual clock latencies as well. This variable needs to be set for that. The flow assumes that cts spec exists in the db; so if not then user needs to source it
	MGC_run_clock_data_opt - The user may want to run clock optimization for the design. You would need to set this variable to true for that
	MGC_max_trans_on_macro_pins - This will tighten the constraints on macro pins by $MGC_max_trans_on_macro_pins_value
	MGC_CLOCK_NDR_NAME - MANDATORY to review: Specify name if using existing NDR from technology/db, flow won't auto create ndr, and will assign specified NDR

###The user can provide:

	ocv.tcl - To update the derates at postcts stage

The flow assumes that NDRs are already set as desired. If not then user needs to set them on his own.
Other variables which get used are consistent with the previous flows
### other notes
The currently empty file scr/reload_constarints.tcl is sourced at the beginning of clock stage. user needs to update this file to implement uncertainity changes after CTS is built 
 
################################################################################
#
#3_route.tcl
#
################################################################################

The input to route flow is the POSTCTS db (clock.db) saved after clock stage.
The user needs to set the following variables in variables.tcl for this flow:

###These variables are MUST to be set: 
   MGC_activeModes(route) - Modes to be enabled during the routing flow 
   MGC_analysisCorners(route:setup) - Setup corners to be enabled during the flow

###These variables are optional for user depending on the targeted flow:
   MGC_rrt_timing_mode - This variables decides the timing mode for routing flow
   MGC_replace_dfm - If the user wants to replace dfm vias then this variable needs to be set to true

###################################################################
###Export flow variables
###################################################################
Export Stage does Antenna fixing, Filler insertion, and writes out data (Verilog, DEF, GDS) in "output" dir
## Fix Antenna
    MGC_fix_antenna_use_diodes false ; # Mandatory to review :  true|false
    MGC_fix_antenna_diodes ""        ; # Mandatory to review list of antenna libcells
## Place Filler
    MGC_filler_lib_cells ""          ; # Mandatory to define :  filler lib cell pattern 
                                       # Example 1: set MGC_filler_lib_cells "*FILLX*"
                                       # Example 2: Fillter cell Lib Cells patterns and percentage set MGC_filler_lib_cells {{"*_FILL*" 85} {"*DECAP*" 15}} 


################################################################################
#
# scr/post_route_incr.tcl
#
################################################################################

The input to postroute flow is the POSTROUTED db save after Route optimization flow.
The user needs to set the following variables in variables.tcl for this flow:


###These variables are MUST to be set: 
   MGC_activeModes(post_route_incr) - Modes to be enabled during the post route optimization flow 
   MGC_analysisCorners(post_route_incr:setup) - Setup corners to be enabled during the flow
   MGC_analysisCorners(post_route_incr:hold) - Hold corners to be enabled during the flow
   MGC_targetLibraries(post_route_incr) - Cell Libraries which are enabled for post route. 
   MGC_techDontUseCellList - Cells to be put to dont_use

###These variables are optional for user depending on the targeted optimization:
   MGC_DLY_cells - List of delay cells which can be used for hold optimization
   MGC_crpr_threshold - CRPR threshold to be used for PRO flow. This should be based on signoff correlation
   MGC_ck_buf_cell_list - Clock buffers to be used for USQ optimization	
   MGC_ck_inv_cell_list - Clock inverters to be used for USQ optimization	
