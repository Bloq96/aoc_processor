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
		INSTR_WIDTH   : natural; -- tamanho da instrucaoo em numero de bits
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
        -- init --
        48      => X"34040005", -- ori $a0, $0, 5
        49      => X"0C000044", -- jal 68
        50      => X"3C08FFFF", -- lui $t0, 0xFFFF 
        51      => X"3508FFFC", -- ori $t0, $t0, -4
        52      => X"03A8E820", -- add $sp, $sp, $t0 
        53      => X"AFA20000", -- sw $v0, 0($sp)
        54      => X"0800006C", -- j 108
        -- functions --
        68      => X"34080002", -- ori $t0, $0, 2
        69      => X"0088402A", -- slt $t0, $a0, $t0
        70      => X"11000002", -- beq $t0, $0, 2 
        71      => X"34020001", -- ori $v0, $0, 1
        72      => X"03E00008", -- jr $ra
        73      => X"03A04020", -- add $t0, $sp, $0
        74      => X"3C09FFFF", -- lui $t1, 0xFFFF 
        75      => X"3529FFFC", -- ori $t1, $t1, -4
        76      => X"03A9E820", -- add $sp, $sp, $t1 
        77      => X"AFBE0000", -- sw $fp, 0($sp)
        78      => X"0100F020", -- add $fp, $t0, $0
        79      => X"03A9E820", -- add $sp, $sp, $t1 
        80      => X"AFBF0000", -- sw $ra, 0($sp)
        81      => X"03A9E820", -- add $sp, $sp, $t1 
        82      => X"AFB00000", -- sw $s0, 0($sp)
        83      => X"00808020", -- add $s0, $a0, $0
        84      => X"3C08FFFF", -- lui $t0, 0xFFFF 
        85      => X"3508FFFF", -- ori $t0, $t0, -1
        86      => X"00882020", -- add $a0, $a0, $t0
        87      => X"0C000044", -- jal 68
        88      => X"02020018", -- mult $s0, $v0
        89      => X"00001012", -- mflo $v0
        90      => X"8FB00000", -- lw $s0, 0($sp)
        91      => X"34080004", -- ori $t0, $0, 4
        92      => X"03A8E820", -- add $sp, $sp, $t0 
        93      => X"8FBF0000", -- lw $ra, 0($sp)
        94      => X"03A8E820", -- add $sp, $sp, $t0 
        95      => X"8FBE0000", -- lw $fp, 0($sp)
        96      => X"03A8E820", -- add $sp, $sp, $t0 
        97      => X"03E00008", -- jr $ra
        -- infinite loop --
        127     => X"0800006C", -- j 108
        others  => X"04000000"  -- nop
    );
begin
	Instrucao <= rom(to_integer(unsigned(Endereco)));
end comportamental;
