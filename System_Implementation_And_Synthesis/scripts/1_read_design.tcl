
#########################################################
#                 1_read_design.tcl
#
# Description:  Load the design input files into
#               Oasys-RTL and set design
#               conditions. Must be run after the
#               init_design.tcl script
#
# Usage:        source in Oasys-RTL Command prompt
#
# Dependencies: init_design.tcl
#               read_tech_libs.tcl
#               Launched from Oasys-RTL shell
#
#########################################################

#Check if dependent scripts have been loaded
if {![info exists top_module]} {
source scripts/0_init_design.tcl
}

#=======================================================#
#Load technology libraries (Liberty and LEF)
#=======================================================#

#Read logical libraries
read_library $std_vlt_lib 

#Read the technology LEF
    read_lef $tech_file

#Read the LEF macros
    foreach lef $lef_files {
        read_lef $lef
    }


#=======================================================#
#Read PTF file(s)
#=======================================================#
read_ptf $ptf_file

#=======================================================#
#Read UPF file(s)
#=======================================================#
load_upf $power_files 



#=======================================================#
#Config the tolerance level for RTL parser for elobration
#=======================================================#

config_tolerance -blackbox true -connection_mismatch true \
        -missing_physical_library true \
        -continue_on_error false



#=======================================================#
#Read verilog design files
#=======================================================#

read_vhdl $rtl_list  

#=======================================================#
#Set design-specific parameters before synthesis
#=======================================================#

	#Set the max routing layer (defined in 0_adder_init_design.tcl)
	set_max_route_layer $max_route_layer  				

	#Reset dont_use property on all lib cells
	set_dont_use [get_lib_cell * ] false 				

	#Specify clock gating options
	set_clock_gating_options -control_point before \
		-minimum_bitwidth 4 -sequential_cell latch 	


	set_parameter ungroup_small_hierarchies 0			


echo "\n-----------------------------"
echo "\nDone preparing design for synthesis"
echo "\n-----------------------------\n"
