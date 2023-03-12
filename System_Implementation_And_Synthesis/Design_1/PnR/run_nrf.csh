#!/bin/csh

set nitro_ver = "/home/vlsi/Installation/Nitro/nitroPack-2019.1.R2a/nitro/bin/nitro" 
set flow_ver = "/home/vlsi/Desktop/VLSI-Project/System_Implementation_And_Synthesis/Design_1/work/flow_scripts"

######################################
## To append to existing log & jou  ##
## files, set to true               ##
######################################
set append_log = false

###################################### 
## Set the stages to be run to true ##
## To skip a stage, set it to false ##
###################################### 
set import = true
set place  = true
set clock  = true
set route  = true
set export = true

###################################### 
##  Remainder of script should not  ##
##  require modification            ##
###################################### 

set prev_stage = null
set stage_num = 0

foreach stage (import place clock route export)
    set run_stage = `eval echo \$$stage`
    set stage_name = ${stage_num}_${stage}
    if ( $run_stage == true ) then
        if ( $stage != import && $prev_stage != null ) then
            if (! -d dbs/${prev_stage}.db ) then
                echo "\nNRF_RUN error: Could not find ${prev_stage}.db.  Cannot run $stage stage.\n"
                exit
            endif
        endif
        if ( -d dbs/${stage}.db ) then
            set dstamp = `eval date -r dbs/${stage}.db +%m_%d_%Y.%H_%M_%S`
            echo "NRF_RUN info: Found existing dbs/${stage}.db.  Moving to dbs/${stage}_${dstamp}.db."
            /bin/mv dbs/${stage}.db dbs/${stage}.${dstamp}.db
        endif

        if ( $append_log == false ) then
            if ( -f ./LOGs/${stage_name}_nitro.log ) then
                set dstamp = `eval date -r ./LOGs/${stage_name}_nitro.log +%m_%d_%Y.%H_%M_%S`
                /bin/mv ./LOGs/${stage_name}_nitro.log ./LOGs/${stage_name}.${dstamp}.log
            endif
            if ( -f ./JOUs/${stage_name}.jou ) then
                set dstamp = `eval date -r ./JOUs/${stage_name}.jou +%m_%d_%Y.%H_%M_%S`
                /bin/mv ./JOUs/${stage_name}.jou ./JOUs/${stage_name}.${dstamp}.jou
            endif
        endif

        $nitro_ver -source $flow_ver/${stage_name}.tcl -log ./LOGs/${stage_name}_nitro.log -journal ./JOUs/${stage_name}.jou -app_log $append_log -app_jou $append_log
    endif

    set prev_stage = $stage
    @ stage_num++
end

exit

