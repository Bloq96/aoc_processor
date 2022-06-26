library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PERIPHERAL_COMPONENTS is
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

    component gpio is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            data_in : in std_logic_vector((DATA_LENGTH-1) downto 0);
            mode : in std_logic_vector((DATA_LENGTH-1) downto 0);
            data : inout std_logic_vector((DATA_LENGTH-1) downto 0);
            data_out : out std_logic_vector((DATA_LENGTH-1) downto 0));
    end component;

    component timer is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            clk : in std_logic;
            clk_division : in std_logic_vector((DATA_LENGTH-1) downto 0); 
            count : in std_logic;
            max_count : in std_logic_vector((DATA_LENGTH-1) downto 0); 
            rst : in std_logic;
            set : in std_logic;
            value_division : out std_logic_vector((DATA_LENGTH-1) downto 0); 
            value_count : out std_logic_vector((DATA_LENGTH-1) downto 0); 
            reset : out std_logic);
    end component;

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

    component up_counter is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            clk : in std_logic;
            count : in std_logic;
            max_count : in std_logic_vector((DATA_LENGTH-1) downto 0);
            rst : in std_logic;
            set : in std_logic;
            value : out std_logic_vector((DATA_LENGTH-1) downto 0);
            reset : out std_logic);
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
end package;
