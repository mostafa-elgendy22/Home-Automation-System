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
#  Supply network creation script                    #
#                                                    #
#  Called by floorplan.tcl to create the supply      #
#  network for a design.                             #
#                                                    #
######################################################

######################
# Create power grid  #
######################

# Create the power rails (followpins)

if {[info exists tanner_floorplan_mode]} {
  create_pg_rails -partitions [get_top_partition] \
  		-window false \
                -expand "$fp_rows_xl_margin $fp_rows_yb_margin $fp_rows_xr_margin $fp_rows_yt_margin" \
  		-ignore_blockages { none } 
} else {
  create_pg_rails -partitions [get_top_partition] \
                  -window false \
                  -ignore_blockages { none }
}

# Create the power rings

if {$pg_ring_layers != ""} {
    set ring_drc [list none]
    if {$pg_ring_drc_check} {
	set ring_drc [list all]
    }
    set offsets "$pg_ring_offset_left $pg_ring_offset_bottom $pg_ring_offset_right $pg_ring_offset_top"
    create_pg_rings -partitions [get_top_partition] \
		    -nets $pg_ring_net_order \
		    -widths $pg_ring_widths \
		    -step $pg_ring_step \
		    -spacing $pg_ring_spacing \
		    -offset $offsets \
		    -layers $pg_ring_layers \
		    -corner_style $pg_ring_corner_style \
		    -check_drc $ring_drc
}

# Create the power stripes

if {$pg_stripe_vlayers != "" || $pg_stripe_hlayers != ""} {
    set stripe_drc [list none]
    if {$pg_stripe_drc_check} {
        set stripe_drc [list all]
    }

    if {$pg_stripe_hlayers != ""} {
        set hoffsets "$pg_stripe_offset_bottom $pg_stripe_offset_top"
        set hmargins "$pg_stripe_start_hmargin $pg_stripe_stop_hmargin"
        create_pg_stripes   -partitions [get_top_partition] \
			    -nets $pg_stripe_net_order \
			    -window false \
			    -direction horizontal \
			    -layer $pg_stripe_hlayers \
			    -widths $pg_stripe_widths \
			    -spacing $pg_stripe_spacing \
			    -step $pg_stripe_step \
			    -margin $hmargins \
			    -offset $hoffsets \
			    -ignore_blockages {placement} \
			    -check_drc $stripe_drc
    }

    if {$pg_stripe_vlayers != ""} {
        set voffsets "$pg_stripe_offset_left $pg_stripe_offset_right"
        set vmargins "$pg_stripe_start_vmargin $pg_stripe_stop_vmargin"
        create_pg_stripes   -partitions [get_top_partition] \
			    -nets $pg_stripe_net_order \
			    -window false \
			    -direction vertical \
			    -layer $pg_stripe_vlayers \
			    -widths $pg_stripe_widths \
			    -spacing $pg_stripe_spacing \
			    -step $pg_stripe_step \
			    -margin $vmargins \
			    -offset $voffsets \
			    -ignore_blockages {placement} \
			    -check_drc $stripe_drc
    }
}

# Insert PG vias 

insert_pg_vias -partitions [get_top_partition]

# Trim PG rails & stripes

if { $pg_trim } {
    trim_pg_route
}
