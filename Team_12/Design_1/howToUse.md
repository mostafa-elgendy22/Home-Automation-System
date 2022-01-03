1. Open a terminal and open the liscence server using: `lmgrd`
2. Open a new terminal and type `oasys`
3. Type `delete_design` `reset_upf`
4. Type `./cleanup.sh`
5. Type `source scripts/run.tcl`
6. File structure should be like this one.
    - constraints.
    - lib_data.
    - outputs.
    - rtl.
    - scripts.
7. Add HDL code to rtl directory.
8. Edit their refernces in scripts(0_module_init_design.tcl, lines: 6, 36)
9. Type `lmdown` to close the liscence server.




---------------------------------------------------------------------------------
To Try floor planning & routing

1. Open variables folder and edit TCL scripts as needed  (See Lab slides to understand)
2. Run clean_nitro.sh
3. run `lmgrd` to activate the license
4. cd work
5. run `nitro -log LOGs/nitro.log -journal LOGs/nitro.journal`
6. run `setup_nrf`
7. run `source flow_scripts/import_variables.tcl > LOGs/import.log`
8. run `source flow_scripts/0_import.tcl > LOGs/import0.log`
9. Then make sure there are no errors
10. start
11. nitro GUI opens and start playing !
12. run the commands from the `nitro_script` file inside the nitro-SoC command line 
