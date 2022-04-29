library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package GENERIC_COMPONENTS is
    component banco_registradores is
        generic (
            largura_dado : natural;
            largura_ende : natural);
        port (
            ent_Rs_ende : in std_logic_vector((largura_ende - 1) downto
            0);
            ent_Rt_ende : in std_logic_vector((largura_ende - 1) downto
            0);
            ent_Rd_ende : in std_logic_vector((largura_ende - 1) downto
            0);
            ent_Rd_dado : in std_logic_vector((largura_dado - 1) downto
            0);
            sai_Rs_dado : out std_logic_vector((largura_dado - 1) downto
            0);
            sai_Rt_dado : out std_logic_vector((largura_dado - 1) downto
            0);
            clk, WE     : in std_logic);
    end component;
    component deslocador is
        generic (
            largura_dado : natural;
            largura_qtde : natural
        );
        port (
            ent_rs_dado           : in std_logic_vector(
            (largura_dado - 1) downto 0);
            ent_rt_ende           : in std_logic_vector(
            (largura_qtde - 1) downto 0);
            ent_tipo_deslocamento : in std_logic_vector(1 downto 0);
            sai_rd_dado           : out std_logic_vector(
            (largura_dado - 1) downto 0)
        );
    end component;
    component integer_divider is
        generic(
            DATA_LENGTH : natural);
        port(
            input_a : in std_logic_vector(11 downto 0);
            input_b : in std_logic_vector(9 downto 0);
            quotient : out std_logic_vector((DATA_LENGTH-1) downto 0);
            remainder : out std_logic_vector((DATA_LENGTH-1) downto 0));
    end component;
    component extensor is
        generic (
            largura_dado  : natural;
            largura_saida : natural
        );
        port (
            entrada_Rs : in std_logic_vector((largura_dado - 1)
            downto 0);
            saida      : out std_logic_vector((largura_saida - 1)
            downto 0)
        );
    end component;
    component memd is
        generic (
            number_of_words : natural;
            MD_DATA_WIDTH   : natural;
            MD_ADDR_WIDTH   : natural
        );
        port (
            clk                 : in std_logic;
            mem_write, mem_read : in std_logic;
            write_data_mem      : in std_logic_vector(
            MD_DATA_WIDTH - 1 downto 0);
            address_mem          : in std_logic_vector(
            MD_ADDR_WIDTH - 1 downto 0);
            read_data_mem       : out std_logic_vector(
            MD_DATA_WIDTH - 1 downto 0)
        );
    end component;
    component memi is
        generic (
            INSTR_WIDTH   : natural;
            MI_ADDR_WIDTH : natural
        );
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            Endereco  : in std_logic_vector(MI_ADDR_WIDTH - 1
            downto 0);
            Instrucao : out std_logic_vector(INSTR_WIDTH - 1
            downto 0)
        );
    end component;
    component multiplicador is
        generic (
            largura_dado : natural
         );

        port (
            entrada_a : in std_logic_vector((largura_dado - 1) downto
            0);
            entrada_b : in std_logic_vector((largura_dado - 1) downto
            0);
            saida     : out std_logic_vector((2 * largura_dado - 1)
            downto 0)
        );
    end component;
    component mux21 is
        generic (
            largura_dado : natural
            );
        port (
            dado_ent_0, dado_ent_1 : in std_logic_vector(
            (largura_dado - 1) downto 0);
            sele_ent               : in std_logic;
            dado_sai               : out std_logic_vector(
            (largura_dado - 1) downto 0)
        );
    end component;
    component mux41 is
        generic (
            largura_dado : natural
        );
        port (
            dado_ent_0, dado_ent_1, dado_ent_2, dado_ent_3 : in
            std_logic_vector((largura_dado - 1) downto 0);
            sele_ent                                       : in
            std_logic_vector(1 downto 0);
            dado_sai                                       : out
            std_logic_vector((largura_dado - 1) downto 0)
        );
    end component;
    component pc is
        generic (
            PC_WIDTH : natural -- tamanho de PC em bits (complete)
        );
        port (
            entrada : in std_logic_vector (PC_WIDTH - 1 downto 0);
            saida   : out std_logic_vector(PC_WIDTH - 1 downto 0);
            clk     : in std_logic;
            we      : in std_logic;
            reset   : in std_logic
        );
    end component;
    component registrador is
        generic (
            largura_dado : natural
        );
        port (
            entrada_dados  : in std_logic_vector((largura_dado - 1)
            downto 0);
            WE, clk, reset : in std_logic;
            saida_dados    : out std_logic_vector((largura_dado - 1)
            downto 0)
        );
    end component;
    component somador is
        generic (
            largura_dado : natural
        );
        port (
            entrada_a : in std_logic_vector((largura_dado - 1) downto
            0);
            entrada_b : in std_logic_vector((largura_dado - 1) downto
            0);
            saida     : out std_logic_vector((largura_dado - 1) downto
            0)
        );
    end component;
    component ula is
        generic (
            largura_dado : natural
        );

        port (
            carry_in : in std_logic;
            entrada_a : in std_logic_vector((largura_dado - 1) downto
            0);
            entrada_b : in std_logic_vector((largura_dado - 1) downto
            0);
            seletor   : in std_logic_vector(2 downto 0);
            carry_out : out std_logic;
            saida     : out std_logic_vector((largura_dado - 1) downto
            0)
        );
    end component;
end package GENERIC_COMPONENTS;
