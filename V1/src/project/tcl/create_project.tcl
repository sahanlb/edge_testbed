create_project -force rv_img_proc_demo . -part xc7a100tcsg324-1
add_files -scan_for_includes ../hdl/
update_compile_order -fileset sources_1

add_files -fileset constrs_1 ../contraints/Nexys-A7-100T.xdc

