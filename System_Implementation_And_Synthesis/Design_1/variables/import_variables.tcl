#####################################################
## Copyright Mentor, A Siemens Business            ##
## All Rights Reserved                             ##
##                                                 ##
## THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY ##
## INFORMATION WHICH ARE THE PROPERTY OF MENTOR    ##
## GRAPHICS CORPORATION OR ITS LICENSORS AND IS    ##
## SUBJECT TO LICENSE TERMS.                       ##
#####################################################
#################################################################
## List of technology variables needed for 0_import_design.tcl ##
## Set the values to relate to design being implemented.       ##
#################################################################
##########################################################################################################################
# REQUIRED Variables: These variables are required to be set and must correspond to libs & design being implemented.     #
# REVIEW Variables  : These variables must be reviewed to be sure they are appropriate for the current design.           #
# ADVANCED Variables: The default value for these variables is typically adequate for most designs.                      #
#                       Advanced variables may be changed by user to resolve specific issues in the implementation flow. #
##########################################################################################################################
#                   Variables needed to build library database dbs/libs.db                                               #
##########################################################################################################################
set MGC_no_exit true
set MGC_nrf_custom_scripts_dir  ""            ; # REVIEW: Directory with custom import scripts.  Leave empty to use standard release scripts.

## If a lib.db file already exists, provide name, including path, to skip lib.db generation steps

set MGC_libDbPath               ""            ; # REVIEW: Path to the lib.db if it exists for current design. 
#set MGC_libDbPath     "/home/vlsi/Desktop/Lab5/work/dbs/libs.db/"

## This section contains variables related to tech files 

set MGC_physical_library_tech   "/home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/lib_data/NangateOpenCellLibrary.tech.lef"   ; # REQUIRED: Path to Tech LEF file. Typically used for 40nm and above
set MGC_physical_libraries      "/home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/lib_data/NangateOpenCellLibrary.macro.lef"            ; # REQUIRED: Path to standard cell and macro LEF files. For example lef/std_cell.lef
set MGC_itf_to_lef_layer_map    ""            ; # REVIEW  : Path to a layer mapping file when there is a mismatch between LEF and PTF layer names. For example itf/map.txt
set MGC_tech_rules              ""            ; # ADVANCED: Path to Tech Rule files needed for lower tech nodes (typically 28nm and below). For example tech_file.tcl 
set MGC_disable_SDA_vias_creation false       ; # ADVANCED: Set to true to prevent Nitro from generating vias
set MGC_tech_vias               ""            ; # ADVANCED: Path to Via definition file needed for lower tech nodes (typically 28n and below). For example vias.tcl
set MGC_tech_dfm_vias           ""            ; # ADVANCED: Path to DFM Via definition file needed for lower tech nodes (typically 28nm and below). For example dfm_vias.tcl
set MGC_customNdrFile           ""            ; # ADVANCED: This is the user specified file with all NDR/Shield info 

## This section contains all variables needed to define the design corners and modes

## REQUIRED: Identify the PTF file(s) corresponding to each parasitic condition 
## 	     The name of the array key is a user generated label used to identify PTF file(s) for a specific condition
##
## Example:
## 	array set MGC_parasitic_library {
##     		TYPICAL TYPICAL.ptf
##     		CMAX    CMAX.ptf
##     		CMIN    CMIN.ptf
## 	}
## Alternatively :
## 	set MGC_parasitic_library(TYPICAL) TYPICAL.ptf
## 	set MGC_parasitic_library(CMAX)    CMAX.ptf
## 	set MGC_parasitic_library(CMIN)    CMIN.ptf
set MGC_parasitic_library(new_rc) /home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/lib_data/NCSU_FreePDK_45nm.ptf

## REQUIRED: Identify the timing library files (.lib) corresponding to each PVT condition 
## 	     The name of the array key is a user generated label used to identify the .lib file(s) for a specific PVT condition
##
## Example:
## 	array set MGC_timing_library {
##     		ss_0.90v_m40c {ss_0.90v_m40c.lib}
##     		ss_0.90v_125c {ss_0.90v_125c}
## 	}
## Alternatively :
## 	set MGC_timing_library(ss_0.90v_m40c) {ss_0.90v_m40c.lib}
## 	set MGC_timing_library(ss_0.90v_125c) {ss_0.90v_125c}
set MGC_timing_library(new_pvt) /home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/lib_data/NangateOpenCellLibrary_typical.lib

## REQUIRED: Provide names for the design analysis corners.
## 	     These names will be used to associate the PTF, .lib and temperatures to each analysis corner
##
## Example: 
## 	set MGC_corners {ss_0.90v_m40c_TYPICAL ss_0.90v_m40c_CMAX ss_0.90v_125c_TYPICAL ss_0.90v_125c_CMAX}
set MGC_corners {corner_0_0}

## REQUIRED: Associate the temperature, parasitic condition and PVT condition to to each analysis corner
##           Index names must match analysis corner names from MGC_corners variable above
##           Parasitic condition index is user generated index name from MGC_parasitic_library
##           PVT condition index is user generated index name from MGC_timing_library
##
## 	     MGC_CornerTemperature : Temperature for designated analysis corner
## 	     MGC_CornerParasitic   : Parasitic condition index for designated analysis corner
## 	     MGC_CornerTiming      : PVT condition index for designated analysis corner
##
## Example:
## 	array set MGC_CornerTemperature {
##     		ss_0.90v_m40c_TYPICAL -40.0
## 	}
## 	array set MGC_CornerParasitic {
##     		ss_0.90v_m40c_TYPICAL TYPICAL 
## 	}
## 	array set MGC_CornerTiming {
##     		ss_0.90v_m40c_TYPICAL ss_0.90v_m40c
## 	}
## Alternatively :
## 	set MGC_CornerTemperature(ss_0.90v_m40c_TYPICAL) -40.0   
## 	set MGC_CornerParasitic(ss_0.90v_m40c_TYPICAL) TYPICAL   
## 	set MGC_CornerTiming(ss_0.90v_m40c_TYPICAL) ss_0.90v_m40c 
set MGC_CornerTemperature(corner_0_0) 25
set MGC_CornerParasitic(corner_0_0) new_rc
set MGC_CornerTiming(corner_0_0) new_pvt

## ADVANCED: Associate the AOCV lib files with the previously defined corner indecies
##           Identify the aocv-lib files corresponding to each AOCV condition 
## 	     The name of the array key is a user generated label used to identify the aocv-lib file(s) for a specific AOCV condition
## Example:
## 	array set MGC_aocv_library {
##     		ss_0.90v_m40c {ss_0.90v_m40c.lib}
##     		ss_0.90v_125c {ss_0.90v_125c.lib}
## 	}
## Alternatively :
## 	set MGC_aocv_library(ss_0.90v_m40c) {ss_0.90v_m40c.lib}
## 	set MGC_aocv_library(ss_0.90v_125c) {ss_0.90v_125c.lib}


##########################################################################################################################
#                   END: Variables needed to build Library database dbs/libs.db                                          #
##########################################################################################################################

##########################################################################################################################
#                   START: Variables needed to build design database dbs/import.db                                       #
##########################################################################################################################
set MGC_importVerilogNetlist "/home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/output/verilog/home_automation_system.syn.v"                     ; # REQUIRED: Path to vg netlist.  Multiple files/wildcards allowed, but must 
                                                      #           match vg files only. NOT REQUIRED FOR mxdb flow.
set MGC_topDesign            "home_automation_system"                     ; # REVIEW  : Name of top level module in verilog netlist(s).
set MGC_nrf_floorplanning    "auto"                     ; # REVIEW  : Type floorplanning to be performed: auto | manual | none
#set MGC_floorLoadDefFile     "/home/vlsi/Desktop/VLSI-Project/SystemImplementationAndSynthesis/output/floorplan/demo_adder.def"                     ; # REVIEW  : Path to floorPlan def if available
set MGC_floorLoadDefFile      ""
set MGC_KeepDefRegions       false                           ; # REVIEW  : Keep the Region Information while reading DEF
set MGC_scan_def_file        ""                     ; # REVIEW  : Path to scan def if available
set MGC_floorplan_tcl_file   "" ;#"/home/vlsi/Desktop/Lab5/work/import.db/.fp.tcl"                     ; # REVIEW  : Name, including path, of Tcl file with additional floorplanning steps
set MGC_skip_ccs             true                  ; # ADVANCED: By default, Nitro reads ccs information if available in liberty files.
set MGC_modes                {new_mode}                     ; # REQUIRED: User generated name(s) for design modes. Example: {func shift}

## REQUIRED: Associate the design modes (from MGC_modes) to analysis corners (from MGC_corners)
##
## Example:
## 	array set MGC_cornersPerMode {
##     		func  "ss_0.90v_m40c_TYPICAL ss_0.90v_m40c_CMAX ss_0.90v_125c_TYPICAL ss_0.90v_125c_CMAX"
##     		shift "ss_0.90v_m40c_TYPICAL ss_0.90v_m40c_CMAX ss_0.90v_125c_TYPICAL ss_0.90v_125c_CMAX"
## 	}
## Alternatively :
## 	set MGC_cornersPerMode(func)  {ss_0.90v_m40c_TYPICAL ss_0.90v_m40c_CMAX ss_0.90v_125c_TYPICAL ss_0.90v_125c_CMAX}
## 	set MGC_cornersPerMode(shift) {ss_0.90v_m40c_TYPICAL ss_0.90v_m40c_CMAX ss_0.90v_125c_TYPICAL ss_0.90v_125c_CMAX}
set MGC_cornersPerMode(new_mode) corner_0_0

## REQUIRED: Identify the timing constraints file(s) (.sdc) for each mode.
##
## Example:
## 	array set MGC_importConstraintsFile {
##     		func  "/path/func.sdc  /path/user_constraints_func.sdc"
##     		shift "/path/shift.sdc /path/user_constraints_shift.sdc"
## 	}
## Alternatively :
## 	set MGC_importConstraintsFile(func)  "/path/func.sdc  /path/user_constraints_func.sdc"
## 	set MGC_importConstraintsFile(shift) "/path/shift.sdc /path/user_constraints_shift.sdc"
set MGC_importConstraintsFile(new_mode) /home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/constraints/module_func.sdc

set MGC_primary_power_net        ""         ; # REQUIRED: Primary power net name.
set MGC_primary_ground_net       ""         ; # REQUIRED: Primary ground net name.
set MGC_MultiVoltage             false      ; # ADVANCED: Enable if the design is multivoltage.  UPF file necessary if true.
set MGC_UPF_File                 "/home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/constraints/module.85.upf"         ; # ADVANCED: Unified Power Format (UPF) for defining design power intent.
set MGC_additional_MV_Setup_File ""         ; # ADVANCED: Additional MV file if necessary (ie, region creation, special settings, etc).
set MGC_mxdb_flow                false      ; # ADVANCED: Set to true to use Oasys mxdb flow.
set MGC_mxdb_path                ""         ; # ADVANCED: Path to mxdb when Oasys mxdb flow is used.
set MGC_cpus                     2         ; # ADVANCED: Used for config_app; will use less if total is not available.
set MGC_split_db                 true       ; # ADVANCED: Set to false if you want to use full db.
##########################################################################################################################
#                   END: Variables needed to build design database dbs/import.db                                         #
##########################################################################################################################

