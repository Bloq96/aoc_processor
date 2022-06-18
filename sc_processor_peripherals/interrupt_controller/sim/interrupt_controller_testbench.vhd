library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity interrupt_controller_testbench is
    generic(
        ADDRESS_LENGTH : natural := 4;
        INTERRUPTION_CHANNELS : natural := 8);
end entity;

architecture dataflow_ic_testbench of interrupt_controller_testbench is
    signal break : std_logic;
	signal clk : std_logic;
    signal interruptions : std_logic_vector((INTERRUPTION_CHANNELS-1)
    downto 0);
	signal rst : std_logic;
    signal interruptions_enabled : std_logic_vector(
    INTERRUPTION_CHANNELS downto 0);
    signal interruption_flags : std_logic_vector(
    (INTERRUPTION_CHANNELS-1) downto 0);
    signal jump_address : std_logic_vector(
    (ADDRESS_LENGTH-1) downto 0);
	
    component interrupt_controller is
        generic(
            ADDRESS_LENGTH : natural;
            INTERRUPTION_CHANNELS : natural);
        port(
            addresses : in std_logic_vector(((ADDRESS_LENGTH*
            INTERRUPTION_CHANNELS)-1) downto 0);
            break : in std_logic;
            clk : in std_logic;
            interruptions : in std_logic_vector(
            (INTERRUPTION_CHANNELS-1) downto 0);
            interruptions_to_enable : in std_logic_vector(
            (INTERRUPTION_CHANNELS-1) downto 0);
            rst : in std_logic;
            interruptions_enabled : out std_logic_vector(
            INTERRUPTION_CHANNELS downto 0);
            interruption_flags : out std_logic_vector(
            (INTERRUPTION_CHANNELS-1) downto 0);
            jump_address : out std_logic_vector(
            (ADDRESS_LENGTH-1) downto 0));
    end component;
	
	begin
        pulse : process
            begin
                clk <= '1';
                wait for 50 ns;
                clk <= '0';
                wait for 50 ns;
        end process;

        rst <= '1', '0' after 100001 ps;   
               
		IC : interrupt_controller
            generic map (
                ADDRESS_LENGTH => ADDRESS_LENGTH,
                INTERRUPTION_CHANNELS => INTERRUPTION_CHANNELS)
			port map (
                addresses => X"87654321",
				break => break,
				clk => clk,
				interruptions => interruptions,
				interruptions_to_enable => "10011111",
				rst => rst,
				interruptions_enabled => interruptions_enabled,
				interruption_flags => interruption_flags,
                jump_address => jump_address);
        
        break <= '0', '1' after 300001 ps, '0' after 400001 ps,
                 '1' after 600001 ps, '0' after 700001 ps,
                 '1' after 900001 ps, '0' after 1000001 ps,
                 '1' after 1200001 ps, '0' after 1300001 ps,
                 '1' after 1500001 ps, '0' after 1600001 ps,
                 '1' after 1800001 ps, '0' after 1900001 ps,
                 '1' after 2200001 ps, '0' after 2300001 ps;
        interruptions <= "00000001", "00000010" after 200001 ps,
                         "00000110" after 400001 ps,
                         "00000010" after 500001 ps,
                         "00001000" after 900001 ps,
                         "00011000" after 1200001 ps,
                         "00100000" after 1500001 ps,
                         "01100000" after 1800001 ps,
                         "10000000" after 2000001 ps,
                         "00000000" after 2300001 ps;
end architecture;
