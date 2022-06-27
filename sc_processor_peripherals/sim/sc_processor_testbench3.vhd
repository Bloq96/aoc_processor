library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sc_processor_testbench is
end entity;

architecture dataflow_processor_tb of sc_processor_testbench is
	signal clock : std_logic;
	signal gpio_data_0 : std_logic_vector(1 downto 0);
	signal gpio_data_1 : std_logic_vector(1 downto 0);
	signal reset : std_logic;
    signal uart_0 : std_logic;
    signal uart_1 : std_logic;
	signal output_0 : std_logic_vector(31 downto 0);
	signal output_1 : std_logic_vector(31 downto 0);
	
    component single_cycle_processor is
        port(
            clk : in std_logic;
            rst : in std_logic;
            uart_rx_bit : in std_logic;
            gpio_data : inout std_logic_vector(1 downto 0);
            output : out std_logic_vector(31 downto 0);
            uart_tx_bit : out std_logic);
    end component;
	
	begin
        pulse : process
            begin
                clock <= '1';
                wait for 50 ns;
                clock <= '0';
                wait for 50 ns;
        end process;

        reset <= '1', '0' after 100001 ps; 
        
		SCP0 : single_cycle_processor
			port map (
				clk => clock,
				rst => reset,
                uart_rx_bit => uart_1,
                gpio_data => gpio_data_0,
                output => output_0,
                uart_tx_bit => uart_0);
        
		SCP1 : single_cycle_processor
			port map (
				clk => clock,
				rst => reset,
                uart_rx_bit => uart_0,
                gpio_data => gpio_data_1,
                output => output_1,
                uart_tx_bit => uart_1);
        
        gpio_data_0 <= "Z0", "Z1" after 543241 ps,
        "Z0" after 6423342 ps, "Z1" after 23565386 ps; 
        gpio_data_1 <= "Z0", "Z1" after 543241 ps,
        "Z0" after 6423342 ps, "Z1" after 23565386 ps; 
end architecture;
