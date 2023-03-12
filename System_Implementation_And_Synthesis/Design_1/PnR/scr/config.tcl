##################
# Timer Settings #
##################

# aligned to pt variable rc_degrade_min_slew_when_rd_less_than_rnet
config_timing -rc_degrade_min_slew_when_rd_less_than_rnet false
config_timing -disable_recovery_removal false
config_timing -enable_exception_proxy true
config_timing -disable_time_borrow false
config_timing -disable_annotation_factor_calc true
config_timing -enable_clock_propagation_through_three_state_enable_pins false

config_timing -disable_internal_inout_cell_paths true
# aligned to pt variable timing_disable_cond_default_arcs false
config_timing -enable_cond_arcs_with_default true 
# enable conditional timing arcs which have default arcs (true)
config_timing -enable_default_for_cond_arcs true
config_timing -enable_setup_independent_hold_checks true
# consider the ideal clock latency for delay calc for a net which is both data and clock
config_timing -enable_ideal_clock_data_tags true
# aligned to pt variable timing_clock_gating_propagate_enable (true)
config_timing -enable_clock_gating_propagate true
# aligned to pt variable case_analysis_sequential_propagation (never)
config_timing -disable_seq_case_analysis true
# aligned to pt variable timing_early_launch_at_borrowing_latches
config_timing -early_launch_at_borrowing_latches false
# aligned to pt variable timing_enable_preset_clear_arcs (true)
config_timing -enable_preset_clear_arcs false
# aligned to pt variable timing_non_unate_clock_compatibility (false)
config_timing -enable_non_unate_clock_paths true
# force Nitro to use the max for late path (setup) and the min for early path (hold)
config_timing -pt_min_max_compatibility on_chip_variation
# aligned to pt variable timing_non_unate_clock_compatibility (false) 
config_timing -enable_non_unate_clock_paths true
# aligned to pt variable timing_gclock_source_network_num_master_registers (10000000)
config_timing -disable_sequential_generation_of_waveform_preserving_clocks false
config_timing -capacitance_violation_threshold 0
# Aligned to config_cts -enable_port_clock_leaves Nitro setting
config_timing -disable_clock_gating_checks false
# remove default input delay on unconstrained ports
config_timing -enable_default_input_delay false

#######################
# Extraction Settings #
#######################
config_extraction -gr_short_route_gcell_span 3
config_extraction -search_distance_multiple 15
config_extraction -use_thickness_variation false
config_extraction -use_thickness_variation_for_cap false
config_extraction -use_thickness_variation_for_res true
# aligned to StarRCXT variable COUPLING_ABS_THRESHOLD
config_extraction -coupling_abs_threshold 0.1f
# aligned to StarRCXT variable COUPLING_REL_THRESHOLD
config_extraction -coupling_rel_threshold 1.0
ta_debug -cc_ratio 0
