proc run_0rc_remap {{margin 0.2n}} {
    config_timing -zero_rc_delay true
   
    optimize -mode global -obj "wns drc"
    set remap_critical_logic_skip_mux_remap true
    debug_opt -use_remap_critical_logic_in_local_optimization "wns tns"
    optimize -mode local -obj "wns tns" 
    
    set_slack_margin -setup -margin $margin
    run_remap_optimize -effort ultra -objective {wns tns} -skip_dpgr
    remove_slack_margin -all
    report_path_group -violators_only
    config_timing -zero_rc_delay false
}

proc run_rco_wns {{iterations 1}} {
    fk_msg "Running rco_wns flow" 
    config_clockdata_optimize -name dynamic_offset_levels           -value true
    config_clockdata_optimize -name existing_offsets_method         -value incremental
    config_clockdata_optimize -name optimize_data                   -value false
    config_clockdata_optimize -name optimize_area                   -value false
    config_clockdata_optimize -name hide_self_loops                 -value true
    
    run_clockdata_opt -iterations $iterations
}

proc FindCritDeltaDelayDriver {slack_thresh ddelay_thresh length buffer max_dist file1 file2} {
    set crit_delta {}

    set delta_delay_pins [get_pins [report_constraint -si_delay_slowdown -all_violators -objects] -filter "!@is_clock_pin"]
    set DEL [open $file2 w]

    if {[llength $delta_delay_pins]>0} {
        foreach item $delta_delay_pins {
            set driver [lindex [get_pins -leaf -filter @is_driver -of [get_nets -of $item]] 0]
            set ddelay [get_delay -si_delta -from $driver -to $item]
            if {$ddelay > $ddelay_thresh} {
                set slack [get_property [get_timing_path -through $driver] -name slack]
                if {$slack < $slack_thresh} { 
                    lappend crit_delta $item 
                    puts $DEL "$item $slack $ddelay"
                }
	    }
	}
        set plist [get_pins -leaf -filter @is_driver -of [get_nets -flat -of $crit_delta]]
    } else { fk_msg "No Delta delay violators found"; return }
    set nets_list [get_nets -of $plist]
    set long_nets [filter_collection -expression "@max_pin_to_pin_wire_length > $length" -objects $nets_list]
    fk_msg "Nets targeted are: [llength $long_nets]"
    puts $DEL "#########NETS############"
    foreach net $long_nets {
	puts $DEL "$net [get_property -obj [get_nets $net] -name max_pin_to_pin_wire_length]"
    }
    set file_handle [open $file1 w]
    puts $file_handle "config_shell -ignore_error false" 
    foreach net $long_nets {                                                                                                       
        puts $file_handle "create_buffer -lib_cell $buffer -pin [get_pins -filter @is_driver -of_objects [get_nets $net]] -length $length -max_distance_to_wire $max_dist"
    }
    
    puts $file_handle "config_shell -ignore_error true"
    return $plist
    close $file_handle
    close $DEL
}

proc FindCritDeltaDelayDriver_hold {slack_thresh ddelay_thresh length buffer max_dist file1 file2} {
    set crit_delta {}

    set delta_delay_pins [get_pins [report_constraint -si_delay_speedup -all_violators -objects] -filter "!@is_clock_pin"]
    set DEL [open $file2 w]

    if {[llength $delta_delay_pins]>0} {
        foreach item $delta_delay_pins {
            set driver [lindex [get_pins -leaf -filter @is_driver -of [get_nets -of $item]] 0]
            set ddelay [get_delay -si_delta -from $driver -to $item]
            if {$ddelay > $ddelay_thresh} {
                set slack [get_property [get_timing_path -through $driver -min_delay] -name slack]
                if {$slack < $slack_thresh} { 
                    lappend crit_delta $item 
                    puts $DEL "$item $slack $ddelay"
                }
	    }
	}
        set plist [get_pins -leaf -filter @is_driver -of [get_nets -flat -of $crit_delta]]
    } else { fk_msg "No Delta delay violators found"; return }
    set nets_list [get_nets -of $plist]
    set long_nets [filter_collection -expression "@max_pin_to_pin_wire_length > $length" -objects $nets_list]
    fk_msg "Nets targeted are: [llength $long_nets]"
    puts $DEL "#########NETS############"
    foreach net $long_nets {
	puts $DEL "$net [get_property -obj [get_nets $net] -name max_pin_to_pin_wire_length]"
    }
    set file_handle [open $file1 w]
    puts $file_handle "config_shell -ignore_error false" 
    foreach net $long_nets {                                                                                                       
        puts $file_handle "create_buffer -lib_cell $buffer -pin [get_pins -filter @is_driver -of_objects [get_nets $net]] -length $length -max_distance_to_wire $max_dist"
    }
    puts $file_handle "config_shell -ignore_error true"
    close $file_handle
    close $DEL
    return $plist
}

proc reset_clock_based_max_transition {} {
   fk_msg "reset per clock based transition constraint"
   foreach_in_collection mode [get_modes -filter enable ] {
   set clks [get_clocks -mode $mode -filter !@is_virtual]
   
   foreach_in_collection c $clks {
      remove_max_transition -data_path true -clock_path false -objects [get_clocks $c] -mode $mode
      }
   }
}

proc run_usqOnly_opt_ws {} {
    config_optimize -enable_useful_skew true
    config_xforms -only UsefulSkewOpt
    config_optimize -multi_process_count 0
    optimize -mode post_route -post_route white_space -obj "wns" 
    config_optimize -multi_process_count 4
    config_xform -reset
    config_xform -exclude {TrimBufChain}
    config_optimize -enable_useful_skew false
}

proc fast_concat {argm} {
       set rsl ""
       foreach arg $argm {
           foreach ar $arg {
               lappend rsl $ar
           }
       }
       return $rsl
}

proc get_config_value { cmd_name config_name } {
    set rvalue ""
    set orig_shell [config_shell -table_lines vertical_lines]
    set orig_echo  [config_shell -echo false]
    if {[string match $cmd_name config_cts] || [string match $cmd_name config_application] || [string match $cmd_name config_shell]} {
        redirect -variable x -command { $cmd_name }
    } else {
        redirect -variable x -command { $cmd_name -report }
    }
    foreach y $x {
        set ty [split $y |]
        if { [string match [string trim [lindex $ty 1]] $config_name] } {
        set rvalue [lindex $ty 2]
        }
    }
    config_shell -table_lines $orig_shell
    config_shell -echo $orig_echo
    if { $rvalue != "" } { return [fast_concat $rvalue]} else { fk_msg -type error "$config_name not found in $cmd_name" }
}

proc nrf_get_saif_mode { MGC_powerCorner } { 
    #set mc ""
    set enabledModes [get_modes -filter enable ]
    foreach m $enabledModes {
        if { [lsearch [get_corners -of_obj $m] $MGC_powerCorner]!=-1 } {
            #set mc $m
            return $m
        }
    }
    ## Not possible to get this error so commenting out
    #if { $mc == "" } { 
    #    fk_msg -type error "No modes assocatiated with power corner : $MGC_powerCorner enabled"
    #    return -code error
    #}
}

