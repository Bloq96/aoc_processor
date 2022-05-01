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
        64      => X"00004020", -- add $t0, $0, $0
        65      => X"34080034", -- ori $t0, $0, 52
        66      => X"00004820", -- add $t1, $0, $0
        67      => X"34090022", -- ori $t1, $0, 34
        68      => X"01098020", -- add $s0, $t0, $t1 
        69      => X"3C08FFFF", -- lui $t0, 0xFFFF 
        70      => X"3508FFFC", -- ori $t0, $t0, -4
        71      => X"03A8E820", -- add $sp, $sp, $t0 
        72      => X"AFB00000", -- sw $s0, 0($sp)
        73      => X"04000000", -- nop
        74      => X"08000049", -- jump 73
        others  => X"04000000"  -- nop
    );
begin
	Instrucao <= rom(to_integer(unsigned(Endereco)));
end comportamental;
