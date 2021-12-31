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
#  Import checks			 	     #
#                                                    #
#  Perform some design integrity checks before       #
#  continuing with placement.  This is run at the    #
#  end of 0_import.tcl                               #
######################################################

puts "\n 
    ###################################################################################################################  
                         PERFORMING DESIGN CHECKS PLEASE REVIEW THESE BEFORE PROCEEDING FURTHER  
    ################################################################################################################### \n"
set echo [config_shell -echo_script false ]
set tline [config_shell -table_lines no_lines ]
set tclen [config_shell -max_table_column_len 10000]
set m_ui78 [config_message -message_id UI78 -max_message 0]
set m_ui33 [config_message -message_id UI33 -max_message 0]
#set out_line_len [config_shell -max_output_line_len 1 ]
set import_check_bit 0
set site_mismatch_error 0

check_design
check_floorplan
check_technology
report_region_utilization  -name temp_rru

## Report Corner summary and show # associated libs , can be put in kit_utils
proc report_corner_summary { } {
    foreach c [get_corners ] {
        set max_elec_lib  [llength [get_libs -type electrical  [split [get_property -name max_library $c] ,]]]
        set min_elec_lib  [llength [get_libs -type electrical  [split [get_property -name min_library $c] ,]]]
        set procc_lib [llength [get_libs -type process [get_property -name process_library  $c]]]
        set setup  [get_property -name setup  $c]
        set hold   [get_property -name hold   $c]
        set enable [get_property -name enable $c]
        lappend data "$c $max_elec_lib $min_elec_lib $procc_lib $setup $hold $enable"
    }
    print_table -title Corner_Summary -column_names "Corner #Max_Libs #Min_Libs #Proc_Libs Setup Hold Enable" -values $data
}

fk_msg "Please check the number of associated libraries in table below, each corners should have same number of associated libs"
report_corner_summary

## Report layer resistance and cap, check for non zero values
fk_msg "Please review layer resistance and capacitance values in tables below"
report_layer_capacitance
report_layer_resistance

## Report read constraints summary:
fk_msg "Please check timing constraints summary in table below"
report_read_constraints


set all_cells [get_cells -leaf -quiet]
set flat_nets [get_nets -flat  -quiet]


## Check Number of fixed cells which are non-physical and non macros
set no_fixed_non_phy_cells [llength [filter_collection -objects $all_cells -expression "@is_fixed && !@is_physical && !@is_macro"]]
if {$no_fixed_non_phy_cells > 0} {
     fk_msg -type warning "There are $no_fixed_non_phy_cells fixed non-physical cells and placer won't place/move them."
}

## Check number of don't modify cells and nets in the design
#set dont_modify_nets [llength [filter_collection -objects $flat_nets -expression "@is_dont_modify && !@is_power && !@is_ground && !@is_clock" ]]
set no_dont_modify_nets [llength [filter_collection -objects $flat_nets -expression "@is_dont_modify && !@is_power && !@is_ground && !@is_floating" ]]
if {$no_dont_modify_nets > 0} {
     fk_msg -type warning "There are $no_dont_modify_nets dont_modify nets and they won't be optimized"
}
set no_dont_modify_cells [llength [filter_collection -objects $all_cells -expression "@is_dont_modify && !@is_physical && !@is_macro"]]
if {$no_dont_modify_cells > 0} {
     fk_msg -type warning "There are $no_dont_modify_cells dont_modify cells and they won't be optimized"
}

## Number of detailed routed nets 
set no_detail_route_nets [llength [filter_collection -objects  $flat_nets -expression "@has_detail_route && !@is_power && !@is_ground && !@is_floating"]]
if {$no_detail_route_nets > 0} {
     fk_msg -type warning "There are $no_detail_route_nets nets with Detail Routes that might impact GR. Please check if detail routes are expected," 
}

## Check cells in the designs with is_dont_use lib cells : won't be optimized 
set no_cells_with_dont_use_lib_cells [llength [get_cells -of_objects [get_lib_cells -filter @is_dont_use && !@is_physical && !@is_macro] -quiet]]
if {$no_cells_with_dont_use_lib_cells > 0} {
     fk_msg -type warning "There are $no_cells_with_dont_use_lib_cells cells for which the used lib cell is dont use therefore these cells will not be optimized"
}


## Show unresolved lib cells instead of currently exiting try graceful return 
#check_design -check libraries 
#set unresolved_cells [llength [get_objects -type error unresolved -quiet]]
#if {$unresolved_cells == "" } { set unresolved_cells 0 }
#if {$unresolved_cells > 0} {
#    fk_msg -type error "Design has $unresolved_cells unresolved cells" 
#    return
#}
set cell_wo_elibs [get_objects -type lib_cell -of [get_objects -type error no_liberty_cell_used -quiet] -quiet]
if { [llength $cell_wo_elibs] > 0} {
    puts ""
    #fk_msg -type error "Design has [llength $cell_wo_elibs] lib cells with missing electrical libs:" 
    foreach lc $cell_wo_elibs {
        puts "\t$lc"
    }
    puts ""
    set import_check_bit 1
}
set cell_wo_timing   [llength [get_objects -type error no_timing_model_used -quiet]]
if {$cell_wo_timing == "" } { set cell_wo_timing 0 }
if {$cell_wo_timing > 0} {
    #fk_msg -type error "Design has $cell_wo_timing lib cells with incomplete electrical libs please provide .libs before proceeding further." 
    set import_check_bit 1
}

## Floorplan checks for No rows , mismatch sites, macro overlaps, missing rows, multi height cells , high init placement utilization
set missing_cell_rows  [llength [get_objects -type error missing_cell_rows -quiet]]
if {$missing_cell_rows == "" } { set missing_cell_rows 0 }
if {$missing_cell_rows > 0} {
    #fk_msg -type error "Design has Missing Cell Rows please fix this before proceeding further. No cell rows are found in the design. Placer will fail without rows." 
    set import_check_bit 1
}

set unmatched_cellrow_sites [llength [get_objects -type error unmatched_cellrow_sites -quiet]]
if {$unmatched_cellrow_sites == "" } { set unmatched_cellrow_sites 0 }
if {$unmatched_cellrow_sites > 0} {
    set csites [get_objects -type site -of_objects [get_cells -leaf -filter { !@is_macro && type!=pad && type!=endcap }]]
    set rsites [get_objects -type site -of_objects [get_objects -type row]]
    if { [compare_lists -first_list $csites -second_list $rsites -operation is_subset] } {
        fk_msg -type warning "Design has rows with sites that do not match library cell sites."
    } else {
        #fk_msg -type error "Design has rows with sites that do not match library cell sites. Placer will fail since row site must match cell site."
        set site_mismatch_error 1
	set import_check_bit 1
    }
}

set macro_overlap          [llength  [get_objects -type error macro_overlap -quiet]]
if {$macro_overlap == "" } { set macro_overlap 0 }
if {$macro_overlap > 0} {
    #fk_msg -type error "Design has overlapping macros. Please fix it before proceeding further."
    set import_check_bit 1
}

if {$import_check_bit == 1} {
    puts "\n 
	###########################################################################################################################  
                             ERRORS DETECTED DURING IMPORT DESIGN CHECKS! PLEASE REVIEW BEFORE PROCEEDING FURTHER  
	########################################################################################################################### \n"

   if { [llength $cell_wo_elibs] > 0} {
       puts ""
       fk_msg -type error "Design has [llength $cell_wo_elibs] lib cells with missing electrical libs:" 
       foreach lc $cell_wo_elibs {
           puts "\t$lc"
       }
       puts ""
   }
   
   if {$cell_wo_timing > 0} {
       fk_msg -type error "Design has $cell_wo_timing lib cells with incomplete electrical libs please provide .libs before proceeding further." 
   }

   if {$missing_cell_rows > 0} {
       fk_msg -type error "Design has Missing Cell Rows please fix this before proceeding further. No cell rows are found in the design. Placer will fail without rows." 
   }

   if {$site_mismatch_error ==1 } {
       fk_msg -type error "Design has rows with sites that do not match library cell sites. Placer will fail since row site must match cell site."
   }

   if {$macro_overlap > 0} {
       fk_msg -type error "Design has overlapping macros. Please fix it before proceeding further."
   }

    return code error 
}

set placer_utilization [get_report_value -name temp_rru -table region_utilization -col placer_utilization]
if {$placer_utilization > 80} {
    fk_msg -type warning "Design has $placer_utilization placement utilization. Please review if this high utilization is expected before proceeding further." 
} else {
    fk_msg "Design has $placer_utilization initial placement utilization." 
}

remove_report -name temp_rru

#set tdata ""
#lappend tdata "no_cells_with_dont_use_lib_cells $no_cells_with_dont_use_lib_cells aaa no_fixed_non_phy_cells $no_fixed_non_phy_cells xxx no_dont_modify_nets $no_dont_modify_nets xxx no_dont_modify_cells $no_dont_modify_cells xxx no_detail_route_nets $no_detail_route_nets xxx unresolved_cells $unresolved_cells xxx cell_wo_elibs $cell_wo_elibs xxx cell_wo_timing $cell_wo_timing xxx missing_cell_rows $missing_cell_rows xxx unmatched_cellrow_sites $unmatched_cellrow_sites xxx macro_overlap $macro_overlap xxx placer_utilization $placer_utilization xxx"
#print_table -title "Import Design Flow Checks" -column_names "Check_Name  Value Information" -value $tdata

## Check zero RC timing after saving DB
if {0} {
    config_timing -zero_rc_delays true
    update_timing
    report_path_group -vio 
    if {[llength [get_corners -filter hold && enable -quiet ]] > 0} { 
        report_path_group -vio -min
    }
}

## Check missing timing arcs 
if {0} {
     check_timing_constraints -timing_arcs 
}

## Check output ports for suspiciously high loading
nrf_utils::check_port_caps

## Report AOCV derates if loaded with AOCV libs
if { [info exists MGC_aocv_library] && [array size MGC_aocv_library] > 0} {
   redirect -file reports/import_aocv_derates.rtp {report_aocv_derate}
}

## Report units settings
config_shell -table_lines outline
config_units

puts "\n 
    ######################################################################################################################  
                         FINISHED IMPORT DESIGN CHECKS PLEASE REVIEW ABOVE BEFORE PROCEEDING FURTHER  
    ###################################################################################################################### \n"


#config_shell -max_output_line_len $out_line_len
config_shell -max_table_column_len $tclen
config_shell -table_lines $tline 
config_message -message_id UI78 -max_message $m_ui78 
config_message -message_id UI33 -max_message $m_ui33
set tt [config_shell -echo_script $echo ]
