
# source insert_ila.tcl
set part xc7s50csga324-1

file delete -force ${core}
file mkdir ${core}

#set_property verilog_dir { "" "." } [current_fileset]
#set_property verilog_define XXX=1   [current_fileset]
#set_property is_global_include true [get_files ""]

${srcfiles}
read_xdc "./common.xdc"
synth_design -top ${top} -part ${part} -fanout_limit 75 > ${core}/synth_design.log
#read_xdc "./debug_nets.xdc"

write_checkpoint -force "${core}/post_synth.dcp"
#exit

#batch_insert_ila 2048

opt_design -verbose > ${core}/opt_design.rpt
write_checkpoint -force "${core}/post_opt.dcp"

place_design    > ${core}/place_design.log
phys_opt_design > ${core}/phys_opt_design.log
route_design    > ${core}/route_design.log
write_checkpoint -force "${core}/post_route.dcp"

set_property BITSTREAM.GENERAL.COMPRESS true         [current_design]
#set_property BITSTREAM.GENERAL.UnconstrainedPins     {Allow}  [current_design]
write_bitstream -force "${core}/${core}.bit" > ${core}/write_bitstream.log

report_clock_utilization         -file "${core}/clock_utilization.rpt"
report_utilization -hierarchical -file "${core}/utilization.rpt"
report_timing_summary            -file "${core}/timing_summary.rpt"
report_timing -sort_by group -nworst 50 -path_type full -file "${core}/timing.rpt"
report_io                        -file "${core}/io.rpt"

exit