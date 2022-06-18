library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PERIPHERAL_COMPONENTS is
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

end package;
