library ieee;
use ieee.std_logic_1164.all;

library work;
use work.SINGLE_CYCLE_COMPONENTS.all;

entity pipeline_processor is
    port(
        clk : in std_logic;
        rst : in std_logic;
        output : out std_logic_vector(31 downto 0));
end entity;

architecture structure_pipeline_processor of
pipeline_processor is
    signal w_alu_selector : std_logic_vector(5 downto 0);
    signal w_epc_we : std_logic;
    signal w_has_shamt : std_logic;
    signal w_hi_we : std_logic;
    signal w_instruction : std_logic_vector(31 downto 0);
    signal w_i_instruction : std_logic_vector(1 downto 0);
    signal w_jump : std_logic;
    signal w_lo_we : std_logic;
    signal w_memd_we : std_logic;
    signal w_pc_source : std_logic_vector(2 downto 0);
    signal w_r_instruction : std_logic;
    signal w_rd_source : std_logic_vector(2 downto 0);
    signal w_register_file_we : std_logic;

    begin
        SCC : single_cycle_controller
            port map(
                instruction => w_instruction,
                alu_selector => w_alu_selector,
                epc_we => w_epc_we,
                has_shamt => w_has_shamt,
                hi_we => w_hi_we,
                i_instruction => w_i_instruction,
                jump => w_jump,
                lo_we => w_lo_we,
                memd_we => w_memd_we,
                pc_source => w_pc_source,
                r_instruction => w_r_instruction,
                rd_source => w_rd_source,
                register_file_we => w_register_file_we);

        SCD : single_cycle_datapath
            generic map(
                FIRST_INSTRUCTION => 48,
                MEMD_NUMBER_OF_WORDS => 128,
                MEMI_NUMBER_OF_WORDS => 128,
                OUTPUT_ADDR => 255)
            port map(
                alu_selector => w_alu_selector,
                clk => clk,
                epc_we => w_epc_we,
                has_shamt => w_has_shamt,
                hi_we => w_hi_we,
                i_instruction => w_i_instruction,
                jump => w_jump,
                lo_we => w_lo_we,
                memd_we => w_memd_we,
                pc_source => w_pc_source,
                r_instruction => w_r_instruction,
                rd_source => w_rd_source,
                register_file_we => w_register_file_we,
                rst => rst,
                instruction => w_instruction,
                output => output);
end architecture;
