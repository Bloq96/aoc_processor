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
        1       => X"0000000D", -- break
        2       => X"23BDFFF8", -- addi $sp, $sp, -8
        3       => X"AFA80000", -- sw $t0, 0($sp)
        4       => X"AFA90004", -- sw $t1, 4($sp)
        5       => X"34090400", -- ori $t1, $0, 1024
        6       => X"8D28FE00", -- lw $t0, -512($t1) 
        7       => X"21080001", -- addi $t0, $t0, 1 
        8       => X"AD280004", -- sw $t0, 4($t1)
        9       => X"AD28FE00", -- sw $t0, -512($t1)
        10      => X"8FA90004", -- lw $t1, 4($sp)
        11      => X"8FA80000", -- lw $t0, 0($sp)
        12      => X"23BD0008", -- addi $sp, $sp, 8
        13      => X"0000000D", -- break
        -- init --
        48      => X"34080400", -- ori $t0, $0, 1024
        49      => X"AD00FE00", -- sw $0, -512($t0)
        50      => X"AD000000", -- sw $0, 0($t0)
        -- functions --
        -- infinite loop --
        127     => X"0800006C", -- j 108
        others  => X"04000000"  -- nop
    );
begin
	Instrucao <= rom(to_integer(unsigned(Endereco)));
end comportamental;
