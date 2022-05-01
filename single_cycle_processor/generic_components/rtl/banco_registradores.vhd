-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletronica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Banco de registradores com entradas e saída de dados de tamanho genérico
-- entradas de endereço de tamanho genérico
-- clock e sinal de WE
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.GENERIC_FUNCTIONS.int2slv;

entity banco_registradores is
    generic (
        largura_dado : natural;
        largura_ende : natural;
        reset_data_0 : integer;
        reset_data_1 : integer;
        reset_data_2 : integer;
        reset_data_3 : integer
    );

    port (
        ent_Rs_ende : in std_logic_vector((largura_ende - 1) downto 0);
        ent_Rt_ende : in std_logic_vector((largura_ende - 1) downto 0);
        ent_Rd_ende : in std_logic_vector((largura_ende - 1) downto 0);
        ent_Rd_dado : in std_logic_vector((largura_dado - 1) downto 0);
        sai_Rs_dado : out std_logic_vector((largura_dado - 1) downto 0);
        sai_Rt_dado : out std_logic_vector((largura_dado - 1) downto 0);
        clk,WE,rst  : in std_logic
    );
end banco_registradores;

architecture comportamental of banco_registradores is
    type registerfile is array(0 to ((2 ** largura_ende) - 1)) of std_logic_vector((largura_dado - 1) downto 0);
    signal banco : registerfile;
	signal zero : std_logic_vector((largura_ende-1) downto 0);
begin
	zero <= (others => '0');

    sai_Rs_dado <= banco(to_integer(unsigned(ent_Rs_ende))) when
                   (ent_Rs_ende = zero) else
                   (others => '0');
    sai_Rt_dado <= banco(to_integer(unsigned(ent_Rt_ende))) when
                   (ent_Rt_ende = zero) else
                   (others => '0');

    escrita : process (clk,WE,rst) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                banco(0) <= (others => '0');
                banco(1) <= (others => '0');
                banco(2) <= (others => '0');
                banco(3) <= (others => '0');
                banco(4) <= (others => '0');
                banco(5) <= (others => '0');
                banco(6) <= (others => '0');
                banco(7) <= (others => '0');
                banco(8) <= (others => '0');
                banco(9) <= (others => '0');
                banco(10) <= (others => '0');
                banco(11) <= (others => '0');
                banco(12) <= (others => '0');
                banco(13) <= (others => '0');
                banco(14) <= (others => '0');
                banco(15) <= (others => '0');
                banco(16) <= (others => '0');
                banco(17) <= (others => '0');
                banco(18) <= (others => '0');
                banco(19) <= (others => '0');
                banco(20) <= (others => '0');
                banco(21) <= (others => '0');
                banco(22) <= (others => '0');
                banco(23) <= (others => '0');
                banco(24) <= (others => '0');
                banco(25) <= (others => '0');
                banco(26) <= (others => '0');
                banco(27) <= (others => '0');
                banco(28) <= int2slv(reset_data_0,largura_dado);
                banco(29) <= int2slv(reset_data_1,largura_dado);
                banco(30) <= int2slv(reset_data_2,largura_dado);
                banco(31) <= int2slv(reset_data_3,largura_dado);
            elsif WE = '1' then
                banco(to_integer(unsigned(ent_Rd_ende))) <= ent_Rd_dado;
            end if;
        end if;
    end process;
end comportamental;
