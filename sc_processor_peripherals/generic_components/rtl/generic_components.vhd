library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package GENERIC_COMPONENTS is
    component banco_registradores is
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
    component interrupt_controller is
        generic(
            ADDRESS_LENGTH : natural;
            INTERRUPTION_CHANNELS : natural);
        port(
            addresses : in std_logic_vector(((ADDRESS_LENGTH*
            INTERRUPTION_CHANNELS)-1) downto 0);
            break : in std_logic;
            clk : in std_logic;
            interruptions : in std_logic_vector((INTERRUPTION_CHANNELS
            -1) downto 0);
            interruptions_to_enable : in std_logic_vector(
            (INTERRUPTION_CHANNELS-1) downto 0);
            rst : in std_logic;
            interruptions_enabled : out std_logic_vector(
            INTERRUPTION_CHANNELS downto 0);
            interruption_flags : out std_logic_vector(
            (INTERRUPTION_CHANNELS-1) downto 0);
            jump_address : out std_logic_vector(
            (ADDRESS_LENGTH-1) downto 0));
    end component;
    component memd is
        generic (
            number_of_words : natural;
            MD_DATA_WIDTH   : natural;
            MD_ADDR_WIDTH   : natural;
            OUTPUT_ADDR     : natural
        );
        port (
            clk              : in std_logic;
         -- mem_read         : in std_logic; --sinais do controlador
            mem_write        : in std_logic; --sinais do controlador 
            write_data_mem   : in std_logic_vector(MD_DATA_WIDTH - 1
            downto 0);
            address_mem      : in std_logic_vector(MD_ADDR_WIDTH - 1
            downto 0);
            output           : out std_logic_vector(MD_DATA_WIDTH - 1
            downto 0);
            read_data_mem    : out std_logic_vector(MD_DATA_WIDTH - 1
            downto 0)
        );
    end component;
    component memi is
        generic (
            INSTR_WIDTH   : natural;
            MI_ADDR_WIDTH : natural
        );
        port (
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
