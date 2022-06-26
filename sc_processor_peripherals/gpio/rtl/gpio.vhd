library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity gpio is
    generic(
	    DATA_LENGTH : natural := 32);
	port(
        data_in : in std_logic_vector((DATA_LENGTH-1) downto 0);
        mode : in std_logic_vector((DATA_LENGTH-1) downto 0);
        data : inout std_logic_vector((DATA_LENGTH-1) downto 0);
        data_out : out std_logic_vector((DATA_LENGTH-1) downto 0));
end entity;

architecture dataflow_gpio of gpio is
    begin
        GEN_IO : for I in 0 to (DATA_LENGTH-1) generate
            -- data = output --
            data(I) <= data_in(i) when (mode(I) = '1') else
                       'Z'; 
        end generate;
        -- data = input --
        data_out <= data;
end architecture;
