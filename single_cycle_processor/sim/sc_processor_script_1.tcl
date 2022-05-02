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
	vcom -2008 -work work ../../single_cycle_controller/rtl/single_cycle_controller.vhd

	vcom -2008 -work work ../../extended_alu/rtl/extended_alu.vhd

	vcom -2008 -work work ../../extended_alu/rtl/alu_components.vhd
	
	vcom -2008 -work work ../../single_cycle_datapath/rtl/single_cycle_datapath.vhd

    vcom -2008 -work work ../../rtl/single_cycle_components.vhd
	
	vcom -2008 -work work ../../rtl/single_cycle_processor.vhd

	vcom -2008 -work work ../sc_processor_testbench.vhd

	vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  sc_processor_testbench
	vsim -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs=\"+acc\" -t 1ps sc_processor_testbench

	add wave *
    add wave /SCP/SCD/REGF/banco(8)
    add wave /SCP/SCD/REGF/banco(9)
    add wave /SCP/SCD/REGF/banco(16)
    add wave /SCP/SCD/REGF/banco(29)
    add wave /SCP/SCD/DMEM/ram(575)
    add wave /SCP/SCD/current_instruction
    add wave /SCP/SCD/instruction_value
	view structure
	view signals
	run 5 us
}
