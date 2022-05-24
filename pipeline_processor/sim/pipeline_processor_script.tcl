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
	vcom -2008 -work work ../../pipeline_controller/rtl/pipeline_controller.vhd
	vcom -2008 -work work ../../updated_controller/rtl/updated_controller.vhd

	vcom -2008 -work work ../../extended_alu/rtl/extended_alu.vhd

	vcom -2008 -work work ../../extended_alu/rtl/alu_components.vhd
	
	vcom -2008 -work work ../../pipeline_datapath/rtl/pipeline_datapath.vhd

    vcom -2008 -work work ../../rtl/pipeline_components.vhd
	
	vcom -2008 -work work ../../rtl/pipeline_processor.vhd

	vcom -2008 -work work ../pipeline_processor_testbench.vhd

	vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  pipeline_processor_testbench
	vsim -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs=\"+acc\" -t 1ps pipeline_processor_testbench

	add wave *
    add wave /PP/PD/current_instruction
    add wave /PP/PD/r_instruction_value_1
    add wave /PP/PD/r_instruction_value_2
    add wave /PP/PD/r_instruction_value_3
    add wave /PP/PD/REGF/banco(31)
    add wave /PP/PD/REGF/banco(30)
    add wave /PP/PD/REGF/banco(29)
    add wave /PP/PD/REGF/banco(28)
    add wave /PP/PD/REGF/banco(27)
    add wave /PP/PD/REGF/banco(26)
    add wave /PP/PD/REGF/banco(25)
    add wave /PP/PD/REGF/banco(24)
    add wave /PP/PD/REGF/banco(23)
    add wave /PP/PD/REGF/banco(22)
    add wave /PP/PD/REGF/banco(21)
    add wave /PP/PD/REGF/banco(20)
    add wave /PP/PD/REGF/banco(19)
    add wave /PP/PD/REGF/banco(18)
    add wave /PP/PD/REGF/banco(17)
    add wave /PP/PD/REGF/banco(16)
    add wave /PP/PD/REGF/banco(15)
    add wave /PP/PD/REGF/banco(14)
    add wave /PP/PD/REGF/banco(13)
    add wave /PP/PD/REGF/banco(12)
    add wave /PP/PD/REGF/banco(11)
    add wave /PP/PD/REGF/banco(10)
    add wave /PP/PD/REGF/banco(9)
    add wave /PP/PD/REGF/banco(8)
    add wave /PP/PD/REGF/banco(7)
    add wave /PP/PD/REGF/banco(6)
    add wave /PP/PD/REGF/banco(5)
    add wave /PP/PD/REGF/banco(4)
    add wave /PP/PD/REGF/banco(3)
    add wave /PP/PD/REGF/banco(2)
    add wave /PP/PD/REGF/banco(1)
    add wave /PP/PD/REGF/banco(0)
    add wave /PP/PD/r_epc_output_1
    add wave /PP/PD/hi_output
    add wave /PP/PD/lo_output
    add wave /PP/w_forward_rs_2
    add wave /PP/w_forward_rs_3
    add wave /PP/w_forward_rt_2
    add wave /PP/w_forward_rt_3
    add wave /PP/w_pc_source_p_1
    add wave /PP/w_rst_1_2
    add wave /PP/w_stall_1_rst_2
    add wave /PP/PD/DMEM/ram(126)
    add wave /PP/PD/DMEM/ram(125)
    add wave /PP/PD/DMEM/ram(124)
    add wave /PP/PD/DMEM/ram(123)
    add wave /PP/PD/DMEM/ram(122)
    add wave /PP/PD/DMEM/ram(121)
    add wave /PP/PD/DMEM/ram(120)
    add wave /PP/PD/DMEM/ram(119)
    add wave /PP/PD/DMEM/ram(118)
    add wave /PP/PD/DMEM/ram(117)
    add wave /PP/PD/DMEM/ram(116)
    add wave /PP/PD/DMEM/ram(115)
    add wave /PP/PD/DMEM/ram(114)
    add wave /PP/PD/DMEM/ram(113)
    add wave /PP/PD/DMEM/ram(112)
    add wave /PP/PD/DMEM/ram(111)
    add wave /PP/PD/DMEM/ram(110)
    add wave /PP/PD/DMEM/ram(109)
    add wave /PP/PD/DMEM/ram(108)
    add wave /PP/PD/DMEM/ram(107)
    add wave /PP/PD/DMEM/ram(106)
    add wave /PP/PD/DMEM/ram(105)
    add wave /PP/PD/DMEM/ram(104)
    add wave /PP/PD/DMEM/ram(103)
    add wave /PP/PD/DMEM/ram(102)
    add wave /PP/PD/DMEM/ram(101)
    add wave /PP/PD/DMEM/ram(100)
    add wave /PP/PD/DMEM/ram(99)
    add wave /PP/PD/DMEM/ram(98)
    add wave /PP/PD/DMEM/ram(97)
    add wave /PP/PD/DMEM/ram(96)
    add wave /PP/PD/DMEM/ram(95)
    add wave /PP/PD/DMEM/ram(94)
    add wave /PP/PD/DMEM/ram(93)
    add wave /PP/PD/DMEM/ram(92)
    add wave /PP/PD/DMEM/ram(91)
    add wave /PP/PD/DMEM/ram(90)
    add wave /PP/PD/DMEM/ram(89)
    add wave /PP/PD/DMEM/ram(88)
    add wave /PP/PD/DMEM/ram(87)
    add wave /PP/PD/DMEM/ram(86)
    add wave /PP/PD/DMEM/ram(85)
    add wave /PP/PD/DMEM/ram(84)
    add wave /PP/PD/DMEM/ram(83)
    add wave /PP/PD/DMEM/ram(82)
    add wave /PP/PD/DMEM/ram(81)
    add wave /PP/PD/DMEM/ram(80)
    add wave /PP/PD/DMEM/ram(79)
    add wave /PP/PD/DMEM/ram(78)
    add wave /PP/PD/DMEM/ram(77)
    add wave /PP/PD/DMEM/ram(76)
    add wave /PP/PD/DMEM/ram(75)
    add wave /PP/PD/DMEM/ram(74)
    add wave /PP/PD/DMEM/ram(73)
    add wave /PP/PD/DMEM/ram(72)
    add wave /PP/PD/DMEM/ram(71)
    add wave /PP/PD/DMEM/ram(70)
    add wave /PP/PD/DMEM/ram(69)
    add wave /PP/PD/DMEM/ram(68)
    add wave /PP/PD/DMEM/ram(67)
    add wave /PP/PD/DMEM/ram(66)
    add wave /PP/PD/DMEM/ram(65)
    add wave /PP/PD/DMEM/ram(64)
    add wave /PP/PD/DMEM/ram(63)
    add wave /PP/PD/DMEM/ram(62)
    add wave /PP/PD/DMEM/ram(61)
    add wave /PP/PD/DMEM/ram(60)
    add wave /PP/PD/DMEM/ram(59)
    add wave /PP/PD/DMEM/ram(58)
    add wave /PP/PD/DMEM/ram(57)
    add wave /PP/PD/DMEM/ram(56)
    add wave /PP/PD/DMEM/ram(55)
    add wave /PP/PD/DMEM/ram(54)
    add wave /PP/PD/DMEM/ram(53)
    add wave /PP/PD/DMEM/ram(52)
    add wave /PP/PD/DMEM/ram(51)
    add wave /PP/PD/DMEM/ram(50)
    add wave /PP/PD/DMEM/ram(49)
    add wave /PP/PD/DMEM/ram(48)
    add wave /PP/PD/DMEM/ram(47)
    add wave /PP/PD/DMEM/ram(46)
    add wave /PP/PD/DMEM/ram(45)
    add wave /PP/PD/DMEM/ram(44)
    add wave /PP/PD/DMEM/ram(43)
    add wave /PP/PD/DMEM/ram(42)
    add wave /PP/PD/DMEM/ram(41)
    add wave /PP/PD/DMEM/ram(40)
    add wave /PP/PD/DMEM/ram(39)
    add wave /PP/PD/DMEM/ram(38)
    add wave /PP/PD/DMEM/ram(37)
    add wave /PP/PD/DMEM/ram(36)
    add wave /PP/PD/DMEM/ram(35)
    add wave /PP/PD/DMEM/ram(34)
    add wave /PP/PD/DMEM/ram(33)
    add wave /PP/PD/DMEM/ram(32)
    add wave /PP/PD/DMEM/ram(31)
    add wave /PP/PD/DMEM/ram(30)
    add wave /PP/PD/DMEM/ram(29)
    add wave /PP/PD/DMEM/ram(28)
    add wave /PP/PD/DMEM/ram(27)
    add wave /PP/PD/DMEM/ram(26)
    add wave /PP/PD/DMEM/ram(25)
    add wave /PP/PD/DMEM/ram(24)
    add wave /PP/PD/DMEM/ram(23)
    add wave /PP/PD/DMEM/ram(22)
    add wave /PP/PD/DMEM/ram(21)
    add wave /PP/PD/DMEM/ram(20)
    add wave /PP/PD/DMEM/ram(19)
    add wave /PP/PD/DMEM/ram(18)
    add wave /PP/PD/DMEM/ram(17)
    add wave /PP/PD/DMEM/ram(16)
    add wave /PP/PD/DMEM/ram(15)
    add wave /PP/PD/DMEM/ram(14)
    add wave /PP/PD/DMEM/ram(13)
    add wave /PP/PD/DMEM/ram(12)
    add wave /PP/PD/DMEM/ram(11)
    add wave /PP/PD/DMEM/ram(10)
    add wave /PP/PD/DMEM/ram(9)
    add wave /PP/PD/DMEM/ram(8)
    add wave /PP/PD/DMEM/ram(7)
    add wave /PP/PD/DMEM/ram(6)
    add wave /PP/PD/DMEM/ram(5)
    add wave /PP/PD/DMEM/ram(4)
    add wave /PP/PD/DMEM/ram(3)
    add wave /PP/PD/DMEM/ram(2)
    add wave /PP/PD/DMEM/ram(1)
    add wave /PP/PD/DMEM/ram(0)
	view structure
	view signals
	run 25 us
}
