library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PIPELINE_COMPONENTS.all;

entity pipeline_processor is
    port(
        clk : in std_logic;
        rst : in std_logic;
        output : out std_logic_vector(31 downto 0));
end entity;

architecture structure_pipeline_processor of
pipeline_processor is
    signal w_alu_selector_1 : std_logic_vector(5 downto 0);
    signal w_branch_1 : std_logic_vector(1 downto 0);
    signal w_branch_3 : std_logic_vector(1 downto 0);
    signal w_epc_we_1 : std_logic;
    signal w_forward_rs_2 : std_logic;
    signal w_forward_rs_3 : std_logic_vector(1 downto 0);
    signal w_forward_rt_2 : std_logic;
    signal w_forward_rt_3 : std_logic_vector(1 downto 0);
    signal w_funct_1 : std_logic_vector(5 downto 0);
    signal w_op_code_1 : std_logic_vector(5 downto 0);
    signal w_has_shamt_1 : std_logic;
    signal w_hi_we_1 : std_logic;
    signal w_instruction_1 : std_logic_vector(31 downto 0);
    signal w_imm_unsig_1 : std_logic;
    signal w_jump_1 : std_logic;
    signal w_jump_logic_1 : std_logic_vector(1 downto 0);
    signal w_jump_r_1 : std_logic;
    signal w_jump_r_3 : std_logic;
    signal w_lo_we_1 : std_logic;
    signal w_lw_1 : std_logic;
    signal w_lw_3 : std_logic;
    signal w_memd_we_1 : std_logic;
    signal w_pc_source_1 : std_logic_vector(2 downto 0);
    signal w_pc_source_p_1 : std_logic_vector(2 downto 0);
    signal w_r_instruction_1 : std_logic;
    signal w_rd_source_1 : std_logic_vector(2 downto 0);
    signal w_register_file_we_1 : std_logic;
    signal w_register_file_we_4 : std_logic;
    signal w_register_file_we_5 : std_logic;
    signal w_rs_2 : std_logic_vector(4 downto 0);
    signal w_rs_3 : std_logic_vector(4 downto 0);
    signal w_rs_rt_compare_3 : std_logic;
    signal w_rst_1_2 : std_logic;
    signal w_rt_2 : std_logic_vector(4 downto 0);
    signal w_rt_3 : std_logic_vector(4 downto 0);
    signal w_stall_1_rst_2 : std_logic;
    signal w_write_address_3 : std_logic_vector(4 downto 0);
    signal w_write_address_4 : std_logic_vector(4 downto 0);
    signal w_write_address_5 : std_logic_vector(4 downto 0);

    begin
        w_branch_3 <= "00";
        w_funct_1 <= w_instruction_1(5 downto 0);
        w_op_code_1 <= w_instruction_1(31 downto 26);
        w_jump_r_3 <= '0';
        w_lw_3 <= '0';
        w_register_file_we_4 <= '0';
        w_register_file_we_5 <= '0';
        w_rs_2 <= "00000";
        w_rs_3 <= "00000";
        w_rs_rt_compare_3 <= '0';
        w_rt_2 <= "00000";
        w_rt_3 <= "00000";
        w_write_address_3 <= "00000";
        w_write_address_4 <= "00000";
        w_write_address_5 <= "00000";

    PC : pipeline_controller
        port map(
            branch_3 => w_branch_3,
            jump_r_3 => w_jump_r_3,
            lw_3 => w_lw_3,
            pc_source_1 => w_pc_source_1,
            register_file_we_4 => w_register_file_we_4,
            register_file_we_5 => w_register_file_we_5,
            rs_2 => w_rs_2,
            rs_3 => w_rs_3,
            rs_rt_compare_3 => w_rs_rt_compare_3,
            rt_2 => w_rt_2,
            rt_3 => w_rt_3,
            write_address_3 => w_write_address_3,
            write_address_4 => w_write_address_4,
            write_address_5 => w_write_address_5,
            forward_rs_2 => w_forward_rs_2,
            forward_rs_3 => w_forward_rs_3,
            forward_rt_2 => w_forward_rt_2,
            forward_rt_3 => w_forward_rt_3,
            jump_logic_1 => w_jump_logic_1,
            pc_source_p_1 => w_pc_source_p_1,
            rst_1_2 => w_rst_1_2,
            stall_1_rst_2 => w_stall_1_rst_2);

        SCD : single_cycle_datapath
            generic map(
                FIRST_INSTRUCTION => 48,
                MEMD_NUMBER_OF_WORDS => 128,
                MEMI_NUMBER_OF_WORDS => 128,
                OUTPUT_ADDR => 255)
            port map(
                alu_selector => w_alu_selector_1,
                clk => clk,
                epc_we => w_epc_we_1,
                has_shamt => w_has_shamt_1,
                hi_we => w_hi_we_1,
                jump => w_jump_1,
                i_instruction => "00",
                lo_we => w_lo_we_1,
                memd_we => w_memd_we_1,
                pc_source => w_pc_source_1,
                r_instruction => w_r_instruction_1,
                rd_source => w_rd_source_1,
                register_file_we => w_register_file_we_1,
                rst => rst,
                instruction => w_instruction_1,
                output => output);
    
        UC : updated_controller
            port map(
                funct => w_funct_1,
                op_code => w_op_code_1,
                alu_selector => w_alu_selector_1,
                branch => w_branch_1,
                epc_we => w_epc_we_1,
                has_shamt => w_has_shamt_1,
                hi_we => w_hi_we_1,
                imm_unsig => w_imm_unsig_1,
                jump => w_jump_1,
                jump_r => w_jump_r_1,
                lo_we => w_lo_we_1,
                lw => w_lw_1,
                memd_we => w_memd_we_1,
                pc_source => w_pc_source_1,
                r_instruction => w_r_instruction_1,
                rd_source => w_rd_source_1,
                register_file_we => w_register_file_we_1);
end architecture;
