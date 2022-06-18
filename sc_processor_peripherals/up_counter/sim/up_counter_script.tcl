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
	
	vcom -2008 -work work ../../../generic_components/rtl/registrador.vhd

	vcom -2008 -work work ../../rtl/up_counter.vhd

	vcom -2008 -work work ../testbench_up_counter.vhd

	vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  testbench_up_counter
	vsim -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs=\"+acc\" -t 1ps testbench_up_counter

	add wave *
	view structure
	view signals
	run 5 us
}
