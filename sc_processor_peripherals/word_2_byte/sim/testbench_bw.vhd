library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.GENERIC_FUNCTIONS.int2slv;

entity testbench_bw is
	generic (
			DATA_LENGTH : integer := 32);
end entity;

architecture dataflow_testcench_bw of testbench_bw is
    signal clk : std_logic;
    signal rst : std_logic;
    signal word00 : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal byte01 : std_logic_vector(7 downto 0); 
    signal word12 : std_logic_vector((DATA_LENGTH-1) downto 0); 
    signal byte22 : std_logic_vector(7 downto 0); 
    signal set_word00 : std_logic;
    signal set_byte01 : std_logic;
    signal set_word12 : std_logic;
    signal set_byte22 : std_logic;
    signal shift : std_logic;

    component byte_2_word is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            byte : in std_logic_vector(7 downto 0);
            clk : in std_logic;
            rst : in std_logic;
            set_byte : in std_logic;
            valid_word : out std_logic;
            word : out std_logic_vector((DATA_LENGTH-1) downto 0));
    end component;
	
    component word_2_byte is
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
    end component;
	 
    begin
        B2W : byte_2_word
            generic map(
                DATA_LENGTH => DATA_LENGTH)
            port map(
                byte => byte01,
                clk => clk,
                rst => rst,
                set_byte => set_byte01,
                valid_word => set_word12,
                word => word12);

        W2B1 : word_2_byte
            generic map(
                DATA_LENGTH => DATA_LENGTH)
            port map(
                clk => clk,
                rst => rst,
                set_word => set_word00,
                shift => shift,
                word => word00,
                byte => byte01,
                valid_byte => set_byte01);

        W2B2 : word_2_byte
            generic map(
                DATA_LENGTH => DATA_LENGTH)
            port map(
                clk => clk,
                rst => rst,
                set_word => set_word12,
                shift => shift,
                word => word12,
                byte => byte22,
                valid_byte => set_byte22);

        pulse : process
            begin
                clk <= '1';
                wait for 50 ns;
                clk <= '0';
                wait for 50 ns;
        end process;

        rst <= '1', '0' after 100001 ps;
        set_word00 <= '0', '1' after 100001 ps, '0' after 200001 ps,
        '1' after 500001 ps, '0' after 600001 ps,
        '1' after 2700001 ps, '0' after 2800001 ps;
        word00 <= X"00000000", X"01020304" after 100001 ps,
        X"05060708" after 500001 ps, X"090A0B0C" after 2700001 ps;
        shift <= '1'; 
end architecture;
