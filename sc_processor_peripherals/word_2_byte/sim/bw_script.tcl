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

	vcom -2008 -work work ../../../up_counter/rtl/up_counter.vhd
	
	vcom -2008 -work work ../../../rtl/peripheral_components.vhd
    vcom -2008 -work work ../../rtl/word_2_byte.vhd
    vcom -2008 -work work ../../rtl/byte_2_word.vhd

	vcom -2008 -work work ../testbench_bw.vhd

	vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  testbench_bw
	vsim -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs=\"+acc\" -t 1ps testbench_bw

	add wave *
    add wave -radix hexadecimal /W2B1/UC/w_value
    add wave -radix hexadecimal /B2W/UC/w_value
    add wave -radix hexadecimal /W2B2/UC/w_value
	view structure
	view signals
	run 5 us
}
