library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.GENERIC_COMPONENTS.registrador;
use work.PERIPHERAL_COMPONENTS.up_counter;
use work.GENERIC_FUNCTIONS.ceil_log_2;
use work.GENERIC_FUNCTIONS.int2slv;

entity byte_2_word is
    generic(
	    DATA_LENGTH : natural := 32);
	port(
        byte : in std_logic_vector(7 downto 0); 
        clk : in std_logic;
        rst : in std_logic;
        set_byte : in std_logic;
        valid_word : out std_logic;
        word : out std_logic_vector((DATA_LENGTH-1) downto 0)); 
end entity;

architecture structure_b2w of byte_2_word is
    signal w_done : std_logic;
    signal w_reset : std_logic;
    signal w_restart : std_logic;
    signal w_shifted : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal w_word : std_logic_vector((DATA_LENGTH-1) downto 0); 
    
    begin
        WD : registrador
            generic map(
                largura_dado => DATA_LENGTH)
            port map(
                clk => clk,
                entrada_dados => w_shifted,
                reset => rst,
                WE => set_byte,
                saida_dados => w_word);

        UC : up_counter
            generic map(
                DATA_LENGTH => ceil_log_2(DATA_LENGTH/8))
            port map(
                clk => clk,
                count => set_byte,
                max_count => int2slv(((DATA_LENGTH/8)-1),
                ceil_log_2(DATA_LENGTH/8)), 
                rst => rst,
                set => w_restart,
                reset => w_reset);

        DN : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or w_done,
                WE => w_restart,
                saida_dados(0) => w_done);

        w_restart <= set_byte and w_reset;
        w_shifted((DATA_LENGTH-1) downto (DATA_LENGTH-8)) <= byte; 
        w_shifted((DATA_LENGTH-9) downto 0) <=
        w_word((DATA_LENGTH-1) downto 8); 
        
        valid_word <= w_done;
        word <= w_word;
end architecture;
