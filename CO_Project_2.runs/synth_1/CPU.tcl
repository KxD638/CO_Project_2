# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache C:/Users/dengkaixuan/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-11296-DB3F/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.cache/wt [current_project]
set_property parent.project_path C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/RAM/dmem32.coe
add_files C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/prgrom/prgrom32.coe
read_verilog C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/para.vh
read_verilog -library xil_defaultlib {
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/ALU.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/Controller.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/Debounce.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/Decoder.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/IFetch.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/ImmGen.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/LED.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/MemOrIO.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/interrupt_clk_convertor.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/light_7seg.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/scan_seg.v
  C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/new/CPU.v
}
read_ip -quiet C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/RAM/RAM.xci
set_property used_in_implementation false [get_files -all c:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/RAM/RAM_ooc.xdc]

read_ip -quiet C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/prgrom/prgrom.xci
set_property used_in_implementation false [get_files -all c:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/prgrom/prgrom_ooc.xdc]

read_ip -quiet C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/cpuclk/cpuclk.xci
set_property used_in_implementation false [get_files -all c:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/cpuclk/cpuclk.xdc]
set_property used_in_implementation false [get_files -all c:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/constrs_1/new/Cpu.xdc
set_property used_in_implementation false [get_files C:/Users/dengkaixuan/vivado_project/CO_Project_2/CO_Project_2.srcs/constrs_1/new/Cpu.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top CPU -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CPU.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file CPU_utilization_synth.rpt -pb CPU_utilization_synth.pb"