library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pipeline_processor_testbench is
end entity;

architecture dataflow_processor_tb of pipeline_processor_testbench is
	signal clock : std_logic;
	signal reset : std_logic;
	signal output : std_logic_vector(15 downto 0);
	
    component pipeline_processor is
        port(
            clk : in std_logic;
            rst : in std_logic;
            output : out std_logic_vector(15 downto 0));
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
               
		PP : pipeline_processor
			port map (
				clk => clock,
				rst => reset,
                output => output);
end architecture;
