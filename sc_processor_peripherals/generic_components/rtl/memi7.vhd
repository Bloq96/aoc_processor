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
        8       => X"23BDFFF8", -- addi $sp, $sp, -8
        9       => X"AFA80000", -- sw $t0, 0($sp)
        10      => X"AFA90004", -- sw $t1, 4($sp)
        11      => X"34080400", -- ori $t0, $0, 1024
        12      => X"8D090000", -- lw $t1, 0($t0) 
        13      => X"34080200", -- ori $t0, $0, 512 
        14      => X"8D080000", -- lw $t0, 0($t0) 
        15      => X"01284820", -- add $t1, $t1, $t0
        16      => X"34080200", -- ori $t0, $0, 512
        17      => X"AD090000", -- sw $t1, 0($t0)
        18      => X"34080400", -- ori $t0, $0, 1024
        19      => X"AD090000", -- sw $t1, 0($t0)
        20      => X"8FA90004", -- lw $t1, 4($sp)
        21      => X"8FA80000", -- lw $t0, 0($sp)
        22      => X"23BD0008", -- addi $sp, $sp, 8
        23      => X"0000000D", -- break
        24      => X"23BDFFF8", -- addi $sp, $sp, -8
        25      => X"AFA80000", -- sw $t0, 0($sp)
        26      => X"AFA90004", -- sw $t1, 4($sp)
        27      => X"34080400", -- ori $t0, $0, 1024
        28      => X"8D090004", -- lw $t1, 4($t0) 
        29      => X"21290001", -- addi $t1, $t1, 1
        30      => X"AD090004", -- sw $t1, 4($t0)
        31      => X"8FA90004", -- lw $t1, 4($sp)
        32      => X"8FA80000", -- lw $t0, 0($sp)
        33      => X"23BD0008", -- addi $sp, $sp, 8
        34      => X"0000000D", -- break
        -- init --
        48      => X"34080400", -- ori $t0, $0, 1024
        49      => X"AD000000", -- sw $0, 0($t0)
        50      => X"AD000004", -- sw $0, 4($t0)
        51      => X"34040007", -- ori $a0, $0, 7
        52      => X"34080110", -- ori $t0, $0, 272
        53      => X"0100F809", -- jalr $ra, $t0
        54      => X"34080001", -- ori $t0, $0, 1
        55      => X"00084080", -- sll $t0, $t0, 2
        56      => X"03A8E822", -- sub $sp, $sp, $t0 
        57      => X"AFA20000", -- sw $v0, 0($sp)
        58      => X"0800006C", -- j 108
        -- functions --
        68      => X"34080002", -- ori $t0, $0, 2
        69      => X"0088402A", -- slt $t0, $a0, $t0
        70      => X"11000002", -- beq $t0, $0, 2 
        71      => X"34020001", -- ori $v0, $0, 1
        72      => X"03E00008", -- jr $ra
        73      => X"03A04020", -- add $t0, $sp, $0
        74      => X"3C09FFFF", -- lui $t1, 0xFFFF 
        75      => X"200A3FFE", -- addi $t2, $0, 0x3FFE 
        76      => X"340B0002", -- ori $t3, $0, 2 
        77      => X"016A5004", -- sllv $t2, $t2, $t3 
        78      => X"012A4825", -- or $t1, $t1, $t2
        79      => X"03A9E820", -- add $sp, $sp, $t1 
        80      => X"AFBE0004", -- sw $fp, 4($sp)
        81      => X"0100F020", -- add $fp, $t0, $0
        82      => X"016B001A", -- div $t3, $t3
        83      => X"00005012", -- mflo $t2
        84      => X"01494807", -- srav $t1, $t1, $t2 
        85      => X"03A9E820", -- add $sp, $sp, $t1 
        86      => X"AFBF0004", -- sw $ra, 4($sp)
        87      => X"AFB00000", -- sw $s0, 0($sp)
        88      => X"00808020", -- add $s0, $a0, $0
        89      => X"00094883", -- sra $t1, $t1, 2
        90      => X"00892020", -- add $a0, $a0, $t1
        91      => X"0C000044", -- jal 68
        92      => X"02020018", -- mult $s0, $v0
        93      => X"00001012", -- mflo $v0
        94      => X"8FB00000", -- lw $s0, 0($sp)
        95      => X"8FBF0004", -- lw $ra, 4($sp)
        96      => X"8FBE0008", -- lw $fp, 8($sp)
        97      => X"23BD000C", -- addi $sp, $sp, 12
        98      => X"03E00008", -- jr $ra
        -- infinite loop --
        127     => X"0800006C", -- j 108
        others  => X"04000000"  -- nop
    );
begin
	Instrucao <= rom(to_integer(unsigned(Endereco)));
end comportamental;
