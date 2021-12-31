##
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
#  Floorplan variables template                      #
#                                                    #
#  Variables needed for floorplan.tcl                #
#  Modify values to correspond to your design        #
#                                                    #
######################################################
#
# Setup parameters
#

set fp_units            micro
set fp_top_partition    ""         ; # INPUT REQUIRED: Top partition name

#
# By default, the chip size will be determined by utilization.
# Set fp_use_utilization to false if providing chip width & height is preferred.
#

set fp_use_utilization	true

# If true, provide util and aspect ratio

set fp_aspect_ratio	    1.0
set fp_utilization	    50.0

# If false, provide chip size

set fp_chip_origin_x	    0
set fp_chip_origin_y	    0
set fp_chip_width	    400
set fp_chip_height	    460

# Provide core site name to be used for core rows

set fp_core_site	"" ; # INPUT REQUIRED: Name a lib site to be used for core rows

# Info for core rows

set fp_rows_xl_margin       40    ; # Distance from left boundary to start rows
set fp_rows_yb_margin       40    ; # Distance from bottom boundary to start rows
set fp_rows_xr_margin       40    ; # Distance from right boundary to stop rows
set fp_rows_yt_margin       40    ; # Distance from top boundary to stop rows
set fp_row_gap              0     ; # Gap between rows
set fp_double_backed_row    true  ; # true: row will flip north-south; false: all rows will be north
set fp_core_orient          north ; # Orientation of bottom row

# Track info

set fp_tracks_offset	    ""    ; # Distance from left (horizontal track) & bottom (vertical track) for tracks

# If the design has macros, provide DEF file with placement info
# or use automatic macro placer to place

set fp_macro_def		""	       ; # DEF file with macro placement info
set fp_do_macro_conn_analysis	false

# If a pin constraint file exists, provide it
set fp_pin_constraint_file	""

# Power Planning Variables
set fp_do_power_planning	true

# Auto PG synthesis 
# Power network can be synthesized automatically based on user specification of peak power and/or peak current density plus maximum allowed voltage drop
# Automatic synthesis is triggered by positive value for pg_peak_power or pg_peak_current_density
# Peak current density, pg_peak_current_density, is observed under peak power consumption and is measured in mA/sq-micron
# Value of peak power, pg_peak_power, is expected in power units
# Target voltage drop, pg_target_voltage_drop, correspondds to safe variation in supply voltage
# By default, target volatage drop is 1 % of supply voltage 
# If specified the value is expected to be in voltage units
# Synthesized power structure may use vertical and horizontal stripes, only vertical stripes, or no stripes at all  
# Preferable stripe layers can be set through pg_stripe_vlayers and pg_stripe_hlayers
set pg_peak_power               0
set pg_peak_current_density     0
set pg_target_voltage_drop      0
                                                  
# PG ring settings
set pg_ring_layers              {}          ; # Metal layers for the rings in order {Hlayer Vlayer}
set pg_ring_net_order           {}          ; # Order to create rings, e.g. {VDD GND}
set pg_ring_drc_check           true        ; # Perform DRC checking while creating rings?
set pg_ring_corner_style        concentric	; # Corner style (concentric | grid)
set pg_ring_widths              {10 10}     ; # Width of the supply rings
set pg_ring_spacing             5           ; # Spacing between supply rings
set pg_ring_step                5           ; # Spacing between ring patterns
set pg_ring_offset_left	        10	        ; # Spacing from left chip edge to ring
set pg_ring_offset_right        10	        ; # Spacing from right chip edge to ring
set pg_ring_offset_top	        10	        ; # Spacing from top of chip to ring
set pg_ring_offset_bottom       10          ; # Spacing from bottom of chip to ring

set pg_stripe_vlayers	        {}	    ; # Layers for vertical stripes, e.g. {METAL5}
set pg_stripe_hlayers	        {}	    ; # Layers for horizontal stripes, e.g. {METAL6}
set pg_stripe_drc_check	        true	; # Perform DRC checking while creating stripes?
set pg_stripe_net_order	        {}      ; # Order of supply nets for stripes, e.g. {VDD GND}
set pg_stripe_widths	        {5 5}	; # Width of stripes
set pg_stripe_spacing	        2       ; # Spacing between stripes
set pg_stripe_step              90      ; # Step spacing for repeating patterns
set pg_stripe_offset_left       20		; # Offset from left side of chip to start vertical stripe patterns
set pg_stripe_offset_right      20		; # Offset from right side of chip to stop vertical stripe patterns
set pg_stripe_offset_top        20		; # Offset from top of chip to stop horizontal stripe patterns
set pg_stripe_offset_bottom     20		; # Offset from bottom of chip to start horizontal stripe patterns
set pg_stripe_start_vmargin     1		; # Offset from bottom of chip to beginning of vertical stripes
set pg_stripe_stop_vmargin      1		; # Offset from top of chip to end vertical stripes
set pg_stripe_start_hmargin     1		; # Offset from left side of chip to start horizontal stripes
set pg_stripe_stop_hmargin      1		; # Offset from right side of chip to stop horizontal stripes

# Trim PG nets?
set pg_trim	true	; # If trimming of PG tails is not desired, set to false

# Add ENDCAPS
set fp_endcap_prefix                   ""   	 ; # Specify instance naming prefix; must be set to initiate endcap insertion
set fp_left_endcap_cell                ""	 ; # Specify left end cap endcap lib_cell
set fp_right_endcap_cell               ""	 ; # Specify right end cap endcap lib_cell
set fp_horiz_lib_cell                  ""	 ; # Specify top/bottom row endcap lib_cell
set fp_top_left_corner_endcap_cell     ""	 ; # Specify top left corner endcap lib_cell
set fp_top_right_corner_endcap_cell    ""	 ; # Specify top right corner endcap lib_cell
set fp_bottom_left_corner_endcap_cell  ""	 ; # Specify bottom left corner endcap lib_cell
set fp_bottom_right_corner_endcap_cell ""	 ; # Specify bottom right corner endcap lib_cell
set fp_ignore_placement_blockage       true      ; # if false, endcaps will NOT be placed in areas with hard placement blockages

# add WELLTAPS
set fp_well_tap_prefix            ""                 ; # Specify the instance naming prefix; must be set to initiate welltap insertion
set fp_well_tap_cell              ""                 ; # Specify the lib_cell used for well taps, e.g. WELL_TAP_LIB_CELL
set fp_well_tap_h_spread          20u                ; # Specify the horizontal spread between columns of well taps
set fp_well_tap_v_spread          2u                 ; # Specify the vertical spread between columns of well taps
set fp_well_tap_h_offset          2u                 ; # Distance of first welltap column from left side of the partition.
set fp_well_tap_v_offset          2u                 ; # Distance of welltap columns from bottom of the partition.
set fp_well_tap_staggering        odd                ; # The odd/even-numbered columns will be shifted up by half of the v_distance 'none, odd, even'
set fp_well_tap_avoid_blockage    hard_placement     ; # Blockages to avoid when placing well ties 'soft_placement, hard_placement, routing'

# Save the DB
set fp_save_db                    true

