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
    vcom -2008 -work work ../../rtl/uart_rx.vhd
    vcom -2008 -work work ../../rtl/uart_tx.vhd

	vcom -2008 -work work ../testbench_uart.vhd

	vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  testbench_uart
	vsim -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs=\"+acc\" -t 1ps testbench_uart

	add wave *
    add wave -radix unsigned /TX/BC/w_value
    add wave -radix unsigned /TX/CC/w_value
    add wave /TX/w_byte
    add wave -radix unsigned /RX/BC/w_value
    add wave -radix unsigned /RX/CC/w_value
    add wave /RX/w_byte
	view structure
	view signals
	run 20 us
}
