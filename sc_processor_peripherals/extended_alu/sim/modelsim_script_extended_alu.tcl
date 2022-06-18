#quit -sim
	
cd ..

if {[file isdirectory sim]} {

    cd sim
		
	if {![file isdirectory modelsim_output_files]} {
		file mkdir modelsim_output_files
	}
	
	cd modelsim_output_files

	if {[file exists work]} {
		vdel -lib rtl_work -all
	}
	
	vlib rtl_work
	vmap work rtl_work

	vcom -2008 -work work ../../../generic_components/rtl/generic_functions.vhd
	vcom -2008 -work work ../../../generic_components/rtl/generic_components.vhd
	
	vcom -2008 -work work ../../../generic_components/rtl/ula.vhd
	vcom -2008 -work work ../../../generic_components/rtl/multiplicador.vhd
	vcom -2008 -work work ../../../generic_components/rtl/integer_divider.vhd

	vcom -2008 -work work ../../rtl/extended_alu.vhd

	vcom -2008 -work work ../testbench_extended_alu.vhd

	vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  testbench_extended_alu
	vsim -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs=\"+acc\" -t 1ps testbench_extended_alu

	add wave *
    add wave /testbench_extended_alu/EALU/DIV0/w_fix
    add wave /testbench_extended_alu/EALU/DIV0/input_a
    add wave /testbench_extended_alu/EALU/DIV0/input_b
    add wave /testbench_extended_alu/EALU/DIV0/w_quot_shft
    add wave /testbench_extended_alu/EALU/DIV0/w_quot
    add wave /testbench_extended_alu/EALU/DIV0/w_rmdr
    add wave /testbench_extended_alu/EALU/DIV0/w_quot_fix
    add wave /testbench_extended_alu/EALU/DIV0/w_rmdr_fix
	view structure
	view signals
	run 5 us
}
