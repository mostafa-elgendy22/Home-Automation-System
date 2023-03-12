# Template to insert decap around clock buffers and clock inverters.
# MGC_clk_decap, MGC_ck_inv_cell_list, MGC_ck_buf_cell_list are defined in flow_variables.tcl

# This script supports one type of decap - not multiple types
# source insert_clock_decap.tcl

proc insert_clk_decap {decap} {
  variable ::MGC_clk_decap 

  # User control to insert decap on top/bottom as well as left/right
  set topAndBottom true

  set index 0
  set clk_decap [get_lib_cells $::MGC_clk_decap]

  # This proc finds all non-leaf clock cells 
  RCTU::Cts::NonLeafClockCells mycts_cells

  if { [llength $clk_decap] > 1 } {
      fk_msg -type error "More than one decap cell in the variable \$::MGC_clk_decap.  Current script does not support multiple decap."
      return
      } elseif { [llength $clk_decap] == 0} {
      fk_msg -type error "The variable \$::MGC_clk_decap is not defined.  A decap lib_cell must be defined."
      return
      }

    set cpt 0
    foreach_in_collection clock_cell $mycts_cells {

      # Check for CTS Halo definition for go/no_go
	set current_lib_cell [get_lib_cells -of $clock_cell]
	set search_index [lsearch -regexp $::MGC_clk_halo $current_lib_cell]
	if {$search_index < 0} {
		fk_msg -type info "libcell ($current_lib_cell) for $clock_cell not defined in NRF MGC_clk_halo variable... Skipping decap cell insertion."
		continue
	}

      # Object group
      incr cpt
      set group_members [get_cells $clock_cell]

      #incr index
      set cell_name   [get_property -object [get_cell $clock_cell]    -name name]
      set cell_height [get_property -object [get_cell $clock_cell]    -name height]
      set cell_width  [get_property -object [get_cell $clock_cell]    -name width]
      set cell_x      [get_property -object [get_cell $clock_cell]    -name xorigin]
      set cell_y      [get_property -object [get_cell $clock_cell]    -name yorigin]
      set x_offset    [get_property -object [get_lib_cell $clk_decap] -name width]
      set x_offset    [lindex $x_offset 0]
      set cell_orient [get_property -object [get_cell $clock_cell]    -name orientation]


      set x0 $cell_x
      set y0 $cell_y 
      set x1 [expr $x0 + $cell_width]
      set y1 [expr $y0 + $cell_height]
      set xl [expr $x0 - $x_offset]
      set xr [expr $x1 + $x_offset]
      # Optional for top/bottom decap insertion
      set y2 [expr $y1 + $cell_height]
      set y3 [expr $y0 - $cell_height]
      
	# PR UPDATED for cut rows
	#########################
	# Identify row the cell and related boundaries
	set yorigin_rows [sort_collection -descending false -objects [get_objects -type row -filter @yorigin==$y0] -property_names xorigin]
	foreach row_elt $yorigin_rows {
		set row_left_edge [get_property -name xorigin $row_elt]
		set row_length [get_property -name length $row_elt]
		set row_right_edge [expr $row_left_edge + $row_length]
		set row_height [get_property -name height -obj [get_object site -of $row_elt]]

		if {$cell_height != $row_height} {continue}
		if {$x0 < $row_left_edge} {
			continue
		} else {
			if {$x0 > $row_right_edge} {
				continue
			} else {
				break
			}
		}

	}

      # corner cases.  Are there sites left/right and (optional) rows top/bottom
       if { $xl < $row_left_edge} {
           set left_sites false
         } else {
           set left_sites true
           }
       if { $xr > $row_right_edge} {
           set right_sites false
         } else {
           set right_sites true
           }

	# PR UPDATED for halo definition and multiple row for the the yorigin
       if { $topAndBottom == "true" && [lindex [lindex $::MGC_clk_halo $search_index] 2] > 0} {
	  if {[llength [get_objects -quiet -type row -filter @yorigin==$y2]] >= 1} {
               set top_orient    [get_property -name orientation [lindex [get_objects -type row -filter @yorigin==$y2] 0]] 
               set top_insert true
             } else {
               set top_insert false
               }
	  if {[llength [get_objects -quiet -type row -filter @yorigin==$y3]] >= 1} {
               set bottom_orient [get_property -name orientation [lindex [get_objects -type row -filter @yorigin==$y3] 0]]
               set bottom_insert true
             } else {
               set bottom_insert false
               }
	}
       
	  # left and right
	  if { ([get_area_objects -type cell -xl_area $xl -yb_area $y0 -xr_area $x0 -yt_area $y1 -overlap -quiet] == "") && ($left_sites == true) } {
	    set new_cell [create_cell -name ${cell_name}_clk_decapl_$index -lib_cell $clk_decap -force]
	    set group_members [add_to_collection $group_members -add $new_cell]
	    set_property -objects [get_cell ${cell_name}_clk_decapl_$index] -name xorigin -value [expr $cell_x - $x_offset] 
	    set_property -objects [get_cell ${cell_name}_clk_decapl_$index] -name yorigin -value $cell_y
	    set_property -objects [get_cell ${cell_name}_clk_decapl_$index] -name placed -value fixed 
	    set_property -objects [get_cell ${cell_name}_clk_decapl_$index] -name orientation -value $cell_orient
	    set_property -objects [get_cell ${cell_name}_clk_decapl_$index] -name is_dont_modify -value true 
            incr index
	  } 
	  if { ([get_area_objects -type cell -xl_area $x1 -yb_area $y0 -xr_area $xr -yt_area $y1 -overlap -quiet] == "") && ($right_sites == true) } {
	    set new_cell [create_cell -name ${cell_name}_clk_decapr_$index -lib_cell $clk_decap -force]
	    set group_members [add_to_collection $group_members -add $new_cell]
	    set_property -objects [get_cell ${cell_name}_clk_decapr_$index] -name xorigin -value [expr $cell_x + $cell_width]
	    set_property -objects [get_cell ${cell_name}_clk_decapr_$index] -name yorigin -value $cell_y
	    set_property -objects [get_cell ${cell_name}_clk_decapr_$index] -name placed -value fixed
	    set_property -objects [get_cell ${cell_name}_clk_decapr_$index] -name orientation -value $cell_orient
	    set_property -objects [get_cell ${cell_name}_clk_decapr_$index] -name is_dont_modify -value true
            incr index
	  }
	# PR UPDATED for halo definition
	  if { $topAndBottom == "true" && [lindex [lindex $::MGC_clk_halo $search_index] 2] > 0} {
	          # top and bottom
	          set x_check $x0
		  if { ([get_area_objects -type cell -xl_area $x_check -yb_area $y1 -xr_area $x1 -yt_area $y2 -overlap -quiet] == "") && ($top_insert == true) } {
                    set max_decap [expr int([expr ceil([expr {double($cell_width)/$x_offset}])])]
	            for {set capCount 0} {$capCount<$max_decap} {incr capCount} {
			set new_cell [create_cell -name ${cell_name}_clk_decapt_$index -lib_cell $clk_decap -force]
	    		set group_members [add_to_collection $group_members -add $new_cell]
			set_property -objects [get_cell ${cell_name}_clk_decapt_$index] -name xorigin -value $x0
			set_property -objects [get_cell ${cell_name}_clk_decapt_$index] -name yorigin -value $y1
			set_property -objects [get_cell ${cell_name}_clk_decapt_$index] -name placed -value fixed
			set_property -objects [get_cell ${cell_name}_clk_decapt_$index] -name orientation -value $top_orient
			set_property -objects [get_cell ${cell_name}_clk_decapt_$index] -name is_dont_modify -value true
        		incr index
	                set x0 [expr $x0+$x_offset]
		   }
		 }
        	   if { ([get_area_objects -type cell -xl_area $x_check -yb_area $y3 -xr_area $x1 -yt_area $y0 -overlap -quiet] == "") && ($bottom_insert == true) } {
		    set x0 $x_check
                    set max_decap [expr int([expr ceil([expr {double($cell_width)/$x_offset}])])]
	            for {set capCount 0} {$capCount<$max_decap} {incr capCount} {
		        set new_cell [create_cell -name ${cell_name}_clk_decapb_$index -lib_cell $clk_decap -force]
	    		set group_members [add_to_collection $group_members -add $new_cell]
		        set_property -objects [get_cell ${cell_name}_clk_decapb_$index] -name xorigin -value $x0
		        set_property -objects [get_cell ${cell_name}_clk_decapb_$index] -name yorigin -value $y3
		        set_property -objects [get_cell ${cell_name}_clk_decapb_$index] -name placed -value fixed
		        set_property -objects [get_cell ${cell_name}_clk_decapb_$index] -name orientation -value $bottom_orient
		        set_property -objects [get_cell ${cell_name}_clk_decapb_$index] -name is_dont_modify -value true
        	        incr index
	                set x0 [expr $x0+$x_offset]
		    }
		 }
	      }

	 set group_size [sizeof_col $group_members]
	 if {$group_size > 1} {
    	 	fk_msg -type info "New object group create (cts_decap_group_$cpt) for cell $clock_cell with [sizeof_col $group_members] elements"
         	create_object_group -name cts_decap_group_$cpt -cells $group_members
	 }

	 }

    
    fk_msg -type info "Inserted [llength [get_cells -quiet *_clk_decap*]] decap cells of type $::MGC_clk_decap"

    fk_msg -type info "Running Legalization to resolve abutment violations resulting from decap cell insertion"
    # Collect violating cells
    check_placement
    place_detail
    check_placement


    if {0} {
    # Pass 1 :  edge_spacing_rules_violation for movable cells
    # Open clock network
    set_clock_network -allow_registers move -allow_tree_elements move
    set_property -objects [get_cells *_clk_decap*] -name placed -value placed
    # Legalize
    config_place_detail -name allow_filler_cells_to_move -value true
    place_detail 
    config_place_detail -name allow_filler_cells_to_move -value false
    # Freeze clock network
    set_clock_network -allow_registers fix -allow_tree_elements fix
    set_property -objects [get_cells *_clk_decap*] -name placed -value fixed

    # Verification
    check_placement
    }

}

proc remove_clk_decap {} {
  set_property -objects [get_cells *_clk_decap*] -name placed -value placed
  set_property -objects [get_cells *_clk_decap*] -name is_dont_modify -value false
  remove_objects -objects [get_cells *_clk_decap*] -force
}
