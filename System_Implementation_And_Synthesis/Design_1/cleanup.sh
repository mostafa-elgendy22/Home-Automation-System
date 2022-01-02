#~/bin/sh

rm --f output/odb/*
rm --f output/mxdb/*

rm --f output/db/*

rm --f output/logs/*.log
rm --f output/logs/*.cmd
rm --f output/logs/*.dbg
rm --f output/rpt/*.rpt

rm --f output/verilog/*
rm --f output/constraints/*
rm --f output/floorplan/*
rm --f output/dft/*

rm --f oasys.cmd*
rm --f oasys.dbg*
rm --f oasys.log*

echo "\n-------------------------------------"
echo "\nCleanup Complete"
echo "\n-------------------------------------\n"
