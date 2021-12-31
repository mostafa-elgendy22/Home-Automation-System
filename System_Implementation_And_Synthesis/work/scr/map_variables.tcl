######################################################
### Copyright Mentor, A Siemens Business            ##
### All Rights Reserved                             ##
###                                                 ##
### THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY ##
### INFORMATION WHICH ARE THE PROPERTY OF MENTOR    ##
### GRAPHICS CORPORATION OR ITS LICENSORS AND IS    ##
### SUBJECT TO LICENSE TERMS.                       ##
######################################################
#                                                    #
#  Nitro-AMS Reference Flow                          #
#                                                    #
######################################################

#
# Get NRF directory if it is not already defined
#

if {![info exists nrf_dir]}  {
    set tmpdir [file dirname $sierra_tcl_dir]
    set nrf_dir ${tmpdir}/ref_flows/tcl
}

puts "\n*** Nitro-AMS: FLOW IMPORT Start at [date] ***\n"

#
# Set vars to identify Nitro-AMS in L-Edit; do not exit after each NRF stage
#

set MGC_tanner_flow true
set MGC_no_exit true

#
# Proc to help set vars later
#

proc set_if_exists {var_to_set existing_var {default_setting "NOT_SET"}} {
  upvar $var_to_set x
  upvar $existing_var y

  if { [info exists y] } {
    set x $y
  } else {
    set x $default_setting
  }
}

#
#  Variables needed to build a library database
#

set MGC_libDbPath ""

#
# Identify tech file info
#

if { [llength $lef_file_list] > 1 } {
    set MGC_physical_library_tech  [lindex $lef_file_list 0] ; # Assume first file is always tech lef 
    set MGC_physical_libraries [lrange $lef_file_list 1 end] ; # Assume rest of the files are cell lef 
} else { 
    set MGC_physical_library_tech  "" ; # If only one lef file combined no need for tech lef 
    set MGC_physical_libraries $lef_file_list ; # Read lef file
}

set MGC_itf_to_lef_layer_map "" ; # Not applicable in tanner, expected to have layer names correct between lef and ptf 
set MGC_tech_rules ""           ; # Not applicable in tanner
set MGC_tech_vias ""            ; # Not applicable in tanner
set MGC_tech_dfm_vias ""        ; # Not applicable in tanner 

#
# Define design corners
#
# Check that assumptions for tanner flow are accurate
#

if {[llength $tanner_ptf_file_corner_list] > 3} {
    fk_msg -type error "Can not have more than 3 parasitic corners."
    exit 0
}

if { ![string equal [lsort -unique $tanner_ptf_file_corner_list] [lsort -unique $tanner_lib_file_corner_list]] } {
    fk_msg -type error "Parasitic corners and timing corners must match."
    exit 0
}

#
# Set PTF file corresponding to each parasitic condition 
#

if {[llength $tanner_ptf_file_corner_list] > 3} {
    fk_msg -type error "Can not have more than 3 ptf corners." 
    exit 0
}
set idx 0
array set MGC_parasitic_library {}
foreach ptf_cor $tanner_ptf_file_corner_list {
    set MGC_parasitic_library($ptf_cor) [lindex $ptf_file_list $idx] ; #  Assumption is there is one to one mappting in ptf corner vs file 
    set MGC_CornerTemperature($ptf_cor) 25.0                         ; #  In current flow no temperature defined 
    set MGC_CornerParasitic($ptf_cor) $ptf_cor
    incr idx
}
    
#
# Set timing library files corresponding to each PVT corner  
#

array set MGC_timing_library {}
set idx 0
foreach pvt_cor $tanner_lib_file_corner_list {
    lappend MGC_timing_library($pvt_cor) [lindex $lib_file_list $idx] ; # Assumption is there is one to one mappting in pvt corner vs file 
    set MGC_CornerTiming($pvt_cor) $pvt_cor
    incr idx
}

#
# Define analysis corners; assumes same names as pvt & ptf corners
# 

set MGC_corners $tanner_lib_file_corner_list

#
# If modes are provided, use them, otherwise assume single mode
#

if { ![info exists MGC_modes] } {
  set MGC_modes "tanner_default"
}

#
# Define analysis corners for each mode if not provided
#

if { $MGC_modes == "tanner_default" } {
  set MGC_cornersPerMode(tanner_default)  [array names MGC_timing_library]
}

#
# Get all the design file info
#

set MGC_importVerilogNetlist $verilog_top_file  
set MGC_KeepDefRegions       false

if { $tanner_floorplan_mode eq "layout" } {
    set MGC_floorLoadDefFile "from_ledit.def"
} elseif { $tanner_floorplan_mode eq "def" } {
    set MGC_floorLoadDefFile "$tanner_def_floorplan_file"
} else {
    set MGC_floorLoadDefFile ""
}

set MGC_nrf_floorplanning "auto"
    
set MGC_skip_ccs "false"

#
# Define sdc related to each mode if nitro_settings has not provided it
#

if { $MGC_modes == "tanner_default" } {
  if { $tanner_timing_mode == "clocks" } {
    redirect -file tanner_timing_constraints.sdc -command {  
      foreach clkspec $tanner_clock_spec {
        set clk [lindex $clkspec 0]
        set period [lindex $clkspec 1]
        set waveform [lindex $clkspec 2]
        puts "create_clock -name $clk -period $period -waveform \{$waveform\} \[get_ports $clk\]"
      }
    }
    set MGC_importConstraintsFile(tanner_default) "tanner_timing_constraints.sdc"
  } elseif { $tanner_timing_mode == "sdc"} {
      set MGC_importConstraintsFile(tanner_default) "$sdc_file_list"
  } else {
      fk_msg -type error "Non-Timing Driven Mode currently not supported"
      exit 0
  }
}

#
# Setup power and ground nets
#

if { [llength $power_net] > 1 } {
    set MGC_primary_power_net [lindex $power_net 0]
    set fp_secondary_power [lreplace $power_net 0 0]
} else {
    set MGC_primary_power_net $power_net
}

if { [llength $ground_net] > 1 } {
    set MGC_primary_ground_net [lindex $ground_net 0]
    set fp_secondary_ground [lreplace $ground_net 0 0]
} else {
    set MGC_primary_ground_net $ground_net
}

# Max routing layer

set_if_exists MGC_MaxRouteLayer highest_routing_layer ""    ; # Set max routing layer if provided

# If MV, get UPF file name

set_if_exists MGC_MultiVoltage tanner_multivoltage "false"  ; # Assume no MV in current flow 
set_if_exists MGC_UPF_File tanner_upf_file ""         ; # Assume no MV in current flow

set MGC_mxdb_flow "false"
set MGC_mxdb_path ""
set MGC_cpus 1

# Save lib and data in separate database files
set MGC_split_db true

#
# Floorplan variables
#

## Currently hard coded in nitro.tcl
set verilog_top_cell_name $tanner_cell

#
# Convert Tanner variables to NRF variables
#

# Setup parameters

set fp_units		"micro"
set fp_top_partition	$verilog_top_cell_name  ; # INPUT REQUIRED: Top partition name

# Set chip sizing info

set_if_exists fp_use_utilization   fp_use_utilization	false
set_if_exists fp_chip_origin_x	   tanner_chip_origin_x	0
set_if_exists fp_chip_origin_y	   tanner_chip_origin_y	0
set_if_exists fp_chip_width	   chip_width		0
set_if_exists fp_chip_height	   chip_height		0

# Provide core site name to be used for core rows

set_if_exists fp_core_site	core_site ""; # INPUT REQUIRED: Name a lib site to be used for core rows

# Info for core rows

set_if_exists fp_rows_xl_margin	    rows_xl_margin  0   ; # Distance from left boundary to start rows
set_if_exists fp_rows_yb_margin	    rows_yb_margin  0   ; # Distance from bottom boundary to start rows
set_if_exists fp_rows_xr_margin	    rows_xr_margin  0   ; # Distance from right boundary to stop rows
set_if_exists fp_rows_yt_margin	    rows_yt_margin  0   ; # Distance from top boundary to stop rows
set_if_exists fp_row_gap	    tanner_row_gap  0   ; # Gap between rows

set_if_exists fp_double_backed_row  rows_double_backed true ; # Flip orient of every other row

# Set the orientation for the first (bottom) row.

set_if_exists flip tanner_flip_bottom_row 0; # Flip first row

if { $flip } {
  set fp_core_orient flip_south
} else {
  set fp_core_orient north
}

# Track info

set fp_tracks_offset	    ""    ; # Distance from left (horizontal track) & bottom (vertical track) for tracks

# Macro placement

set fp_macro_def		""	; # DEF file with macro placement info
set fp_do_macro_conn_analysis	false

# Pin placement

set fp_pin_constraint_file	""

# Power Planning Variables

if { $tanner_power_plan_mode eq "layout" && $tanner_floorplan_mode ne "layout" } {
  lappend MGC_floorLoadDefFile "from_ledit.def"
  set fp_do_power_planning   false
} elseif { $tanner_power_plan_mode eq "def" } {
  lappend MGC_floorLoadDefFile $tanner_power_plan_def_file
  set fp_do_power_planning   false
} else {
  set fp_do_power_planning   true
}

# PG ring settings if provided

  if { [info exists tanner_pg_ring_vlayer] && $tanner_pg_ring_vlayer != "" } {
    set pg_ring_layers		"$tanner_pg_ring_hlayer $tanner_pg_ring_vlayer"	; # Metal layers for the rings
    set pg_ring_net_order		$tanner_pg_ring_net_order	; # Order to create rings
    set pg_ring_drc_check		$tanner_pg_ring_drc_check		; # Perform DRC checking while creating rings?
    if { $tanner_pg_ring_concentric } {
      set pg_ring_corner_style	concentric
    } else {
      set pg_ring_corner_style	grid
    }
    set pg_ring_widths		$tanner_pg_ring_widths		; # Width of the supply rings
    set pg_ring_spacing		$tanner_pg_ring_spacing		; # Spacing between supply rings
    set pg_ring_step		$tanner_pg_ring_step		; # Spacing between ring patterns
    set pg_ring_offset_left	$tanner_pg_ring_offset_left		; # Spacing from left chip edge to ring
    set pg_ring_offset_right	$tanner_pg_ring_offset_right		; # Spacing from right chip edge to ring
    set pg_ring_offset_top	$tanner_pg_ring_offset_top		; # Spacing from top of chip to ring
    set pg_ring_offset_bottom	$tanner_pg_ring_offset_bottom		; # Spacing from bottom of chip to ring
}

# PG stripe settings

set pg_stripe_hlayers		""
set pg_stripe_vlayers		""

# FUTURE WORK: Allow stripes in both directions

if {[info exists tanner_pg_stripe_layer] && $tanner_pg_stripe_layer != ""} {
    if { [string equal $tanner_pg_stripe_direction "vertical"] } {
      set pg_stripe_vlayers	$tanner_pg_stripe_layer
      set pg_stripe_hlayers	""
    } else {
      set pg_stripe_hlayers	$tanner_pg_stripe_layer
      set pg_stripe_vlayers	""
    }
    
    set pg_stripe_drc_check	$tanner_pg_stripe_drc_check		; # Perform DRC checking while creating stripes?
    set pg_stripe_net_order	$tanner_pg_stripe_net_order	; # Order of supply nets for stripes
    set pg_stripe_widths	$tanner_pg_stripe_widths		; # Width of stripes
    set pg_stripe_spacing	$tanner_pg_stripe_spacing		; # Spacing between stripes
    set pg_stripe_step		$tanner_pg_stripe_step		; # Step spacing for repeating patterns
    set pg_stripe_offset_left	$tanner_pg_stripe_offset_left		; # Offset from left side of chip to start vertical stripe patterns
    set pg_stripe_offset_right	$tanner_pg_stripe_offset_right		; # Offset from right side of chip to stop vertical stripe patterns
    set pg_stripe_offset_top	$tanner_pg_stripe_offset_top		; # Offset from top of chip to stop horizontal stripe patterns
    set pg_stripe_offset_bottom	$tanner_pg_stripe_offset_bottom		; # Offset from bottom of chip to start horizontal stripe patterns
    set pg_stripe_start_vmargin	0		; # Offset from bottom of chip to beginning of vertical stripes
    set pg_stripe_stop_vmargin	0		; # Offset from top of chip to end vertical stripes
    set pg_stripe_start_hmargin	0		; # Offset from left side of chip to start horizontal stripes
    set pg_stripe_stop_hmargin	0		; # Offset from right side of chip to stop horizontal stripes
}

# Save the DB

set fp_save_db                  false
