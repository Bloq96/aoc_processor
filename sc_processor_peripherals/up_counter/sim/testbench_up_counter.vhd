library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.GENERIC_FUNCTIONS.int2slv;

entity testbench_up_counter is
	generic (
			DATA_LENGTH : integer := 32);
end entity;

architecture dataflow_testcench_uc of testbench_up_counter is
    signal clk : std_logic;
    signal count : std_logic;
    signal max_count : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal rst : std_logic;
    signal set : std_logic;
    signal value : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal reset : std_logic;
	
    component up_counter is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            clk : in std_logic;
            count : in std_logic;
            max_count : in std_logic_vector((DATA_LENGTH-1) downto 0); 
            rst : in std_logic;
            set : in std_logic;
            value : out std_logic_vector((DATA_LENGTH-1) downto 0); 
            reset : out std_logic);
    end component;
	
	begin
        UC: up_counter
            generic map(
            DATA_LENGTH => DATA_LENGTH)
        port map(
            clk => clk,
			count => count,
            max_count => max_count,
            rst => rst,
            set => set,
            value => value, 
            reset => reset);

        pulse : process
            begin
                clk <= '1';
                wait for 50 ns;
                clk <= '0';
                wait for 50 ns;
        end process;

        rst <= '1', '0' after 100001 ps;
        max_count <= X"0000000F", X"00000000" after 100001 ps;
        set <= '0', '1' after 500001 ps, '0' after 600001 ps;
        count <= '1', '0' after 2500001 ps;
end architecture;
