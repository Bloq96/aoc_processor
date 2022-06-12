library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.GENERIC_FUNCTIONS.int2slv;

entity testbench_extended_alu is
	generic (
			DATA_LENGTH : integer := 32);
end entity;

architecture dataflow_testcench_extended_alu of testbench_extended_alu
is
	signal w_input_a : std_logic_vector((DATA_LENGTH-1) downto 0);
	signal w_input_b : std_logic_vector((DATA_LENGTH-1) downto 0);
	signal w_selector : std_logic_vector(5 downto 0);
	signal w_output_a : std_logic_vector((DATA_LENGTH-1) downto 0);
	signal w_output_b : std_logic_vector((DATA_LENGTH-1) downto 0);
	signal w_zero : std_logic;
	
    component extended_alu is
        generic(
            DATA_LENGTH : natural);
        port(
            input_a : in std_logic_vector((DATA_LENGTH-1) downto 0);
            input_b : in std_logic_vector((DATA_LENGTH-1) downto 0);
            selector : in std_logic_vector(5 downto 0);
            output_a : out std_logic_vector((DATA_LENGTH-1) downto 0);
            output_b : out std_logic_vector((DATA_LENGTH-1) downto 0);
            zero : out std_logic);
    end component;
	
	begin
		EALU : extended_alu
			generic map (
				DATA_LENGTH => DATA_LENGTH)
			port map (
				input_a => w_input_a,
				input_b => w_input_b,
				selector => w_selector,
				output_a => w_output_a,
				output_b => w_output_b,
				zero => w_zero);
	
        w_selector <= "000000", "000011" after 200001 ps,
        "000100" after 400001 ps, "000111" after 600001 ps,
        "001000" after 800001 ps, "001001" after 1000001 ps,
        "001100" after 1200001 ps, "001101" after 1400001 ps,
        "010000" after 1600001 ps, "010010" after 1800001 ps,
        "011000" after 2000001 ps, "011010" after 2200001 ps,
        "100000" after 2400001 ps, "100010" after 2600001 ps,
        "100100" after 2800001 ps, "100101" after 3000001 ps,
        "100110" after 3200001 ps, "100111" after 3400001 ps,	
        "101010" after 3600001 ps, "011010" after 3800001 ps;	
        w_input_a <= X"00000005", X"00000002" after 200001 ps,
        X"00000004" after 400001 ps, X"00000007" after 600001 ps,
        X"00018000" after 800001 ps, X"0000000F" after 2000001 ps,
        X"000000D6" after 2200001 ps, X"00000022" after 2400001 ps,
        X"0000000D" after 2600001 ps, X"00000005" after 2800001 ps,
        X"0000000A" after 3600001 ps, X"000007FC" after 3800001 ps,
        X"FFFFF804" after 4000001 ps;	
        w_input_b <= X"00000005", X"00000004" after 200001 ps,
        X"00000007" after 400001 ps, X"FFFFFF80" after 600001 ps,
        X"01800180" after 800001 ps, X"FFFFFFF2" after 2000001 ps,
        X"00000007" after 2200001 ps, X"00000039" after 2400001 ps,
        X"0000000F" after 2600001 ps, X"00000003" after 2800001 ps,
        X"FFFFFFF0" after 3600001 ps, X"000001FF" after 3800001 ps;	
end architecture;
