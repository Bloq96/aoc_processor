library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.GENERIC_COMPONENTS.registrador;
use work.GENERIC_FUNCTIONS.bool2sl;
use work.GENERIC_FUNCTIONS.int2slv;
use work.GENERIC_FUNCTIONS.slv2nat;


entity up_counter is
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
end entity;

architecture structure_up_counter of up_counter is
    signal w_value : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal w_max_count : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal w_reset : std_logic;
    signal w_sum : std_logic_vector((DATA_LENGTH-1) downto 0); 
    
    begin
        MAX : registrador
            generic map(
                largura_dado => DATA_LENGTH)
            port map(
                clk => clk,
                entrada_dados => max_count,
                reset => '0',
                WE => rst,
                saida_dados => w_max_count);
        
        CNT : registrador
            generic map(
                largura_dado => DATA_LENGTH)
            port map(
                clk => clk,
                entrada_dados => w_sum,
                reset => rst or set or (w_reset and count),
                WE => count,
                saida_dados => w_value);

        w_sum <= int2slv(slv2nat(w_value)+1,DATA_LENGTH); 
        w_reset <= bool2sl(w_max_count = w_value);

        value <= w_value;
        reset <= w_reset; 
end architecture;
