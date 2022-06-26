library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity testbench_gpio is
	generic (
		DATA_LENGTH : integer := 2);
end entity;

architecture dataflow_testbench_gpio of testbench_gpio is
    signal data_in : std_logic_vector((DATA_LENGTH-1) downto 0);
    signal mode : std_logic_vector((DATA_LENGTH-1) downto 0);
    signal data : std_logic_vector((DATA_LENGTH-1) downto 0);
    signal data_out : std_logic_vector((DATA_LENGTH-1) downto 0);

    component gpio is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            data_in : in std_logic_vector((DATA_LENGTH-1) downto 0);
            mode : in std_logic_vector((DATA_LENGTH-1) downto 0);
            data : inout std_logic_vector((DATA_LENGTH-1) downto 0);
            data_out : out std_logic_vector((DATA_LENGTH-1) downto 0));
    end component;

    begin
        GPIO0 : gpio
            generic map(
                DATA_LENGTH => DATA_LENGTH)
            port map(
                data_in => data_in, 
                mode => mode,
                data => data,
                data_out => data_out);
        PULSE : process
            begin
                data_in <= "00";
                wait for 100001 ps;
                data_in <= "01";
                wait for 100001 ps;
                data_in <= "10";
                wait for 100001 ps;
                data_in <= "11";
                wait for 100001 ps;
        end process;
        mode <= "00", "01" after 1000001 ps, "10" after 2000001 ps, 
        "11" after 3000001 ps;
        data <= "01", "0Z" after 1000001 ps, "Z1" after 2000001 ps,
        "ZZ" after 3000001 ps;
end architecture;
