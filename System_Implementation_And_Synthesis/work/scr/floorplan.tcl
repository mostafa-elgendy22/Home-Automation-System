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
#  Floorplanning Flow			 	     #
#                                                    #
#  Performs physical floorplanning on a chip based   #
#  on the design parameters provided in              #
#  floorplan_variables.tcl			     #
#                                                    #
######################################################

if {![info exists nrf_dir]}  {
    set tmpdir [file dirname $sierra_tcl_dir]
    set nrf_dir ${tmpdir}/ref_flows/tcl
}

#########################
# Logfile start message #
#########################

puts "\n########################"
puts "### FLOORPLAN: Start ###"
puts "########################"

################################
# Read floorplan_variables.tcl #
################################

if { [file exists floorplan_variables.tcl] } {
  puts "\n### FLOORPLAN: Sourcing floorplan variable settings file. ###"
  source floorplan_variables.tcl
} 
load_utils -name nrf_utils
set num_errors [nrf_utils::check_floorplan_variables]
if { $num_errors > 0 } {
    fk_msg -type error "Please fix all errors to continue execution"
    return -code error
}

if { ![info exists fp_top_partition] } {
  puts "\nERROR: Floorplan variables not set.  Check for existence and permissions of"
  puts "       floorplan_varibles.tcl or source floorplan variable settings file.\n"
  return
} elseif { [string equal $fp_top_partition "TOP_PARTITION_NAME"] || [string equal $fp_top_partition ""] } {
  puts "\nERROR: Top partition not set properly.  Be sure floorplan_variables.tcl is"
  puts "       updated with settings corresponding to your design.\n"
  return
}

##################
# Set parameters #
##################

set original_units [config_units -value_type distance -units $fp_units]

#####################
# Technology Checks #
#####################

puts "\n### FLOORPLAN: Checking technology ###"
redirect -file reports/check_tech.rpt -display true -commands "check_technology -check all"
redirect -file reports/report_tech.rpt -display true -commands "report_technology -display all "

##################
# Set top design #
##################

current_design -design $fp_top_partition

#############################################
# Read UPF or create a default power domain #
#############################################

if { [llength [get_objects -type power_domain]] == 0 } {
    if {$MGC_MultiVoltage} {
        puts "\n### FLOORPLAN: Sourcing UPF file. ###"
        if {[info exists MGC_UPF_File] && $MGC_UPF_File != ""} {
            source $MGC_UPF_File
        } else {
            fk_msg -type error "No UPF file found for MV setup."
        }
        if {[info exists MGC_additional_MV_Setup_File] && $MGC_additional_MV_Setup_File != ""} {
           source $MGC_additional_MV_Setup_File
        }

        config_mv -name enable_pgsite_mode -value false
        config_mv -name const_net_tie_to_related_supply -value true
        enable_mv
        check_mv

# Re-save libs in case lib cell updates were made in UPF
        set re_write_lib true

    } elseif {[info exists MGC_UPF_File] && $MGC_UPF_File != ""} {
        fk_msg -type info "Design is not MV, but reading UPF file for power intent."
        source $MGC_UPF_File

# Re-save libs in case lib cell updates were made in UPF
        set re_write_lib true

    } else {
        puts "\n### FLOORPLAN: Creating a default power domain to identify primary power and ground supplies. ###"
        if {$MGC_primary_power_net == "" || $MGC_primary_ground_net == ""} {
            puts ""
            fk_msg -type error "Variables MGC_primary_power_net & MGC_primary_ground_net must be defined in import_variables.tcl.\n"
            exit -1
        }

        create_power_domain -domain DEFAULT_PD
        create_supply_net   -net_name $MGC_primary_ground_net \
                            -domain DEFAULT_PD \
                            -power_net false \
                            -convert
        create_supply_net   -net_name $MGC_primary_power_net \
                            -domain DEFAULT_PD \
                            -power_net true \
                            -convert
        set_domain_supply_net   -domain DEFAULT_PD \
                                -primary_power_net $MGC_primary_power_net \
                                -primary_ground_net $MGC_primary_ground_net

        if { [info exists fp_secondary_power] } {
            foreach pn $fp_secondary_power {
                create_supply_net -net_name $pn -domain DEFAULT_PD -power_net true -convert
            }
        }

        if { [info exists fp_secondary_ground] } {
            foreach gn $fp_secondary_ground {
                create_supply_net -net_name $gn -domain DEFAULT_PD -power_net false -convert
            }
        }
    }
}

####################################
# Create chip if it does not exist #
####################################

if { [llength [get_top_partition]] == 0 } {
  if {$fp_use_utilization} {
      puts "\n### FLOORPLAN: Creating the chip based on utilization ###"
      create_chip -utilization $fp_utilization \
                  -aspect $fp_aspect_ratio \
                  -core_site $fp_core_site
  } else {
      puts "\n### FLOORPLAN: Creating the chip based on provided dimensions ###"
      create_chip -xl_area $fp_chip_origin_x \
                  -yb_area $fp_chip_origin_y \
                  -xr_area $fp_chip_width \
                  -yt_area $fp_chip_height \
                  -core_site $fp_core_site
  }
}

##############
# Create row #
##############

if { [info exists fp_core_site] && $fp_core_site != ""} {
  puts "\n### FLOORPLAN: Creating rows ###"
  remove_objects [get_objects -type row ]
  create_rows -double_backed $fp_double_backed_row \
	      -xl_margin $fp_rows_xl_margin \
	      -yb_margin $fp_rows_yb_margin \
	      -xr_margin $fp_rows_xr_margin \
	      -yt_margin $fp_rows_yt_margin \
	      -core_site $fp_core_site \
	      -orient    $fp_core_orient \
	      -gap       $fp_row_gap
}

#################
# Create tracks #
#################

puts "\n### FLOORPLAN: Creating tracks ###"
remove_track
if { $fp_tracks_offset == "" }  {
  create_tracks
} else {
  create_tracks -start $fp_tracks_offset
}

################
# Place macros #
################

if {[llength [get_cell -filter "@is_macro && @placed!=fixed"]] > 0} {
    if {$fp_macro_def != ""} {
        puts "\n### FLOORPLAN: Placing macros based on DEF ###"
	read_def -file $fp_macro_def
    } else { 
        puts "\n### FLOORPLAN: Using AMP to place macros ###"

        config_run_amp -legalize_mode debug_new_legalizer
        config_run_amp -analysis_pin_list [AMP::listSequentialPins "\[" "\]" $AMP::MP(analysis_ignore_pin_list) 3]

        config_run_amp -controlskipstep {check1 macro_place_macroplace13 swap_abstract macro_legalize_only image*}
        run_amp -recipe macroplace13

        config_run_amp -controlskipstep {create_rows reset_floorplan macro_analysis check1 macro_object_groups macro_place_setup swap_abstract image*}
        run_amp -recipe macroplace13

        set_property -name placed -value fixed [get_cell -filter @is_macro]
        set_property -name placed -value unplaced [get_cell -filter !@is_macro]
    }
}

#################
# Set Max Layer #
#################

set fp_MaxRouteLayer [FK::get_max_routing_layer]

if { $fp_MaxRouteLayer == "" } {
    fk_msg -type warning "Failed to find max routing layer.  Continuing with floorplanning, but tech setup should be checked."
} else {
    set_property [get_objects -type partition] -name max_layer -value $fp_MaxRouteLayer
    set_drc_global_rule -max_layer $fp_MaxRouteLayer
}

##################
# Power planning #
##################

if {$fp_do_power_planning} {
    puts "\n### FLOORPLAN: Creating the supply network ###"
    if { $pg_peak_power > 0  || $pg_peak_current_density > 0 } {
	puts "\n### FLOORPLAN: Running PG expert to create power supply network ###"
	set stripes {}
	if { [llength $pg_stripe_vlayers] == 1 } {
	    lappend stripes $pg_stripe_vlayers
	    if { [llength $pg_stripe_hlayers] == 1 } {
		lappend stripes $pg_stripe_hlayers
	    }
	}
	load_utils -name pg_expert
	util::pg_expert -create true -messages normal \
	                             -with {rails rings} \
                                     -power $pg_peak_power \
                                     -current_density $pg_peak_current_density \
                                     -voltage_drop $pg_target_voltage_drop \
                                     -stripe_layers $stripes
    } else {
	if { [info exists MGC_nrf_custom_scripts_dir] && $MGC_nrf_custom_scripts_dir != "" && [file exists $MGC_nrf_custom_scripts_dir/scr/power_planning.tcl] } {
	    fk_msg "Sourcing custom NRF script $MGC_nrf_custom_scripts_dir/scr/power_planning.tcl"
	    source $MGC_nrf_custom_scripts_dir/scr/power_planning.tcl
	} else {
	    fk_msg "Sourcing standard NRF script $nrf_dir/scr/power_planning.tcl"
	    source $nrf_dir/scr/power_planning.tcl
	}
    }
    # need to check here if PG grid is created and if it is clean
}

##################################
# Place pins if any are unplaced #
##################################

if { [llength [get_ports -filter @placed!=fixed]] > 0 } {

# Place std cells in order to place IOs #

  puts "\n### FLOORPLAN: Quick place of std cells to perform IO placement. ###"
  place_timing -effort none
  place_detail

  puts "\n### FLOORPLAN: Placing ports/pins ###"
  if {$fp_pin_constraint_file != ""} {
      remove_pin_constraints
      source $fp_pin_constraint_file
  }
  hpa_fast_place_pins
}


##################################
# Add ENDCAPS                    #
##################################
  if { [info exists fp_endcap_prefix] && $fp_endcap_prefix != "" }  {
	puts "\n### FLOORPLAN: Inserting endcaps ###"
	   place_end_cap -partition [get_top_partition] \
        		 -left_lib_cell                $fp_left_endcap_cell \
			 -right_lib_cell               $fp_right_endcap_cell \
			 -prefix                       $fp_endcap_prefix \
			 -horiz_lib_cells              $fp_horiz_lib_cell \
			 -top_left_corner_lib_cell     $fp_top_left_corner_endcap_cell \
			 -top_right_corner_lib_cell    $fp_top_right_corner_endcap_cell \
			 -bottom_left_corner_lib_cell  $fp_bottom_left_corner_endcap_cell \
			 -bottom_right_corner_lib_cell $fp_bottom_right_corner_endcap_cell \
			 -ignore_placement_blockage    $fp_ignore_placement_blockage 

   	set_property -name placed      -value fixed [get_cells ${fp_endcap_prefix}*]
	set_property -name is_physical -value true  [get_cells ${fp_endcap_prefix}*]

   }


##################################
# Add WELLTAPS                   #
##################################
  if { [info exists fp_well_tap_prefix] && $fp_well_tap_prefix != "" }  {
	puts "\n### FLOORPLAN: Inserting welltaps ###"
	place_welltap_cells -partition [get_top_partition] \
			    -lib_cell  $fp_well_tap_cell \
			    -hspread   $fp_well_tap_h_spread \
			    -vspread   $fp_well_tap_v_spread \
			    -hoffset   $fp_well_tap_h_offset \
			    -voffset   $fp_well_tap_v_offset \
			    -stagger   $fp_well_tap_staggering \
			    -blockages $fp_well_tap_avoid_blockage \
			    -prefix    $fp_well_tap_prefix 

   	set_property -name placed      -value fixed [get_cells ${fp_well_tap_prefix}*]
	set_property -name is_physical -value true  [get_cells ${fp_well_tap_prefix}*]
   }


#######################
# Check pin placement #
#######################

puts "\n### FLOORPLAN: Checking pin placement ###"
redirect -file reports/check_pin.rpt -display true -commands "check_pin_placement -report_clean true"

###################
# Check floorplan #
###################

puts "\n### FLOORPLAN: Checking floorplan ###"
redirect -file reports/check_floorplan.rpt -display true -commands "check_floorplan -check all"

############
# Write db #
############

if {$fp_save_db} {
    puts "\n### FLOORPLAN: Saving database: dbs/floorplan.db   ###"
    if {$MGC_split_db} {
        write_db -data design -file dbs/floorplan.db
    } else {
        write_db -data all -file dbs/floorplan.db
    }
}

############################
# Reporting Error Messages #
############################

puts "\n### FLOORPLAN: Reporting Errors ###"
report_messages -type error

config_units -value_type distance -units $original_units

puts "\n########################"
puts "### FLOORPLAN: End ###"
puts "########################"

