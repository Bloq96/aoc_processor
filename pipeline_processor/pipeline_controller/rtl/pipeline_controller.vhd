library ieee;
use ieee.std_logic_1164.all;

entity pipeline_controller is
    port(
        instruction : in std_logic_vector(31 downto 0);
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
end entity;

architecture dataflow_pipeline_controller of
pipeline_controller is
    signal alu_control : std_logic_vector(1 downto 0);
    signal mux_0 : std_logic_vector(5 downto 0);
    signal mux_1 : std_logic_vector(5 downto 0);
    signal mux_2 : std_logic_vector(5 downto 0);
    signal w_r_instruction : std_logic;

    begin
end architecture;
