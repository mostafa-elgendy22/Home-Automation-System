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

## Check Nitro version

set nversion [string replace [info_version -build_id] 7 end]
if { $nversion < 1.62000 } {
  fk_msg -type error "\nNitro-AMS ERROR: Must use Nitro-AMS version 2017.2.R1 or higher.\n"
  return
}

## Get Nitro ref flow directory

if {![info exists nrf_dir]}  {
        set tmpdir [file dirname $sierra_tcl_dir]
        set nrf_dir ${tmpdir}/ref_flows/tcl
}

config_search_path -dir $nrf_dir [config_search_path]

# Source standard flow variables to get some default settings
# Then create dummy variables script so don't overwrite AMS
# settings during NRF run

source $nrf_dir/flow_variables.tcl
redirect -file flow_variables.tcl -command {  
    puts "## This is a dummy flow variables tcl"
}

# Source AMS specific settings

source nitro_settings.tcl
source $nrf_dir/scr/map_variables.tcl

# Import libraries and design

source $nrf_dir/0_import.tcl

# Set necessary flow variables
set MGC_filler_lib_cells "*"    ; # Letting tool automatically pick filler for tanner 

set MGC_fix_antenna_use_diodes true  ; # Use diodes to fix antennas
set MGC_fix_antenna_diodes ""        ; # Let Nitro pick antenna diodes

# Setup active modes and corners
#   All modes will be activated

set MGC_activeModes(place) $MGC_modes
set MGC_activeModes(clock) $MGC_modes
set MGC_activeModes(route) $MGC_modes

set MGC_setup_corners ""
set MGC_hold_corners ""
if {[lsearch $MGC_corners slow] >= 0} {
    lappend MGC_setup_corners slow
}
if {[lsearch $MGC_corners nominal] >= 0} {
    lappend MGC_setup_corners nominal
    lappend MGC_hold_corners nominal
}
if {[lsearch $MGC_corners fast] >= 0} {
    lappend MGC_hold_corners fast
}

array set MGC_activeCorners {}
set MGC_activeCorners(place:setup)   $MGC_setup_corners
set MGC_activeCorners(place:hold)    $MGC_hold_corners
set MGC_activeCorners(clock:ref)     [lindex $MGC_setup_corners 0]  ; # Picking first setup corner for cts reference
set MGC_activeCorners(clock:setup)   $MGC_setup_corners
set MGC_activeCorners(clock:hold)    $MGC_hold_corners
set MGC_activeCorners(route:setup)   $MGC_setup_corners
set MGC_activeCorners(route:hold)    $MGC_hold_corners

config_shell -echo_script false
load_utils -name save_vars -force
util::save_vars

#
# Run NRF 
#
source $nrf_dir/1_place.tcl
source $nrf_dir/2_clock.tcl
source $nrf_dir/3_route.tcl
source $nrf_dir/4_export.tcl

#
# Remove dummy flow_variables file
#
rm flow_variables.tcl

puts "################################"
fk_msg -type info "Finished Nitro-AMS P&R"
puts "################################"

