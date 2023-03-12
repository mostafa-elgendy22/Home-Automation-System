# ================================================
#  NITRO  KIT
#  Task : NRF flow customization 
#  Description: enable user to change, modify NRF flow
# ================================================
if { $MGC_flowStage == "import" } {
    ## Add any customizations here.  They will be sourced before the final write_db for lib/design
    # source additional_floorplan.tcl
    # source additional_lib_constraints.tcl

    # set my_dont_touch_instances [get_cells -leaf -quiet {u_core_top/my_reg_1 u_core_top/u121}]
    # set_property -name is_dont_modify -value true -objects $my_dont_touch_instances

    # set my_size_only_instance_list [get_cells -leaf -quiet {u_core_top/u_clk_control/u_fastmux_2 u_core_top/u_ddr/mode_mux_0}]
    # set_property -name is_size_only -value true -objects $my_size_only_instance_list

} elseif { $MGC_flowStage == "place" } {
    ## add here all configs, tcl variables for placement stage

    ## add here commands executed before placement

    ## do you need to change run_place_timing? skip, modify
    ## template of event handler for run_place_timing
    ## step : init gplace hfns pass1 iplace pass2 final
    ## event: before after
    proc ::rpt_user_event_handler {step event} {
	## Example:
	## if { $step == "larea1" && $event == "after" } {
        ##      puts "Add my script here"
        ## }
	## false : with event=before skips the step
	## false : with event=after  stops the flow
	## true  : continue run_place_timing
	return true
    }

    ## add here any post-placement commands
    ## event handler for run_place_timing command
    #config_event_handler -command run_place_timing -event end_command -script "source my_after_place_tcl"

} elseif { $MGC_flowStage == "clock" } {

    ## add here all configs, tcl variables for clock stage

    ## add here commands executed before run_clock_timing

    ## do you need to change run_clock_timing? skip, modify
    ## template of the event handler for run_clock_timing
    ## step : cts, setup, hold, converge, ...
    ## event: before after
    proc ::rct_user_event_handler {step event} {
	## false : with event=before skips the step
	## false : with event=after  stops the flow
	## true  : continue run_clock_timing
	return true
    }

    ## add here any post-clock commands
    ## event handler for run_clock_timing command
    #config_event_handler -command run_clock_timing -event end_command -script "source my_after_clock.tcl"

} elseif { $MGC_flowStage == "route" } {

    ## add here all configs, tcl variables for route stage

    ## add here commands executed before run_route_timing

    ## do you need to change run_route_timing? skip, modify
    ## template of event handler for run_route_timing
    ## step : start clock gr tr_opt iopt tr spread si via drc dp dvia opt open long finish
    ## event: before after
    proc ::tdro_user_event_handler { step event} {
	## skip  : with event=before skips the step
	## false : stops the flow
	## true  : continue run_route_timing
	return true
    }

    ## add here any post-route commands
    ## event handler for run_route_timing command
    #config_event_handler -command run_route_timing -event end_command -script "source my_after_route.tcl"
} elseif { $MGC_flowStage == "export" } {

  ## add here all configs, tcl variables for export stage
  ## You can change config for antenna fix , add filler , metal fills or design data output here

}
