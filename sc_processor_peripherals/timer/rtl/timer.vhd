library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.PERIPHERAL_COMPONENTS.up_counter;
use work.GENERIC_FUNCTIONS.bool2sl;
use work.GENERIC_FUNCTIONS.int2slv;
use work.GENERIC_FUNCTIONS.slv2nat;


entity timer is
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
end entity;

architecture structure_timer of timer is
    signal w_count : std_logic;
    signal w_reset : std_logic;
    
    begin
        DIVx : up_counter
            generic map(
	            DATA_LENGTH => DATA_LENGTH)
	        port map(
                clk => clk,
                count => count,
                max_count => clk_division,
                rst => rst,
                set => set,
                value => value_division, 
                reset => w_count);
        
        CNTx : up_counter
            generic map(
	            DATA_LENGTH => DATA_LENGTH)
	        port map(
                clk => clk,
                count => count and w_count,
                max_count => max_count,
                rst => rst,
                set => set,
                value => value_count, 
                reset => w_reset);
        reset <= w_reset and w_count and count;
end architecture;
