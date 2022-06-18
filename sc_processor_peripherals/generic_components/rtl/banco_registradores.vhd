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
 -- generic (
     -- largura_dado : natural range 32 to 32;
     -- largura_ende : natural range 2 to 128;
     -- reset_data_0 : integer range -2147483647 to 2147483647;
     -- reset_data_1 : integer range -2147483647 to 2147483647;
     -- reset_data_2 : integer range -2147483647 to 2147483647;
     -- reset_data_3 : integer range -2147483647 to 2147483647
 -- );

    port (
     -- ent_Rs_ende : in std_logic_vector((largura_ende - 1) downto 0);
     -- ent_Rt_ende : in std_logic_vector((largura_ende - 1) downto 0);
     -- ent_Rd_ende : in std_logic_vector((largura_ende - 1) downto 0);
     -- ent_Rd_dado : in std_logic_vector((largura_dado - 1) downto 0);
     -- sai_Rs_dado : out std_logic_vector((largura_dado - 1) downto 0);
     -- sai_Rt_dado : out std_logic_vector((largura_dado - 1) downto 0);
        ent_Rs_ende : in std_logic_vector(4 downto 0);
        ent_Rt_ende : in std_logic_vector(4 downto 0);
        ent_Rd_ende : in std_logic_vector(4 downto 0);
        ent_Rd_dado : in std_logic_vector(31 downto 0);
        sai_Rs_dado : out std_logic_vector(31 downto 0);
        sai_Rt_dado : out std_logic_vector(31 downto 0);
        clk,WE,rst  : in std_logic
    );
end banco_registradores;

architecture comportamental of banco_registradores is
    constant largura_dado : natural := 32;
    constant largura_ende : natural := 5;
    constant reset_data_0 : integer := 528;
    constant reset_data_1 : integer := 1024;
    constant reset_data_2 : integer := 1024;
    constant reset_data_3 : integer := 0;
    constant number_of_registers : natural := 2**largura_ende;
    type registerfile is array(0 to (number_of_registers - 1)) of std_logic_vector((largura_dado - 1) downto 0);
    signal banco : registerfile;
	signal zero : std_logic_vector((largura_ende-1) downto 0);
	signal clear : std_logic_vector((largura_dado-1) downto 0);
begin
	zero <= (others => '0');
	clear <= (others => '0');

    sai_Rs_dado <= banco(to_integer(unsigned(ent_Rs_ende))) when
                   (ent_Rs_ende /= zero) else
                   (others => '0');
    sai_Rt_dado <= banco(to_integer(unsigned(ent_Rt_ende))) when
                   (ent_Rt_ende /= zero) else
                   (others => '0');

    escrita : process (clk,WE,rst) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                banco <= (
                    (number_of_registers-4) => int2slv(reset_data_0,
                    largura_dado),
                    (number_of_registers-3) => int2slv(reset_data_1,
                    largura_dado),
                    (number_of_registers-2) => int2slv(reset_data_2,
                    largura_dado),
                    (number_of_registers-1) => int2slv(reset_data_3,
                    largura_dado),
                    others => clear);
            elsif WE = '1' then
                banco(to_integer(unsigned(ent_Rd_ende))) <= ent_Rd_dado;
            end if;
        end if;
    end process;
end comportamental;
