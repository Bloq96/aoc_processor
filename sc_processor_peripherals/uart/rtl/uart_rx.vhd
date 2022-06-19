library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.GENERIC_COMPONENTS.registrador;
use work.PERIPHERAL_COMPONENTS.up_counter;
use work.GENERIC_FUNCTIONS.ceil_log_2;
use work.GENERIC_FUNCTIONS.int2slv;
use work.GENERIC_FUNCTIONS.reductive_xor;

entity uart_rx is
    generic(
	    MAX_LENGTH : natural := 32);
	port(
        clk : in std_logic;
        clk_ticks : in std_logic_vector((MAX_LENGTH-1) downto 0); 
        data_bit : in std_logic;
        rst : in std_logic;
        byte : out std_logic_vector(7 downto 0);
        recv : out std_logic);
end entity;

architecture structure_rx of uart_rx is
    signal w_block : std_logic;
    signal w_byte : std_logic_vector(10 downto 0); 
    signal w_done : std_logic;
    signal w_recv : std_logic;
    signal w_reset : std_logic;
    signal w_shifted : std_logic_vector(10 downto 0); 
    signal w_tick : std_logic;
    
    begin
        BLK : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or (w_done and w_tick and data_bit),
                WE => not(data_bit),
                saida_dados(0) => w_block);

        BC : up_counter
            generic map(
                DATA_LENGTH => 4)
            port map(
                clk => clk,
                count => w_tick,
                max_count => "1010", 
                rst => rst,
                set => w_recv,
                reset => w_done);

        B : registrador
            generic map(
                largura_dado => 11)
            port map(
                clk => clk,
                entrada_dados => w_shifted,
                reset => rst,
                WE => w_tick,
                saida_dados => w_byte);

        CC : up_counter
            generic map(
                DATA_LENGTH => MAX_LENGTH)
            port map(
                clk => clk,
                count => '1',
                max_count => clk_ticks, 
                rst => rst,
                set => w_recv,
                reset => w_tick);

        w_recv <= not(data_bit) and (not(w_block) or (w_done and
        w_tick));
        w_shifted(10) <= data_bit; 
        w_shifted(9 downto 0) <= w_byte(10 downto 1); 
        
        recv <= w_block and w_done and w_tick and
        not(reductive_xor(w_byte(8 downto 1)) xor w_byte(9));
        byte <= w_byte(8 downto 1);
end architecture;
