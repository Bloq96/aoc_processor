library ieee;
use ieee.std_logic_1164.all;

package ALU_COMPONENTS is
    component extended_alu is
        generic(
            DATA_LENGTH : natural := 32);
        port(
            input_a : in std_logic_vector((DATA_LENGTH-1) downto 0);
            input_b : in std_logic_vector((DATA_LENGTH-1) downto 0);
            selector : in std_logic_vector(5 downto 0);
            output_a : out std_logic_vector((DATA_LENGTH-1) downto 0);
            output_b : out std_logic_vector((DATA_LENGTH-1) downto 0);
            zero : out std_logic);
    end component;
end package;
