library IEEE;
use IEEE.MATH_REAL.ceil;
use IEEE.MATH_REAL.log2;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;
library work;

package GENERIC_FUNCTIONS is
	function bool2sl(bool: boolean) return std_logic;
    function ceil_division(A, B: natural) return natural;
    function ceil_log_2(N: natural) return natural;
	function int2slv(int: integer; WORD_LENGTH: natural)
    return std_logic_vector;
    function reductive_and(input: std_logic_vector) return std_logic;
    function reductive_or(input: std_logic_vector) return std_logic;
	function slv2int(slv: std_logic_vector) return integer;
	function slv2nat(slv: std_logic_vector) return natural;
end package GENERIC_FUNCTIONS;

package body GENERIC_FUNCTIONS is    
    function bool2sl(bool: boolean) return std_logic is
	    begin
		    if (bool) then
                return '1';
            else
                return '0';
            end if;
	end function;

    function ceil_division(A, B: natural) return natural is
	    begin
		    return integer(ceil(real(A)/real(B)));
	end;

    function ceil_log_2(N: natural) return natural is
	    begin
		    return integer(ceil(log2(real(N))));
    end;
	 
    function int2slv(int: integer; WORD_LENGTH: natural)
    return std_logic_vector is
	    begin
		    return (std_logic_vector(to_signed(int, WORD_LENGTH)));
	end function;

    function max(A, B: integer) return integer is
        begin
		    if (A > B) then
			    return A;
		    else
			    return B;
		    end if;
	end;

    function reductive_and (input : std_logic_vector) return std_logic
    is
        variable result : std_logic := '1';
        begin
            for it in input'range loop
                result := result and input(it);
            end loop;
            return result;
    end function;

    function reductive_or (input : std_logic_vector) return std_logic
    is
        variable result : std_logic := '0';
        begin
            for it in input'range loop
                result := result or input(it);
            end loop;
            return result;
    end function;
	 
    function slv2int(slv: std_logic_vector) return integer is
	    begin
		    return to_integer(signed(slv));
	end function;
	 
    function slv2nat(slv: std_logic_vector) return natural is
	    begin
		    return to_integer(unsigned(slv));
	end function;
end package body GENERIC_FUNCTIONS;
