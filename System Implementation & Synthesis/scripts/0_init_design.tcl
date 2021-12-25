# Enable capture of commands
 config_shell -echo true

###################Top Module Specification###########
set top_module "home_automation_system"
set max_route_layer "5"

#Set design file path variables
set ekit_dir            "$env(PWD)"
set demo_adder_rtl_dir  "${ekit_dir}/rtl"
set demo_adder_sdc_files "${ekit_dir}/constraints/demo_adder_func.sdc"

#Set Oasys-RTL script and output path variables
set script_dir "${ekit_dir}/scripts"
set output_dir "${ekit_dir}/output"
set db_dir "${output_dir}/db"
set odb_dir "${output_dir}/odb"
set log_dir "${output_dir}/logs"
set rpt_dir "${output_dir}/rpt"
set mxdb_dir "${output_dir}/mxdb"

#Set Technology path variables
set library_path "${ekit_dir}/lib_data"

##set a consistant reporting format for timing
config_report timing -format "cell edge arrival delay arc_delay net_delay slew net_load load fanout location power_domain"

#Source the script that sets the path variables for all input files
#source ${script_dir}/demo_adder_design_files.tcl


#################################################### RTL and Libraries ###########################################

set search_path "${demo_adder_rtl_dir}/"

set rtl_list "${demo_adder_rtl_dir}/home_automation_system.vhd, ${demo_adder_rtl_dir}/counter.vhd, ${demo_adder_rtl_dir}/decoder.vhd, ${demo_adder_rtl_dir}/register.vhd, ${demo_adder_rtl_dir}/priority_encoder.vhd"

#set macro_libs
set std_vlt_lib "$library_path/NangateOpenCellLibrary_typical.lib"
set tech_file   "$library_path/NangateOpenCellLibrary.tech.lef"
set lef_files   "$library_path/NangateOpenCellLibrary.macro.lef"
set ptf_file    "$library_path/NCSU_FreePDK_45nm.ptf"
set power_files "${ekit_dir}/constraints/demo_adder.85.upf"
check_library


echo "\n-----------------------------"
echo "\nDone setting design variables"
echo "\n-----------------------------\n"
