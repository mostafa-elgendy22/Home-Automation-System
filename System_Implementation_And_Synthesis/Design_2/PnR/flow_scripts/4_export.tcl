######################################################
### Copyright Mentor, A Siemens Business            ##
### All Rights Reserved                             ##
### Version : 2019.1.R2                             ##
### THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY ##
### INFORMATION WHICH ARE THE PROPERTY OF MENTOR    ##
### GRAPHICS CORPORATION OR ITS LICENSORS AND IS    ##
### SUBJECT TO LICENSE TERMS.                       ##
######################################################
puts "
######################################################
#  Export Flow                                       #
# Version : 2019.1.R2                                #
#  Fix process antennas, add fillers & metal fill    #
#  Output design data.                               #
#  Control vars defined in flow_variables.tcl        #
#                                                    #
######################################################
"

config_shell -echo_script false
fk_msg -set_prompt NRF

###Sourcing design and technology variables
source flow_variables.tcl
source scr/kit_utils.tcl
load_utils -name nrf_utils 
load_utils -name save_vars
load_utils -name db_utils

set MGC_flowStage export

# Read DB
if {![string length [get_top_partition]]} {
    if { [file exists dbs/libs.db] } {
	# Split db is used
        if { [file isfile dbs/libs.db] } {
            # Old DB -- Convert to 2.5
            util::update_split_db -lib_db dbs/libs.db -design_db dbs/route.db
        } else {
	    read_db -file dbs/libs.db
	    read_db -file dbs/route.db
        }
	config_default_value -command write_db -argument data -value design
    } else {
        if { [file isfile dbs/route.db] } {
            # Old DB -- Convert to 2.5
            util::update_full_db -design_db dbs/route.db
        } else {
	    read_db -file dbs/route.db
        }
    }
}

set num_errors [nrf_utils::check_flow_variables $MGC_flowStage]
if { $num_errors > 0 } {
    fk_msg -type error "Please fix all errors to continue execution"
    return -code error
}
util::save_vars

## Fix Antenna
set MGC_fix_antenna true             ; # Mandatory to review : true|false

if { [file exists nrf_customization.tcl] } {
    source nrf_customization.tcl
}

if {$MGC_fix_antenna eq true} {
    check_antenna -cpus $MGC_cpus
    fix_antenna -method jumper -cpus $MGC_cpus

    if {$MGC_fix_antenna_use_diodes eq true} {
	if {$MGC_fix_antenna_diodes != ""} {
	    config_antenna -diodes $MGC_fix_antenna_diodes -prefix ANT
	}
	fix_antenna -method diode -finish all
    }
}

## Check if design is DRC clean before starting chip finishing
set MGC_num_drc_errors_threshold 100    ; # If number of DRC errors exceeds this threshold the chip finishing steps will not be performed

if {$MGC_inroute_drc == true} {
    if {[config_license -key calibreinroute]} {
        if {[string length $MGC_calibre_drc_deck] != 0} {
            if {[string length $MGC_calibre_build] != 0} {
                run_inroute_calibre -mode drc -calibre_server $MGC_calibre_build -drc_rule_file $MGC_calibre_drc_deck
            } else {
                fk_msg -type warning "Calibre server is  not specified. Running internal DRC check"
                check_drc
            }
        } else {
            fk_msg -type warning "DRC deck not specified. Running internal DRC check"
            check_drc
        }
    } else {
        fk_msg -type warning "Calibre InRoute license could not be found. Running internal DRC check"
        check_drc
    }
} elseif {$MGC_inroute_drc == false} {
        check_drc
} else {
        fk_msg -type error "PLease specify correct value for MGC_inroute_drc."
        return -code error
}

set num0 [llength [get_objects -type error -filter @category==drc -quiet true]]
set skip_chip_finishing false
if { $num0 > $MGC_num_drc_errors_threshold } {
    fk_msg -type info "Number of DRC (including antenna) errors is too high ($num0 > $MGC_num_drc_errors_threshold). Chip finishing steps will be skipped \n"
    set skip_chip_finishing true
}

## Place Filler
set MGC_insert_filler_cells true     ; # true|false

if { $skip_chip_finishing == false && $MGC_insert_filler_cells eq true} {
    # Next config is only needed for advanced nodes 
    # config_place_detail -name honor_lib_cell_edge_spacing -value true

    # Needed for DECAP insertion
      if { [info exists MGC_clk_decap] && [llength [get_lib_cells $MGC_clk_decap]] > 0} {
	   set ignoreBloat false
      } else {
           set ignoreBloat true
      }

    set_property -objects [get_lib_cells -filter @is_filler] -name is_dont_use -value true
    if {[llength $MGC_filler_lib_cells] == 0} {

        # User provided no filler cells -- try to find filler cells for each
        # site type of the rows in design and insert fillers.

        set site [get_objects -type site -of_objects [get_objects -type row]]

        if { [llength $site] > 0 } {
            set first_site true
            foreach s $site {
                set lc_list [nrf_utils::get_filler_list $s]
                if {[llength $lc_list] == 0} {
	            fk_msg -type error "Could not find any lib cells to use as filler cells for rows of site $s.  No fillers inserted for these rows.\n"
                } else {
                    set_property -objects [get_lib_cells $lc_list] -name is_dont_use -value false
	            fk_msg -type info "Placing filler cells in rows of site $s using lib cells: $lc_list\n"
                    if { $first_site } {
	                place_filler_cells -cpus $MGC_cpus -lib_cells [get_lib_cells $lc_list] \
                                                           -respect_blockages $MGC_filler_respect_blockages \
							   -ignore_bloats $ignoreBloat \
                                                           -prefix ${s}_FILL
                        set first_site false
                    } else {
	                place_filler_cells -cpus $MGC_cpus -lib_cells [get_lib_cells $lc_list] \
                                                           -respect_blockages $MGC_filler_respect_blockages \
							   -ignore_bloats $ignoreBloat \
                                                           -prefix ${s}_FILL \
                                                           -remove_existing false
                    }
                }
            }
        } else {
	    fk_msg -type error "Could not find any row sites.  No fillers inserted.\n"
        }
    } elseif {[llength $MGC_filler_lib_cells] == 1} {
        set lc_list [get_lib_cells -filter @is_filler -pattern $MGC_filler_lib_cells]
        if {[llength $lc_list] == 0} {
	    fk_msg -type error "Could not find any filler lib cells matching pattern $MGC_filler_lib_cells.  No fillers inserted.\n"
        } else {
	    set_property -objects [get_lib_cells $lc_list] -name is_dont_use -value false
	    fk_msg -type info "Placing filler cells using lib cells: $lc_list\n"
	    place_filler_cells -cpus $MGC_cpus -lib_cells [get_lib_cells $lc_list] -respect_blockages $MGC_filler_respect_blockages -ignore_bloats $ignoreBloat -prefix FILL
        }
    } else {
        set lc_string [join $MGC_filler_lib_cells]
        set tempvar ""
        if {[string is integer -strict [lindex $lc_string 1]]} {
            for {set x 0} {$x < [llength $lc_string]} {incr x 2} {
              set fcpattern [lindex $lc_string $x]
              set fcpercent [lindex $lc_string $x+1]
              lappend tempvar "$fcpattern $fcpercent"
            }
            set MGC_filler_lib_cells $tempvar
	    # Place filler cells by using the percentage-based algorithm
	    set fill_groups {}
	    foreach filler_group $MGC_filler_lib_cells {
	        set filler_libcells [lindex $filler_group 0]
	        set filler_percentage [lindex $filler_group 1]
	        set filler_groupname [regsub -all {[*?]} $filler_libcells ""]
	        set_property -objects [get_lib_cells -filter is_filler -pattern $filler_libcells] -name is_dont_use -value false
	        create_filler_set -name FS_$filler_groupname -lib_cells [get_lib_cells -filter is_filler -pattern $filler_libcells]
	        lappend fill_groups FS_$filler_groupname $filler_percentage
	    }
            fk_msg -type info "Placing filler cells using filler sets."
            report_filler_sets
            puts "Filler set percentages:"
            for {set x 0} {$x < [llength $fill_groups]} {incr x 2} {
                puts "\t[lindex $fill_groups $x] = [lindex $fill_groups $x+1]%"
            }
            puts ""
	    place_filler_cells -filler_set_prefix true -filler_set_percentages $fill_groups -cpus $MGC_cpus -respect_blockages $MGC_filler_respect_blockages -ignore_bloats $ignoreBloat
        } else {
            set lc_list [get_lib_cells -filter @is_filler -pattern $MGC_filler_lib_cells]
            if {[llength $lc_list] == 0} {
                fk_msg -type error "Could not find any filler lib cells matching pattern $MGC_filler_lib_cells.  No fillers inserted.\n"
            } else {
                set_property -objects [get_lib_cells $lc_list] -name is_dont_use -value false
                fk_msg -type info "Placing filler cells using lib cells: $lc_list\n"
                place_filler_cells -cpus $MGC_cpus -lib_cells [get_lib_cells $lc_list] -respect_blockages $MGC_filler_respect_blockages -ignore_bloats $ignoreBloat -prefix FILL
            }
        }
    }

    # End of the standard filler routine - fill with DECAP if specified
    if { [info exists MGC_clk_decap] && [llength [get_lib_cells $MGC_clk_decap]] > 0} {
       fk_msg -type info "Removing CTS halo constraints and inserting decap based on variable MGC_clk_decap"

       # reset the DEF HALOs introduced in run_clock_timing
       foreach el $::MGC_clk_halo {
		set el [join $el]
		set lib_cell [lindex [split $el] 0]
		set clockCellsWithThisLibCell [get_cells -leaf -of [get_lib_cells $lib_cell] -filter @is_clock_network]
		set_property -name def_halo_left   -value 0 -object $clockCellsWithThisLibCell
		set_property -name def_halo_right  -value 0 -object $clockCellsWithThisLibCell
		set_property -name def_halo_top    -value 0 -object $clockCellsWithThisLibCell
		set_property -name def_halo_bottom -value 0 -object $clockCellsWithThisLibCell
       }
       fk_msg -type info "Inserting DECAP cells"
       place_filler_cells -prefix DECAP_ -cpus $MGC_cpus -lib_cells $MGC_clk_decap -respect_blockages $MGC_filler_respect_blockages -remove_existing false
    }

    ## Check for unfilled gaps.  
    ## This has a dependency on how fill was inserted under blockages.
    fk_msg -type info "Checking for unfilled gaps after filler cell insertion"
    if { $MGC_filler_respect_blockages == "hard" } {
            check_unfilled_gaps -include_gaps_under_blockage false
       } elseif { $MGC_filler_respect_blockages == "all" } {
            check_unfilled_gaps -include_gaps_under_blockage false
       } elseif { $MGC_filler_respect_blockages == "none" } {
            check_unfilled_gaps -include_gaps_under_blockage true
       }
         

    ## Check for any new DRC issues and fix them
    if {$MGC_inroute_drc == true} {
            if {[config_license -key calibreinroute]} {
                if {[string length $MGC_calibre_drc_deck] != 0} {
                    if {[string length $MGC_calibre_build] != 0} {
                        run_inroute_calibre -mode drc -calibre_server $MGC_calibre_build -drc_rule_file $MGC_calibre_drc_deck
                    } else {
                        fk_msg -type warning "Calibre server is  not specified. Running internal DRC check"
                        check_drc
                    }
                } else {
                    fk_msg -type warning "DRC deck not specified. Running internal DRC check"
                    check_drc
                }
            } else {
                fk_msg -type warning "Calibre InRoute license could not be found. Running internal DRC check"
                check_drc
            }
     } elseif {$MGC_inroute_drc == false} {
         check_drc
     } else {
         fk_msg -type error "PLease specify correct value for MGC_inroute_drc."
         return -code error
     }

    set num1 [llength [get_objects -type error -filter @category==drc]]
    if { $num1 } {
	if { $num1 > $num0 } {
	    fk_msg -type info "Number of DRC errors increased after filler cell insertion ($num1 > $num0). Running DRC clean-up \n"
	} else {
	    fk_msg -type info "Running DRC clean-up for remaining $num1 errors.\n"
	}
	clean_drc
	run_route_timing -mode repair -cpus $MGC_cpus -user_params "-drc_effort high -drc_accept number -dp_local_effort high"
	check_drc
	set num2 [llength [get_objects -type error -filter @category==drc]]
	if { $num2 } {
	    fk_msg -type info "$num2 DRC errors remain.\n"
	}
    }
}

## Insert Metal Fill
if { $skip_chip_finishing == false && $MGC_metal_fill == "nitro"} {
       fk_msg -type info "Inserting internal metal fill"
       insert_metal_fill
   } elseif {$skip_chip_finishing == false && $MGC_metal_fill == "inroute"} {
       if {[config_license -key calibreinroute]} {
           if {[string length $MGC_calibre_mfill_deck] != 0} {
               if {[string length $MGC_calibre_build] != 0} {
                   fk_msg -type info "Inserting InRoute metal fill"
                   run_inroute_calibre -mode mfill -calibre_server $MGC_calibre_build -mfill_rule_file $MGC_calibre_mfill_deck
               } else {
                   fk_msg -type warning "Calibre server is  not specified. Running internal Mfill"
                   insert_metal_fill
               }
           } else {
               fk_msg -type warning "Mfill deck not specified. Running internal Mfill"
               insert_metal_fill
           }
       } else {
           fk_msg -type warning "Calibre InRoute license could not be found. Running internal Mfill"
           insert_metal_fill
       }
   }

## Write out data
set design [current_design]
set dataDir output

if { [info exists MGC_tanner_flow] && $MGC_tanner_flow eq "true"} {
    # Write output data to EXPORT directory
    write_verilog -file results/[current_design].v -bus_aware true
    write_def -skip regions -all_vias -db_units 1000 -file results/routed.def -prefix_special_characters false
    write_rdb results/drc_results.rdb -type native_drc
    set corners [get_corners -filter enable]
    set modes [get_modes -filter enable]
    foreach el $modes {
	foreach el1 [get_objects -type corner -of_objects $el] {
	    write_sdf -corner $el1 -mode $el -file ./results/SDF_[current_design]_${el}_${el1}.sdf -skip_backslash true
	}
    }
    # Exporting SPEF
    foreach el $corners {
	write_spef -corner $el  -file ./results/SPEF_[current_design]_${el}.spef -coupling
    }
} else {
    write_verilog -file $dataDir/${design}.v.gz
    write_def -file $dataDir/${design}.def.gz
    write_lef -file $dataDir/${design}.lef.gz -lib_cells [get_lib_cells -of_objects [get_top_partition]]
}

# Export GDS
#we might need resolution 5.0:
#config_write_stream -resolution 5.0
if { $MGC_gds_layer_map_file != "" } {
    source $MGC_gds_layer_map_file
    write_stream -format gds -file $dataDir/${design}.gds
} elseif { $MGC_gds_layer_map_file == "" } {
    fk_msg -type warning "No GDS layer-map file specified in flow variable MGC_gds_layer_map_file.  GDS will not be written"
} 

# Save db
if { [file exists dbs/libs.db] } {
    ## split_db is true
    write_db -data design -file dbs/export.db
} else {
    write_db -data all -file dbs/export.db
}
nrf_utils::write_reports $MGC_flowStage reports 100

# Propagate power and grounds and output power netlist

if { [info exists MGC_no_exit] && $MGC_no_exit eq "true" } {
    fk_msg -type info "Because Nitro is not being exited, supply nets are not propagated and power netlist is not output by default.\n"
} else {
    propagate_power_and_ground_nets
    write_verilog -file $dataDir/${design}.power.v.gz -power true -well_connections true
    exit
}
