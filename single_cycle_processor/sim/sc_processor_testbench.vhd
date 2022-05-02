library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sc_processor_testbench is
end entity;

architecture dataflow_processor_tb of sc_processor_testbench is
	signal clock : std_logic;
	signal reset : std_logic;
	signal output : std_logic_vector(31 downto 0);
	
    component single_cycle_processor is
        port(
            clk : in std_logic;
            rst : in std_logic;
            output : out std_logic_vector(31 downto 0));
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
               
		SCP : single_cycle_processor
			port map (
				clk => clock,
				rst => reset,
                output => output);
end architecture;
