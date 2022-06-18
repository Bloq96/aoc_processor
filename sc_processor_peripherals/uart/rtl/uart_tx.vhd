library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.GENERIC_COMPONENTS.registrador;
use work.PERIPHERAL_COMPONENTS.up_counter;
use work.GENERIC_FUNCTIONS.ceil_log_2;
use work.GENERIC_FUNCTIONS.int2slv;
use work.GENERIC_FUNCTIONS.reductive_xor;

entity uart_tx is
    generic(
	    MAX_LENGTH : natural := 32);
	port(
        byte : in std_logic_vector(7 downto 0); 
        clk : in std_logic;
        clk_ticks : in std_logic_vector((MAX_LENGTH-1) downto 0);
        rst : in std_logic;
        send : in std_logic;
        data_bit : out std_logic);
end entity;

architecture structure_tx of uart_tx is
    signal w_block : std_logic;
    signal w_byte : std_logic_vector(10 downto 0); 
    signal w_done : std_logic;
    signal w_input : std_logic_vector(10 downto 0); 
    signal w_send : std_logic;
    signal w_shifted : std_logic_vector(10 downto 0); 
    signal w_tick : std_logic;
    
    begin
        BC : up_counter
            generic map(
                DATA_LENGTH => 4)
            port map(
                clk => clk,
                count => w_tick,
                max_count => "1010", 
                rst => rst,
                set => w_send,
                reset => w_done);

        BLK : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or (w_done and w_tick and not(send)),
                WE => send,
                saida_dados(0) => w_block);

        B : registrador
            generic map(
                largura_dado => 11)
            port map(
                clk => clk,
                entrada_dados => w_input,
                reset => rst,
                WE => w_send or w_tick,
                saida_dados => w_byte);

        CC : up_counter
            generic map(
                DATA_LENGTH => MAX_LENGTH)
            port map(
                clk => clk,
                count => '1',
                max_count => clk_ticks, 
                rst => rst,
                set => w_send,
                reset => w_tick);

        w_input <= ('1' & reductive_xor(byte) & byte & '0') when
                   (w_send = '1') else w_shifted;
        w_send <= send and (not(w_block) or (w_done and w_tick));
        w_shifted(10) <= '0'; 
        w_shifted(9 downto 0) <= w_byte(10 downto 1); 
        
        data_bit <= not(w_block) or w_byte(0); 
end architecture;
