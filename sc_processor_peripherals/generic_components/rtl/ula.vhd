-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Unidade Lógica e Aritmética com capacidade para 8 operações distintas, além de entradas e saída de dados genérica.
-- Os três bits que selecionam o tipo de operação da ULA são os 3 bits menos significativos do OPCODE (vide aqrquivo: par.xls)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    generic (
        largura_dado : natural
    );

    port (
        carry_in : in std_logic;
        entrada_a : in std_logic_vector((largura_dado - 1) downto 0);
        entrada_b : in std_logic_vector((largura_dado - 1) downto 0);
        seletor   : in std_logic_vector(2 downto 0);
        carry_out : out std_logic;
        saida     : out std_logic_vector((largura_dado - 1) downto 0)
    );
end ula;

architecture comportamental of ula is
    signal resultado_ula : std_logic_vector(largura_dado downto 0);
    signal carry_vector : std_logic_vector(largura_dado downto 0);

begin
    process (carry_vector, entrada_a, entrada_b, seletor) is
    begin
        case(seletor) is
            when "001" => -- not lógico
            resultado_ula <= '0' & not(entrada_a);
         -- when "001" => -- soma estendida
         -- resultado_ula <= std_logic_vector(signed('0'&entrada_a) +
         -- signed('0'&entrada_b));
            when "011" => -- xnor lógico
            resultado_ula <= '0' & (entrada_a xnor entrada_b);
            when "100" => -- and lógico
            resultado_ula <= '0' & (entrada_a and entrada_b);
            when "101" => -- or lógico
            resultado_ula <= '0' & (entrada_a or entrada_b);
            when "110" => -- xor lógico
            resultado_ula <= '0' & (entrada_a xor entrada_b);
            when "111" => -- nor lógico
            resultado_ula <= '0' & (entrada_a nor entrada_b);
            when others => -- soma com sinal
            resultado_ula <= std_logic_vector(
            signed(entrada_a(largura_dado-1)&entrada_a) +
            signed(entrada_b(largura_dado-1)&entrada_b) +
            signed(carry_vector));
        end case;
    end process;
    
    carry_vector <= (0=>carry_in,others=>'0');
    carry_out <= resultado_ula(largura_dado);
    saida <= resultado_ula((largura_dado-1) downto 0);
end comportamental;
