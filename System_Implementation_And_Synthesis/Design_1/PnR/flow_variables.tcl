#####################################################
## Copyright Mentor, A Siemens Business            ##
## All Rights Reserved                             ##
## Version : 2019.1.R2                             ##
## THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY ##
## INFORMATION WHICH ARE THE PROPERTY OF MENTOR    ##
## GRAPHICS CORPORATION OR ITS LICENSORS AND IS    ##
## SUBJECT TO LICENSE TERMS.                       ##
#####################################################
##############################################################
## List of technology variables used in the Nitro Ref Flow. ##
## Set the values to relate to design being implemented.    ##
##############################################################
##########################################################################################################################
# REQUIRED Variables: These variables are required to be set and must correspond to libs & design being implemented.     #
# REVIEW Variables  : These variables must be reviewed to be sure they are appropriate for the current design.           #
# ADVANCED Variables: The default value for these variables is typically adequate for most designs.                      #
#                       Advanced variables may be changed by user to resolve specific issues in the implementation flow. #
##########################################################################################################################
#############################################################
#### Generic variables
#############################################################
set MGC_cpus 2                       ; # ADVANCED: Used for config_app, recommanded to use 16
set MGC_no_exit true                 ; # ADVANCED: Save design data base and exit the flow after each stage
set MGC_append_reports true           ; # ADVANCED: Reports from each stage will be appended to.  If you wish to over-write, set to false.
                                        #           When set to false, older reports will be moved to a backup file with the file's datestamp in the name.
set MGC_techDontUseCellList {}        ; # ADVANCED: list of dont use cells
set MGC_techDontUseCellFile ""        ; # ADVANCED: file with a list of cells in quotes
set MGC_OCV regular                   ; # ADVANCED: Supported values are regular|pocv|aocv. POCV will be used starting from post-cts stage 
set MGC_maxLengthParam 1000u          ; # ADVANCED: Max length which should be targeted for checks and fixing.
set MGC_clkBasedMaxTranFactor 0.2     ; # ADVANCED: Max transition setting based on pin's related clock -- pin max tran = factor * pin related clock period
set MGC_flow_effort medium            ; # ADVANCED: Medium is default, while low is to be used for design with easy timing & routability
set MGC_min_filler_space 1            ; # REVIEW  : Specify the min_filler_space based on the technology

#############################################################
### CLOCK NDR and Shielding
### Priority: 1) MGC_CLOCK_NDR_NAME 2) Default, MGC_NdrSpaceMultiplier & MGC_NdrWidthMultiplier
###   MGC_NdrWidthMultiplier and MGC_NdrSpaceMultiplier are prefered way of defining clock NDR
###   If MGC_CLOCK_NDR_NAME is set : NDR with this name must exist 
###   NDR setup uses layers: MGC_CtsBottomPreferredLayer, MGC_CtsTopPreferredLayer, and MGC_MaxRouteLayer
###   and special vias: MGC_clock_route_ndr_vias 
###   Shielding is controlled by MGC_applyShield, and it uses MGC_clock_shield_net
#############################################################
set MGC_CtsBottomPreferredLayer {}    ; # ADVANCED: Specify bottom layer for CTS and apply NDR 
set MGC_CtsTopPreferredLayer    {}    ; # ADVANCED: Specify top layer for CTS and apply NDR
set MGC_NdrWidthMultiplier   1        ; # REVIEW  : How many minimum width times should be the width of the wire
set MGC_NdrSpaceMultiplier   2        ; # REVIEW  : How many minimum spacing times should be the spacing
set MGC_CLOCK_NDR_NAME       ""       ; # ADVANCED: Specify name if using existing NDR from technology/db, flow won't auto create ndr, and will assign specified NDR 
set MGC_clock_route_ndr_vias {}       ; # ADVANCED: Path to TCL file which defines and attaches NDR via to NDR rules 
set MGC_applyShield      auto         ; # ADVANCED: Select shielding for advanced technologies or if set to 'true'
set MGC_clock_shield_net {}           ; # ADVANCED: Needed for shield setup if clock NDR is shielding

#############################################################
## Active corners, modes, libraries for flow stages
#############################################################
## ADVANCED: Identify the active modes & corners for each flow step
##           The name & number of array keys is fixed and defines each flow step
##           The modes & corners should match those of the design as defined
##           in the import_variables.tcl file.
##
## Example:
##      array set MGC_activeModes {
##              place	func
##              clock	func
##              route	func
##      }
## Alternatively :
##      set MGC_activeModes(place) func
##      set MGC_activeModes(clock) func
##      set MGC_activeModes(route) func

array set MGC_activeModes {
               place {new_mode}
               clock {new_mode}
               route {new_mode}
}
array set MGC_activeCorners {
         place:setup {corner_0_0}
          place:hold {corner_0_0}
           clock:ref {corner_0_0}
         clock:setup {corner_0_0}
          clock:hold {corner_0_0}
         route:setup {corner_0_0}
          route:hold {corner_0_0}
}

## REVIEW: Set the following variables when leakage power is a concern and library has cells from multiple VT classes.
## If not set tool will use all available VT classes
## To enable different VT classes at different stages of the flow set these variables
##  Example place *SVT : means it will only use SVT cell in place

set MGC_cellProcessList {}            ; # pattern of available VT cells: set MGC_cellProcessList {*LVT *HVT *SVT}
array set MGC_targetLibraries {
               place {}
               clock {}
               route {}
}

###################################################################
### Low power Flow Variables, don't need to change for regular flow 
###################################################################
set MGC_powerEffort none                   ; # ADVANCED: Possible values are: none (default), low, medium, high : passed to a RPT; RCT and RRT
set MGC_powerCorner ""                     ; # ADVANCED: Defines the enabled setup corner to use for dynamic power analysis
set MGC_leakageCorner ""                   ; # ADVANCED: Defines the corner for leakage power analysis (MGC_powerCorner is used if empty)
set MGC_saifFile ""                        ; # ADVANCED: Path to a SAIF file
set MGC_leakageDerate 1                    ; # ADVANCED: Adjust weight of leakage vs. dynamic power

###################################################################
### PLACE stage variables
###################################################################
set MGC_fix_assigns                  false ; # ADVANCED: Remove assigns from incoming netlist
set MGC_skip_precondition            true  ; # ADVANCED: Can be true or false, if true, RPT will skip precondition. 
set MGC_high_effort_remap            false ; # ADVANCED: If true, remap optimization would be triggered in place 
set MGC_place_high_effort_congestion false ; # ADVANCED: If true, enables high effort congestion for RPT
set MGC_enable_pre_cts_incr          false ; # ADVANCED: Performs additional optimizations at the end of place stage

###################################################################
### CLOCK stage variables
###################################################################
## CTS will use buffers and/or inverters based on the given list. Definition has precedence over the dont_use property of the library cell.
## These definitions are required to avoid unwanted library cells to be used on the clock network (delay cells, cell with high leakage current, etc.)
set MGC_ck_buf_cell_list {}                ; # ADVANCED: Acceptable list of library buffer cells on the clock network 
set MGC_ck_inv_cell_list {}                ; # ADVANCED: Acceptable list of library inverter cells on the clock network 
set MGC_cts_force_inverter_only false      ; # ADVANCED: Build clock tree with inverters only
set MGC_set_ports_as_clock_leaves false    ; # REVIEW  : By default, output clock ports are not balanced with the other leaves. When set to 'true', output clock ports are valid clock leaves.
set MGC_cts_max_trans 0.25n                ; # REVIEW  : max_tranision constraint on the clock network 
set MGC_cts_max_leaf_trans 0.25n           ; # ADVANCED: max_tranision constraint at the leaf pins. The slew at leaf clock pins is impacting value of the timing check.
set MGC_cts_max_skew 0.15n                 ; # REVIEW  : Target maximum skew

##
## CTS customization is provided with scr/cts_spec.tcl
## This file is loaded when MGC_cts_custom_spec is set to 'true'.
## This file is expected to contain CTS spec definitions and, optionally, CTS exceptions (valid and/or excluded leaves, CTS offsets,...). 
## By default, a 'compile_cts' directive is applied after sourcing this file.
## Some custom compilation directives can also be added to scr/cts_spec.tcl. In such a case, MGC_cts_custom_compile has to be set to 'true' and 'compile_cts' is skipped.
set MGC_cts_custom_spec false              ; # ADVANCED: When 'true' NRF flow uses custom CTS spec from scr/cts_spec.tcl 
set MGC_cts_custom_compile false           ; # ADVANCED: When 'true' and MGC_cts_custom_spec also 'true' NRF flow interprets scr/cts_spec.tcl as cts compile script

set MGC_ck_cg_cell_list  {}                ; # ADVANCED: Specify a list of acceptable libcells or a pattern for Clock Gate Optimization during CTS. By default all dont_use==false libcells can be used.
set MGC_add_decap_around_clk_cells false   ; # ADVANCED: If true, then user can provide insert_clock_decap.tcl for customized insertion of decaps around clock cells
set MGC_clk_decap {}                       ; # ADVANCED: List of decap cells to be inserted for CTS EM protection. USER MUST SPECIFY THE SMALLEST FILLER CELL along with the decap cells in variable.
set MGC_clock_refine_cts false             ; # ADVANCED: Enable/disable refine cts after compile cts
set MGC_clk_halo {}                        ; # ADVANCED: The halo serves as a placement obstruction to keep a certain minimum distance between clock buffers and/or gating cells (to avoid EM issues).
					     #           Values: "{<master1> <halo1_X> <halo1_Y>} {<master2> <halo2_X> <halo2_Y>} ...".  Halo values are expected in um. Typical usage is to use DECAP cell width for X halo, and 0 for Y halo.
set MGC_tie_low_cell   ""                  ; # ADVANCED: specify tie-low lib_cell for tie-cell insertion
set MGC_tie_high_cell  ""                  ; # ADVANCED: specify tie-high lib_cell for tie-cell insertion
set MGC_tie_max_fanout 8                   ; # ADVANCED: max_fanout if user wished to over-ride lib limits

###################################################################
### POSTCTS flow variables
###################################################################
set MGC_crpr_threshold 5p                  ; # ADVANCED: crpr threshold
set MGC_DLY_cells {}                       ; # ADVANCED: List of delay cells needed for hold fixing				
set MGC_max_trans_on_macro_pins_value 0    ; # ADVANCED : This is the transition value for macro pins if user constraints them
set MGC_enable_clock_data_opt false        ; # ADVANCED  : Enable clock data optimization at clock stage

###################################################################
### ROUTE flow variables
###################################################################
set MGC_MaxRouteLayer {metal8}              ; # ADVANCED: Max routing layer
set MGC_replace_dfm true              ; # ADVANCED : Set to true to enable DFM via replacement

###################################################################
### EXPORT flow variables
###################################################################
set MGC_filler_lib_cells "FILLCELL*"                ; # REQUIRED:  Place Fillers with filler lib cell pattern 
                                             # Example 1: set MGC_filler_lib_cells "*FILLX*"
                                             # Example 2: Filter lib cell patterns and percentage set MGC_filler_lib_cells {{"*_FILL*" 85} {"*DECAP*" 15}} 
set MGC_gds_layer_map_file ""              ; # REQUIRED : path to layer map file
set MGC_fix_antenna_use_diodes false       ; # REVIEW  : Fix Antenna true|false
set MGC_fix_antenna_diodes ""              ; # REVIEW  : Fix Antenna with list of antenna libcells
set MGC_filler_respect_blockages "hard"    ; # ADVANCED: 'hard' is nitro default 
                                             #   'all'  means NO filler cells will be placed under hard OR soft blockages 
                                             #   'none' means filler cells will be placed under all hard OR soft blockages

set MGC_inroute_drc false                  ; #Set to true if you want to perform InRoute Calibre DRC check instead of DRC native engine
set MGC_calibre_build ""                   ; #Specifies the Calibre server build path to be used for INRoute Calibre checks
set MGC_calibre_drc_deck ""                ; #Specifies Calibre DRC rule file for InRoute Calibre DRC check
set MGC_calibre_mfill_deck ""              ; #Specifies Calibre Mfill rule file for performing INRoute Calibre Mfill
set MGC_metal_fill "none"                  ; #Legal values “none | nitro | inroute” for no metal fill, Nitro metal fill and Calibre metal fill respectively.


