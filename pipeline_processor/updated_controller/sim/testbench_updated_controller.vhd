library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity testbench_updated_controller is
end entity;

architecture dataflow_testbench_uc of
testbench_updated_controller is
    signal w_funct : std_logic_vector(5 downto 0);
    signal w_op_code : std_logic_vector(5 downto 0);
    signal w_alu_selector : std_logic_vector(5 downto 0);
    signal w_branch : std_logic_vector(1 downto 0);
    signal w_epc_we : std_logic;
    signal w_has_shamt : std_logic;
    signal w_hi_we : std_logic;
    signal w_imm_unsig : std_logic;
    signal w_jump : std_logic;
    signal w_jump_r : std_logic;
    signal w_lo_we : std_logic;
    signal w_lw : std_logic;
    signal w_memd_we : std_logic;
    signal w_pc_source : std_logic_vector(2 downto 0);
    signal w_r_instruction : std_logic;
    signal w_rd_source : std_logic_vector(2 downto 0);
    signal w_register_file_we : std_logic;
	
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

    begin
	    UC : updated_controller
            port map(
                funct => w_funct,
                op_code => w_op_code,
                alu_selector => w_alu_selector,
                branch => w_branch,
                epc_we => w_epc_we,
                has_shamt => w_has_shamt,
                hi_we => w_hi_we,
                imm_unsig => w_imm_unsig,
                jump => w_jump,
                jump_r => w_jump_r,
                lo_we => w_lo_we,
                lw => w_lw,
                memd_we => w_memd_we,
                pc_source => w_pc_source,
                r_instruction => w_r_instruction,
                rd_source => w_rd_source,
                register_file_we => w_register_file_we);
	
        w_op_code <= "000000",
                     "000100" after 3800001 ps,
                     "000101" after 4000001 ps,
                     "001000" after 4200001 ps,
                     "001101" after 4400001 ps,
                     "001111" after 4600001 ps,
                     "100011" after 4800001 ps,
                     "101011" after 5000001 ps,
                     "000010" after 5200001 ps,
                     "000011" after 5400001 ps,
                     "000001" after 5600001 ps;
        w_funct <= "000000",
                   "000011" after 200001 ps,
                   "000100" after 400001 ps,
                   "000111" after 600001 ps,
                   "001000" after 800001 ps,
                   "001001" after 1000001 ps,
                   "001100" after 1200001 ps,
                   "001101" after 1400001 ps,
                   "010000" after 1600001 ps,
                   "010010" after 1800001 ps,
                   "011000" after 2000001 ps,
                   "011010" after 2200001 ps,
                   "100000" after 2400001 ps,
                   "100010" after 2600001 ps,
                   "100100" after 2800001 ps,
                   "100101" after 3000001 ps,
                   "100110" after 3200001 ps,
                   "100111" after 3400001 ps,
                   "101010" after 3600001 ps;
end architecture;
