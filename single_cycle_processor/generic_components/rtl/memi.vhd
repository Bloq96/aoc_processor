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
        64      => X"34080034", -- ori $t0, $0, 52
        65      => X"34090022", -- ori $t1, $0, 34
        66      => X"01098020", -- add $s0, $t0, $t1 
        67      => X"3C08FFFF", -- lui $t0, 0xFFFF 
        68      => X"3508FFFC", -- ori $t0, $t0, -4
        69      => X"03A8E820", -- add $sp, $sp, $t0 
        70      => X"AFB00000", -- sw $s0, 0($sp)
        71      => X"04000000", -- nop
        72      => X"08000047", -- jump 71
        others  => X"04000000"  -- nop
    );
begin
	Instrucao <= rom(to_integer(unsigned(Endereco)));
end comportamental;
