-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletronica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Memória de Programas ou Memória de Instruções de tamanho genérico
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memi is
	generic (
		INSTR_WIDTH   : natural; -- tamanho da instrucao em numero de bits
		MI_ADDR_WIDTH : natural  -- tamanho do endereco da memoria de instrucoes em numero de bits
	);
	port (
		Endereco  : in std_logic_vector(MI_ADDR_WIDTH - 1 downto 0);
		Instrucao : out std_logic_vector(INSTR_WIDTH - 1 downto 0)
	);
end entity;

architecture comportamental of memi is
	type rom_type is array (0 to 2 ** MI_ADDR_WIDTH - 1) of std_logic_vector(INSTR_WIDTH - 1 downto 0);
	signal rom : rom_type := (
        0       => X"0000000C", -- syscall
        1       => X"34080004", -- ori $t0, $0, 4
        2       => X"03A8E822", -- sub $sp, $sp, $t0 
        3       => X"34080001", -- ori $t0, $0, 1
        4       => X"0800000E", -- j 14
        5       => X"34080004", -- ori $t0, $0, 4
        6       => X"03A8E822", -- sub $sp, $sp, $t0 
        7       => X"34080002", -- ori $t0, $0, 2
        8       => X"0800000E", -- j 14
        14      => X"AFA80000", -- sw $t0, 0($sp)
        15      => X"0000000D", -- break
        -- init --
        48      => X"3C087FFF", -- lui $t0, 0x7FFF
        49      => X"3508FFFF", -- ori $t0, $t0, 0xFFFF
        50      => X"3C094000", -- lui $t1, 0x4000
        51      => X"01098020", -- add $s0, $t0, $t1
        52      => X"34080004", -- ori $t0, $0, 4
        53      => X"03A8E820", -- add $sp, $sp, $t0 
        54      => X"0C000044", -- jal 68
        55      => X"0800006C", -- j 108
        -- functions --
        68      => X"34081000", -- ori $t0, $0, 0x1000
        69      => X"34090002", -- ori $t1, $0, 2
        70      => X"0109001A", -- div $t0, $t1
        71      => X"34080004", -- ori $t0, $0, 4
        72      => X"03A8E820", -- add $sp, $sp, $t0 
        73      => X"3C08FFFF", -- lui $t0, 0xFFFF
        74      => X"3508FFF3", -- ori $t0, $t0, 0xFFF3
        75      => X"3C09FFFF", -- lui $t1, 0xFFFF
        76      => X"3529FC00", -- ori $t1, $t1, 0xFC00
        77      => X"0109001A", -- div $t0, $t1
        78      => X"34080004", -- ori $t0, $0, 4
        79      => X"03A8E820", -- add $sp, $sp, $t0 
        80      => X"3C08FFFF", -- lui $t0, 0xFFFF
        81      => X"3508F800", -- ori $t0, $t0, 0xF800
        82      => X"340901FF", -- ori $t1, $0, 0x01FF
        83      => X"0109001A", -- div $t0, $t1
        84      => X"34080004", -- ori $t0, $0, 4
        85      => X"03A8E822", -- sub $sp, $sp, $t0 
        86      => X"00004012", -- mflo $t0
        87      => X"AFA80000", -- sw $t0, 0($sp)
        88      => X"03E00008", -- jr $ra
        -- infinite loop --
        127     => X"0800006C", -- j 108
        others  => X"04000000"  -- nop
    );
begin
	Instrucao <= rom(to_integer(unsigned(Endereco)));
end comportamental;
