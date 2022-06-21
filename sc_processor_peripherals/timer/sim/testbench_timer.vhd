library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.GENERIC_FUNCTIONS.int2slv;

entity testbench_timer is
	generic (
			DATA_LENGTH : integer := 32);
end entity;

architecture dataflow_testbench_timer of testbench_timer is
    signal clk : std_logic;
    signal clk_division : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal count : std_logic;
    signal max_count : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal rst : std_logic;
    signal set : std_logic;
    signal value_division : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal value_count : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal reset : std_logic;
    
    component timer is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            clk : in std_logic;
            clk_division : in std_logic_vector((DATA_LENGTH-1) downto 0);
            count : in std_logic;
            max_count : in std_logic_vector((DATA_LENGTH-1) downto 0);
            rst : in std_logic;
            set : in std_logic;
            value_division : out std_logic_vector((DATA_LENGTH-1) downto 0);
            value_count : out std_logic_vector((DATA_LENGTH-1) downto 0);
            reset : out std_logic);
    end component;	
	
	begin
        T : timer
            generic map(
            DATA_LENGTH => DATA_LENGTH)
        port map(
            clk => clk,
            clk_division => clk_division,
			count => count,
            max_count => max_count,
            rst => rst,
            set => set,
            value_division => value_division, 
            value_count => value_count, 
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
        clk_division <= X"00000003", X"00000000" after 100001 ps;
        set <= '0', '1' after 500001 ps, '0' after 600001 ps;
        count <= '1', '0' after 2900001 ps, '1' after 3200001 ps, '0' after 3700001 ps, '1' after 4300001 ps;
end architecture;
