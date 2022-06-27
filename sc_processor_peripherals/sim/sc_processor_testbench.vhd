library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sc_processor_testbench is
end entity;

architecture dataflow_processor_tb of sc_processor_testbench is
	signal clock : std_logic;
	signal gpio_data : std_logic_vector(1 downto 0);
	signal reset : std_logic;
    signal uart_rx : std_logic;
    signal uart_tx : std_logic;
	signal output : std_logic_vector(7 downto 0);
	
    component single_cycle_processor is
        port(
            clk : in std_logic;
            rst : in std_logic;
            uart_rx_bit : in std_logic;
            gpio_data : inout std_logic_vector(1 downto 0);
            output : out std_logic_vector(7 downto 0);
            uart_tx_bit : out std_logic);
    end component;
	
	begin
        pulse : process
            begin
                clock <= '1';
                wait for 18518 ps;
                clock <= '0';
                wait for 18519 ps;
        end process;

        reset <= '1', '0' after 37038 ps; 

        uart_rx <= '1';
        
		SCP : single_cycle_processor
			port map (
				clk => clock,
				rst => reset,
                uart_rx_bit => uart_rx,
                gpio_data => gpio_data,
                output => output,
                uart_tx_bit => uart_tx);
end architecture;
