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

	vcom -2008 -work work ../../generic_components/rtl/generic_functions.vhd
	vcom -2008 -work work ../../generic_components/rtl/generic_components.vhd

	vcom -2008 -work work ../../generic_components/rtl/banco_registradores.vhd
	vcom -2008 -work work ../../generic_components/rtl/integer_divider.vhd
	vcom -2008 -work work ../../generic_components/rtl/memd.vhd
	vcom -2008 -work work ../../generic_components/rtl/memi.vhd
	vcom -2008 -work work ../../generic_components/rtl/registrador.vhd
	vcom -2008 -work work ../../generic_components/rtl/somador.vhd
	vcom -2008 -work work ../../generic_components/rtl/multiplicador.vhd
	vcom -2008 -work work ../../generic_components/rtl/ula.vhd
	vcom -2008 -work work ../../gpio/rtl/gpio.vhd
	vcom -2008 -work work ../../single_cycle_controller/rtl/single_cycle_controller.vhd

	vcom -2008 -work work ../../extended_alu/rtl/extended_alu.vhd
	vcom -2008 -work work ../../interrupt_controller/rtl/interrupt_controller.vhd
	vcom -2008 -work work ../../up_counter/rtl/up_counter.vhd

	vcom -2008 -work work ../../rtl/peripheral_components.vhd
	
	vcom -2008 -work work ../../extended_alu/rtl/alu_components.vhd
	vcom -2008 -work work ../../word_2_byte/rtl/byte_2_word.vhd
	vcom -2008 -work work ../../timer/rtl/timer.vhd
	vcom -2008 -work work ../../uart/rtl/uart_rx.vhd
	vcom -2008 -work work ../../uart/rtl/uart_tx.vhd
	vcom -2008 -work work ../../word_2_byte/rtl/word_2_byte.vhd

	vcom -2008 -work work ../../single_cycle_datapath/rtl/single_cycle_datapath.vhd

    vcom -2008 -work work ../../rtl/single_cycle_components.vhd
	
	vcom -2008 -work work ../../rtl/single_cycle_processor.vhd

	vcom -2008 -work work ../sc_processor_testbench.vhd

	vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  sc_processor_testbench
	vsim -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs=\"+acc\" -t 1ps sc_processor_testbench

	add wave *
    add wave -radix decimal /SCP0/SCD/REGF/banco(2)
    add wave -radix decimal /SCP0/SCD/REGF/banco(4)
    add wave -radix decimal /SCP0/SCD/REGF/banco(8)
    add wave -radix decimal /SCP0/SCD/REGF/banco(9)
    add wave -radix decimal /SCP0/SCD/REGF/banco(10)
    add wave -radix decimal /SCP0/SCD/REGF/banco(11)
    add wave -radix decimal /SCP0/SCD/REGF/banco(16)
    add wave -radix decimal /SCP0/SCD/REGF/banco(29)
    add wave -radix decimal /SCP0/SCD/REGF/banco(30)
    add wave -radix decimal /SCP0/SCD/REGF/banco(31)
    add wave -radix decimal /SCP0/SCD/epc_output
    add wave -radix decimal /SCP0/SCD/current_instruction
    add wave -radix hexadecimal /SCP0/SCD/instruction_value
    add wave /SCP0/w_er_2_en
    add wave -radix decimal /SCP0/w_er_2_input
    add wave -radix decimal /SCP0/w_er_2_output
    add wave /SCP0/w_er_3_en
    add wave -radix decimal /SCP0/w_er_3_input
    add wave -radix decimal /SCP0/w_er_3_output
    add wave /SCP0/w_er_0_en
    add wave /SCP0/w_er_0_flag
    add wave -radix decimal /SCP0/w_er_0_input
    add wave -radix decimal /SCP0/SCD/er_0_output
    add wave -radix decimal /SCP0/TIM/CNTx/w_value
    add wave -radix decimal /SCP0/TIM/DIVx/w_value
    add wave /SCP0/w_er_1_en
    add wave /SCP0/w_er_1_flag
    add wave -radix decimal /SCP0/w_er_1_input
    add wave -radix decimal /SCP0/w_er_1_output
    add wave -radix unsigned /SCP0/W2B/UC/w_value
    add wave -radix unsigned /SCP0/TX/BC/w_value
    add wave -radix unsigned /SCP0/TX/CC/w_value
    add wave /SCP0/w_tx_byte
    add wave /SCP0/w_next_byte
    add wave /SCP0/w_valid_byte
    add wave -radix unsigned /SCP0/RX/BC/w_value
    add wave -radix unsigned /SCP0/RX/CC/w_value
    add wave -radix unsigned /SCP0/B2W/UC/w_value
    add wave /SCP0/w_rx_byte
    add wave /SCP0/w_load_byte
	view structure
	view signals
	run 50 us
}
