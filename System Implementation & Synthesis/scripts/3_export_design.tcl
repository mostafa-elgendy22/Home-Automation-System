
#########################################################
#                  3_export_design.tcl
#
# Description:  Export the design data
#
# Usage:        source in Oasys-RTL Command prompt
#
# Dependencies: 0_init_design.tcl
#               1_load_design.tcl
#               2_synthesize_optimize.tcl
#               Launched from Oasys-RTL shell after
#               synthesis and optimization
#
#########################################################

#Check if dependent scripts have been loaded
if {![info exists top_module]} {
    source scripts/0_init_design.tcl
    source scripts/1_read_design.tcl
    source scripts/2_synthesize_optimize.tcl
}

report_units
report_timing           > ${rpt_dir}/time.rpt
report_path_groups      > ${rpt_dir}/path.rpt
report_endpoints        > ${rpt_dir}/endpoints.rpt
report_power            > ${rpt_dir}/power.rpt
report_design_metrics   > ${rpt_dir}/design.rpt

#Write odb
write_design ${odb_dir}/demo_adder.odb

#write MXDB

write_mxdb ${mxdb_dir}/demo_adder.mxdb

#Write verilog
write_verilog ${output_dir}/verilog/demo_adder.syn.v

#Write SDC
write_sdc ${output_dir}/constraints/demo_adder.oasys.sdc

#save_upf
save_upf ${output_dir}/constraints/demo_adder.oasys.upf

#Write Floorplan (DEF)
write_def -floorplan ${output_dir}/floorplan/demo_adder.def


echo "\n-----------------------------"
echo "\nDesign data exported to output dir."
echo "\n-----------------------------\n"
