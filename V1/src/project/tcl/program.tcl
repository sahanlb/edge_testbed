open_hw
connect_hw_server
open_hw_target

set_property PROBES.FILE {} [lindex [get_hw_devices xc7a100t_0] 0]
set_property PROGRAM.FILE {rv_img_proc_demo.runs/impl_1/top.bit} [lindex [get_hw_devices xc7a100t_0] 0]
program_hw_devices [lindex [get_hw_devices xc7a100t_0] 0]
