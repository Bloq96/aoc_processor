library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PIPELINE_COMPONENTS is
    component updated_controller is
        port(
            funct : in std_logic_vector(5 downto 0);
            op_code : in std_logic_vector(5 downto 0);
            alu_selector : out std_logic_vector(5 downto 0);
            branch : out std_logic_vector(1 downto 0);
            epc_we : out std_logic;
            has_shamt : out std_logic;
            hi_we : out std_logic;
            imm_unsig : out std_logic;
            jump : out std_logic;
            jump_r : out std_logic;
            lo_we : out std_logic;
            lw : out std_logic;
            memd_we : out std_logic;
            pc_source : out std_logic_vector(2 downto 0);
            r_instruction : out std_logic;
            rd_source : out std_logic_vector(2 downto 0);
            register_file_we : out std_logic);
    end component;

component single_cycle_datapath is
        generic(
            FIRST_INSTRUCTION : natural;
            MEMD_NUMBER_OF_WORDS : natural;
            MEMI_NUMBER_OF_WORDS : natural;
            OUTPUT_ADDR : natural);
        port(
            alu_selector : in std_logic_vector(5 downto 0);
            clk : in std_logic;
            epc_we : in std_logic;
            has_shamt : in std_logic;
            hi_we : in std_logic;
            i_instruction : in std_logic_vector(1 downto 0);
            jump : in std_logic;
            lo_we : in std_logic;
            memd_we : in std_logic;
            pc_source : in std_logic_vector(2 downto 0);
            r_instruction : in std_logic;
            rd_source : in std_logic_vector(2 downto 0);
            register_file_we : in std_logic;
            rst : in std_logic;
            instruction : out std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0));
        end component;

end package;
