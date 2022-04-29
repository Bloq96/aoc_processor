library IEEE;
use IEEE.STD_LOGIC_1164.all;

package GENERIC_TYPES is
    type std_logic_vector_array is array (natural range <>) of std_logic_vector;
    type integer_array is array (natural range <>) of integer;
end package GENERIC_TYPES;
