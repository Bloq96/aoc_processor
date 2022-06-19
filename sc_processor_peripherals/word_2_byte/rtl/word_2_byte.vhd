library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.GENERIC_COMPONENTS.registrador;
use work.PERIPHERAL_COMPONENTS.up_counter;
use work.GENERIC_FUNCTIONS.ceil_log_2;
use work.GENERIC_FUNCTIONS.int2slv;

entity word_2_byte is
    generic(
	    DATA_LENGTH : natural := 32);
	port(
        clk : in std_logic;
        rst : in std_logic;
        set_word : in std_logic;
        shift : in std_logic;
        word : in std_logic_vector((DATA_LENGTH-1) downto 0); 
        byte : out std_logic_vector(7 downto 0); 
        valid_byte : out std_logic);
end entity;

architecture structure_w2b of word_2_byte is
    signal w_done : std_logic;
    signal w_input : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal w_shifted : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal w_word : std_logic_vector((DATA_LENGTH-1) downto 0); 
    
    begin
        WD : registrador
            generic map(
                largura_dado => DATA_LENGTH)
            port map(
                clk => clk,
                entrada_dados => w_input,
                reset => rst,
                WE => set_word or shift,
                saida_dados => w_word);

        UC : up_counter
            generic map(
                DATA_LENGTH => ceil_log_2(DATA_LENGTH/8))
            port map(
                clk => clk,
                count => shift,
                max_count => int2slv(((DATA_LENGTH/8)-1),
                ceil_log_2(DATA_LENGTH/8)), 
                rst => rst,
                set => set_word,
                reset => w_done);

        VLD : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or (shift and w_done and not(set_word)),
                WE => set_word,
                saida_dados(0) => valid_byte);

        w_input <= word when (set_word = '1') else
                   w_shifted;
        w_shifted((DATA_LENGTH-1) downto (DATA_LENGTH-8)) <=
        (others => '0'); 
        w_shifted((DATA_LENGTH-9) downto 0) <=
        w_word((DATA_LENGTH-1) downto 8); 
        
        byte <= w_word(7 downto 0); 
end architecture;
