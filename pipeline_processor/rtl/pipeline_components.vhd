library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PIPELINE_COMPONENTS is
    component pipeline_controller is
        port(
            branch_3 : in std_logic_vector(1 downto 0);
            jump_r_3 : in std_logic;
            lw_3 : in std_logic;
            pc_source_1 : in std_logic_vector(2 downto 0);
            register_file_we_4 : in std_logic;
            register_file_we_5 : in std_logic;
            rs_2 : in std_logic_vector(4 downto 0);
            rs_3 : in std_logic_vector(4 downto 0);
            rs_rt_compare_3 : in std_logic;
            rt_2 : in std_logic_vector(4 downto 0);
            rt_3 : in std_logic_vector(4 downto 0);
            write_address_3 : in std_logic_vector(4 downto 0);
            write_address_4 : in std_logic_vector(4 downto 0);
            write_address_5 : in std_logic_vector(4 downto 0);
            forward_rs_2 : out std_logic;
            forward_rs_3 : out std_logic_vector(1 downto 0);
            forward_rt_2 : out std_logic;
            forward_rt_3 : out std_logic_vector(1 downto 0);
            pc_source_p_1 : out std_logic_vector(2 downto 0);
            rst_1_2 : out std_logic;
            stall_1_rst_2 : out std_logic);
    end component;

    component pipeline_datapath is
        generic(
            FIRST_INSTRUCTION : natural;
            MEMD_NUMBER_OF_WORDS : natural;
            MEMI_NUMBER_OF_WORDS : natural;
            OUTPUT_ADDR : natural);
        port(
            alu_selector_1 : in std_logic_vector(5 downto 0);
            branch_1 : in std_logic_vector(1 downto 0);
            clk : in std_logic;
            epc_we_1 : in std_logic;
            forward_rs_2 : in std_logic;
            forward_rs_3 : in std_logic_vector(1 downto 0);
            forward_rt_2 : in std_logic;
            forward_rt_3 : in std_logic_vector(1 downto 0);
            has_shamt_1 : in std_logic;
            hi_we_1 : in std_logic;
            imm_unsig_1 : in std_logic;
            jump_1 : in std_logic;
            jump_r_1 : in std_logic;
            lo_we_1 : in std_logic;
            lw_1 : in std_logic;
            memd_we_1 : in std_logic;
            pc_source_1 : in std_logic_vector(2 downto 0);
            r_instruction_1 : in std_logic;
            rd_source_1 : in std_logic_vector(2 downto 0);
            register_file_we_1 : in std_logic;
            rst : in std_logic;
            rst_1_2 : in std_logic;
            stall_1_rst_2 : in std_logic;
            branch_3 : out std_logic_vector(1 downto 0);
            funct_1 : out std_logic_vector(5 downto 0);
            jump_r_3 : out std_logic;
            lw_3 : out std_logic;
            op_code_1 : out std_logic_vector(5 downto 0);
            output : out std_logic_vector(15 downto 0);
            register_file_we_4 : out std_logic;
            register_file_we_5 : out std_logic;
            rs_2 : out std_logic_vector(4 downto 0);
            rs_3 : out std_logic_vector(4 downto 0);
            rs_rt_compare_3 : out std_logic;
            rt_2 : out std_logic_vector(4 downto 0);
            rt_3 : out std_logic_vector(4 downto 0);
            write_address_3 : out std_logic_vector(4 downto 0);
            write_address_4 : out std_logic_vector(4 downto 0);
            write_address_5 : out std_logic_vector(4 downto 0));
    end component;

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
end package;
