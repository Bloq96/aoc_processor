library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.GENERIC_COMPONENTS.integer_divider;
use work.GENERIC_COMPONENTS.multiplicador;
use work.GENERIC_COMPONENTS.ula;
use work.GENERIC_FUNCTIONS.reductive_or;
use work.GENERIC_FUNCTIONS.slv2nat;

entity extended_alu is
    generic(
	    DATA_LENGTH : natural := 32);
	port(
        input_a : in std_logic_vector((DATA_LENGTH-1) downto 0); 
        input_b : in std_logic_vector((DATA_LENGTH-1) downto 0); 
        selector : in std_logic_vector(5 downto 0);
        output_a : out std_logic_vector((DATA_LENGTH-1) downto 0); 
        output_b : out std_logic_vector((DATA_LENGTH-1) downto 0); 
        zero : out std_logic);
end entity;

architecture structure_extended_alu of extended_alu is
    signal alu_carry_in : std_logic;
    signal alu_carry_out : std_logic_vector((DATA_LENGTH-1)downto 0);
    signal alu_input_b : std_logic_vector((DATA_LENGTH-1)downto 0);
    signal alu_output : std_logic_vector((DATA_LENGTH-1)downto 0);
    signal div_output : std_logic_vector((2*DATA_LENGTH-1)downto 0);
    signal first_output : std_logic_vector((DATA_LENGTH-1)downto 0);
    signal mult_div_alu_output : std_logic_vector((DATA_LENGTH-1)
    downto 0);
    signal mult_div_output : std_logic_vector((2*DATA_LENGTH-1) downto
    0);
    signal mult_div_shift_output : std_logic_vector((DATA_LENGTH-1)
    downto 0);
    signal mult_output : std_logic_vector((2*DATA_LENGTH-1)downto 0);
    signal second_output : std_logic_vector((DATA_LENGTH-1)downto 0);
    signal shift_output : std_logic_vector((DATA_LENGTH-1)downto 0);
    signal sub_input : std_logic_vector((DATA_LENGTH-1)downto 0);
    signal sub_op : std_logic;

    begin
        ALU0 : ula
            generic map(
                largura_dado => DATA_LENGTH)
            port map(
                carry_in => alu_carry_in,
                entrada_a => input_a,
                entrada_b => alu_input_b,
                seletor => selector(2 downto 0),
                carry_out => alu_carry_out(0),
                saida => alu_output);

        DIV0 : integer_divider
            generic map(
                DATA_LENGTH => DATA_LENGTH)
            port map(
                input_a => input_a(11 downto 0),
                input_b => input_b(9 downto 0),
                quotient => div_output((DATA_LENGTH-1) downto 0), 
                remainder => div_output((2*DATA_LENGTH-1) downto DATA_LENGTH)); 
	
        MULT0 : multiplicador
            generic map(
                largura_dado => DATA_LENGTH)
            port map(
                entrada_a => input_a,
                entrada_b => input_b,
                saida => mult_output); 
	
        alu_carry_in <= sub_op; 
        alu_carry_out((DATA_LENGTH-1) downto 1) <= (others => '0'); 
        alu_input_b <= sub_input when (sub_op = '1') else
                       input_b;
        first_output <= alu_output when (selector(5) = '1') else
                        mult_div_shift_output;
        mult_div_alu_output <= alu_carry_out when (selector(5) = '1')
                               else
                               mult_div_output((2*DATA_LENGTH-1)
                               downto DATA_LENGTH);
        mult_div_output <= div_output when (selector(1) = '1') else
                           mult_output;
        mult_div_shift_output <= mult_div_output((DATA_LENGTH-1)
                                 downto 0) when (selector(4) = '1')
                                 else
                                 shift_output;
        shift_output <= std_logic_vector(shift_right(signed(input_b),
                        slv2nat(input_a))) when
                        ((selector(1) and selector(0)) = '1') else
                        std_logic_vector(shift_left(signed(input_b),
						slv2nat(input_a)));
        sub_input <= not(input_b); 
        sub_op <= not(selector(4)) and not(selector(2)) and
        selector(1) and not(selector(0));
        second_output <= mult_div_alu_output when 
                         ((selector(5) or selector(4)) = '1') else
                         (others => '0');

        output_a <= first_output;
        output_b <= second_output;
        zero <= not(reductive_or(first_output) or
        reductive_or(second_output));
end architecture;
