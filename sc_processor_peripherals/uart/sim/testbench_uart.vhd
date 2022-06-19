library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.GENERIC_FUNCTIONS.int2slv;

entity testbench_uart is
	generic (
			MAX_LENGTH : integer := 32);
end entity;

architecture dataflow_testbench_uart of testbench_uart is
    signal rst : std_logic;
    signal send : std_logic;
    signal byte00 : std_logic_vector(7 downto 0); 
    signal clk0 : std_logic;
    signal ready : std_logic;
    signal bit01 : std_logic;
    signal clk1 : std_logic;
    signal recv : std_logic;
    signal byte11 : std_logic_vector(7 downto 0); 

    component uart_rx is
        generic(
            MAX_LENGTH : natural := 32);
        port(
            clk : in std_logic;
            clk_ticks : in std_logic_vector((MAX_LENGTH-1) downto 0); 
            data_bit : in std_logic;
            rst : in std_logic;
            byte : out std_logic_vector(7 downto 0);
            recv : out std_logic);
    end component;

    component uart_tx is
        generic(
            MAX_LENGTH : natural := 32);
        port(
            byte : in std_logic_vector(7 downto 0); 
            clk : in std_logic;
            clk_ticks : in std_logic_vector((MAX_LENGTH-1) downto 0);
            rst : in std_logic;
            send : in std_logic;
            data_bit : out std_logic;
            ready : out std_logic);
    end component;
 
    begin
        TX : uart_tx
            generic map(
                MAX_LENGTH => MAX_LENGTH)
            port map(
                byte => byte00,
                clk => clk0,
                clk_ticks => X"00000003",
                rst => rst,
                send => send,
                data_bit => bit01,
                ready => ready);

        RX : uart_rx
            generic map(
                MAX_LENGTH => MAX_LENGTH)
            port map(
                clk => clk1,
                clk_ticks => X"00000000",
                data_bit => bit01,
                rst => rst,
                byte => byte11,
                recv => recv);

        pulse : process
            begin
                clk0 <= '1';
                clk1 <= '0';
                wait for 50 ns;
                clk0 <= '0';
                clk1 <= '1';
                wait for 50 ns;
                clk0 <= '1';
                clk1 <= '1';
                wait for 50 ns;
                clk0 <= '0';
                clk1 <= '1';
                wait for 50 ns;
                clk0 <= '1';
                clk1 <= '1';
                wait for 50 ns;
                clk0 <= '0';
                clk1 <= '0';
                wait for 50 ns;
                clk0 <= '1';
                clk1 <= '0';
                wait for 50 ns;
                clk0 <= '0';
                clk1 <= '0';
                wait for 50 ns;
        end process;

        rst <= '1', '0' after 400001 ps;
        send <= '0', '1' after 400001 ps, '0' after 500001 ps,
        '1' after 4800001 ps, '0' after 4900001 ps,
        '1' after 10400001 ps, '0' after 10500001 ps;
        byte00 <= "00000000", "01010101" after 400001 ps,
        "00100011" after 4800001 ps, "00001111" after 10400001 ps; 
end architecture;
