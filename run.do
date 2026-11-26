vlog list.svh +incdir+D:/QuestaSim/QuestaSim_install/verilog_src/uvm-1.2/src


vsim -novopt -suppress 12110 top \
-sv_lib D:/QuestaSim/QuestaSim_install/uvm-1.2/win64/uvm_dpi \
+UVM_TESTNAME=axi_nwr_nrd_test


add wave -r sim:/top/pif/*

run -all
