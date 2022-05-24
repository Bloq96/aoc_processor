library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALU_COMPONENTS.extended_alu;
use work.GENERIC_COMPONENTS.banco_registradores;
use work.GENERIC_COMPONENTS.memd;
use work.GENERIC_COMPONENTS.memi;
use work.GENERIC_COMPONENTS.registrador;
use work.GENERIC_COMPONENTS.somador;
use work.GENERIC_FUNCTIONS.bool2sl;
use work.GENERIC_FUNCTIONS.ceil_log_2;
use work.GENERIC_FUNCTIONS.int2slv;

entity pipeline_datapath is
    generic(
        FIRST_INSTRUCTION : natural := 48;
        MEMD_NUMBER_OF_WORDS : natural := 128;
        MEMI_NUMBER_OF_WORDS : natural := 128;
        OUTPUT_ADDR          : natural := 255);
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
end entity;

architecture structure_pipeline_datapath of pipeline_datapath
is
    constant MEMD_ADDRESS_LENGTH : integer :=
    ceil_log_2(MEMD_NUMBER_OF_WORDS);

------------------------- Fetch Instruction --------------------------

    signal current_instruction : std_logic_vector(31 downto 0);
    signal epc_input : std_logic_vector(31 downto 0);
    signal jump_address : std_logic_vector(31 downto 0); 
    signal mux_0_0 : std_logic_vector(31 downto 0); 
    signal mux_0_1 : std_logic_vector(31 downto 0); 
    signal mux_0_2 : std_logic_vector(31 downto 0); 
    signal mux_0_3 : std_logic_vector(31 downto 0); 
    signal mux_3_0 : std_logic_vector(31 downto 0); 
    signal pc_input : std_logic_vector(31 downto 0); 
    signal r_epc_output_1 : std_logic_vector(31 downto 0); 
    signal r_instruction_value_1 : std_logic_vector(31 downto 0); 
    signal r_next_instruction_1 : std_logic_vector(31 downto 0);
            signal w_data_input_1 : std_logic_vector(116 downto 0);
    signal w_data_reg_1 : std_logic_vector(116 downto 0);
 
-------------------------- Decode Read Reg ---------------------------
        
    signal r_alu_selector_2 : std_logic_vector(5 downto 0);
    signal r_branch_2 : std_logic_vector(1 downto 0);
    signal r_branch_output_2 : std_logic_vector(31 downto 0); 
    signal r_epc_output_2 : std_logic_vector(31 downto 0); 
    signal r_has_shamt_2 : std_logic;
    signal r_hi_we_2 : std_logic;
    signal r_imm_unsig_2 : std_logic;
    signal r_instruction_value_2 : std_logic_vector(31 downto 0); 
    signal r_jump_2 : std_logic;
    signal r_jump_r_2 : std_logic;
    signal r_lo_we_2 : std_logic;
    signal r_lw_2 : std_logic;
    signal r_memd_we_2 : std_logic;
    signal r_next_instruction_2 : std_logic_vector(31 downto 0);
    signal r_r_instruction_2 : std_logic;
    signal r_rd_source_2 : std_logic_vector(2 downto 0);
    signal r_register_file_we_2 : std_logic;
    signal r_rs_output_2 : std_logic_vector(31 downto 0); 
    signal r_rt_output_2 : std_logic_vector(31 downto 0); 
    signal r_write_address_2 : std_logic_vector(4 downto 0); 
    signal reference_register : std_logic_vector(4 downto 0); 
    signal rs_output : std_logic_vector(31 downto 0); 
    signal rt_output : std_logic_vector(31 downto 0); 
    signal shift_lower_imm : std_logic_vector(31 downto 0);
    signal w_data_input_2 : std_logic_vector(216 downto 0);
    signal w_data_reg_2 : std_logic_vector(216 downto 0);

---------------------------- Execute ALU -----------------------------

    signal alu_input_a : std_logic_vector(31 downto 0);
    signal alu_input_b : std_logic_vector(31 downto 0);
    signal alu_output_hi : std_logic_vector(31 downto 0);
    signal data_value : std_logic_vector(31 downto 0); 
    signal hi_output : std_logic_vector(31 downto 0); 
    signal lo_output : std_logic_vector(31 downto 0); 
    signal mux_1_0 : std_logic_vector(31 downto 0); 
    signal mux_1_1 : std_logic_vector(31 downto 0); 
    signal mux_1_2 : std_logic_vector(31 downto 0); 
    signal mux_1_3 : std_logic_vector(31 downto 0); 
    signal mux_2_0 : std_logic_vector(31 downto 0); 
    signal mux_4_0 : std_logic_vector(31 downto 0); 
    signal mux_5_0 : std_logic_vector(31 downto 0); 
    signal r_alu_output_lo_3 : std_logic_vector(31 downto 0);
    signal r_alu_selector_3 : std_logic_vector(5 downto 0);
    signal r_branch_3 : std_logic_vector(1 downto 0);
    signal r_branch_output_3 : std_logic_vector(31 downto 0);
    signal r_epc_output_3 : std_logic_vector(31 downto 0);
    signal r_has_shamt_3 : std_logic;
    signal r_hi_we_3 : std_logic;
    signal r_imm_unsig_3 : std_logic;
    signal r_instruction_value_3 : std_logic_vector(31 downto 0);
    signal r_jump_r_3 : std_logic;
    signal r_lo_we_3 : std_logic;
    signal r_lw_3 : std_logic;
    signal r_memd_we_3 : std_logic;
    signal r_next_instruction_3 : std_logic_vector(31 downto 0);
    signal r_r_instruction_3 : std_logic;
    signal r_rd_input_3 : std_logic_vector(31 downto 0);
    signal r_rd_source_3 : std_logic_vector(2 downto 0);
    signal r_register_file_we_3 : std_logic;
    signal r_rs_output_3 : std_logic_vector(31 downto 0);
    signal r_rt_output_3 : std_logic_vector(31 downto 0);
    signal r_write_address_3 : std_logic_vector(4 downto 0);
    signal rs_output_3 : std_logic_vector(31 downto 0);
    signal rs_rt_compare : std_logic;
    signal rt_output_3 : std_logic_vector(31 downto 0);
    signal shamt : std_logic_vector(31 downto 0); 
    signal upper_imm : std_logic_vector(31 downto 0); 
    signal w_output : std_logic_vector(31 downto 0); 
    signal w_data_input_3 : std_logic_vector(105 downto 0);
    signal w_data_reg_3 : std_logic_vector(105 downto 0);

------------------------- Memory Read/Write --------------------------

    signal r_alu_output_lo_4 : std_logic_vector(31 downto 0);
            signal r_data_value_4 : std_logic_vector(31 downto 0); 
    signal r_memd_we_4 : std_logic;
    signal r_rd_input_4 : std_logic_vector(31 downto 0);
    signal r_rd_source_4 : std_logic_vector(2 downto 0);
    signal r_register_file_we_4 : std_logic;
    signal r_rt_output_4 : std_logic_vector(31 downto 0);
    signal r_write_address_4 : std_logic_vector(4 downto 0);
    signal memd_address : std_logic_vector((MEMD_ADDRESS_LENGTH-1)
    downto 0);
    signal w_data_input_4 : std_logic_vector(72 downto 0);
    signal w_data_reg_4 : std_logic_vector(72 downto 0);
 
----------------------------- Write Reg ------------------------------

    signal r_data_value_5 : std_logic_vector(31 downto 0); 
    signal r_rd_input_5 : std_logic_vector(31 downto 0); 
    signal r_rd_source_5 : std_logic_vector(2 downto 0); 
    signal r_register_file_we_5 : std_logic;
    signal r_write_address_5 : std_logic_vector(4 downto 0); 
    signal rd_input : std_logic_vector(31 downto 0);

    begin

------------------------- Fetch Instruction --------------------------

        EPC : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => epc_input,
                reset => rst,
                WE => (epc_we_1 and not(stall_1_rst_2)) or rst_1_2,
                saida_dados => r_epc_output_1);

        IMEM : memi
            generic map(
                INSTR_WIDTH => 32,
                MI_ADDR_WIDTH => ceil_log_2(MEMI_NUMBER_OF_WORDS))
            port map(
                Endereco => current_instruction(
                (ceil_log_2(MEMI_NUMBER_OF_WORDS)+1) downto 2), 
                Instrucao => r_instruction_value_1);

        PC : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => pc_input,
                reset => '0',
                WE => rst or not(stall_1_rst_2),
                saida_dados => current_instruction);

        PCADD : somador
            generic map(
                largura_dado => 32)
            port map(
                entrada_a => current_instruction,
                entrada_b => (2=>'1',others=>'0'),
                saida => r_next_instruction_1);

        epc_input <= r_epc_output_3 when (rst_1_2 = '1') else
                     r_next_instruction_1;
        jump_address(31 downto 28) <= r_next_instruction_1(31 downto 28); 
        jump_address(27 downto 2) <= r_instruction_value_1(25 downto 0); 
        jump_address(1 downto 0) <= (others => '0'); 
        mux_0_0 <= mux_0_1 when (pc_source_1(1) = '1') else
                   r_next_instruction_1; 
        mux_0_1 <= r_epc_output_1 when (pc_source_1(0) = '1') else
                   rs_output_3; 
        mux_0_2 <= X"00000000" when (pc_source_1(1) = '1') else
                   mux_0_3; 
        mux_0_3 <= jump_address when (pc_source_1(0) = '1') else
                   r_branch_output_3; 
        mux_3_0 <= mux_0_2 when (pc_source_1(2) = '1') else
                   mux_0_0; 
        pc_input <= int2slv(4*FIRST_INSTRUCTION,32) when (rst = '1')
                    else
                    mux_3_0; 
        w_data_input_1 <= (68 => '1', others => '0') when
                          ((rst or rst_1_2) = '1') else
                          w_data_reg_1;
        w_data_reg_1(116 downto 111) <= alu_selector_1;
        w_data_reg_1(110 downto 109) <= branch_1;
        w_data_reg_1(108 downto 77) <= r_epc_output_1;
        w_data_reg_1(76) <= has_shamt_1;
        w_data_reg_1(75) <= hi_we_1;
        w_data_reg_1(74) <= imm_unsig_1;
        w_data_reg_1(73 downto 42) <= r_instruction_value_1;
        w_data_reg_1(41) <= jump_1;
        w_data_reg_1(40) <= jump_r_1;
        w_data_reg_1(39) <= lo_we_1;
        w_data_reg_1(38) <= lw_1;
        w_data_reg_1(37) <= memd_we_1;
        w_data_reg_1(36 downto 5) <= r_next_instruction_1;
        w_data_reg_1(4) <= r_instruction_1;
        w_data_reg_1(3 downto 1) <= rd_source_1;
        w_data_reg_1(0) <= register_file_we_1;

        funct_1 <= r_instruction_value_1(5 downto 0);
        op_code_1 <= r_instruction_value_1(31 downto 26);

----------------------------------------------------------------------

        REG1 : registrador
            generic map(
                largura_dado => 117)
            port map(
                clk => clk,
                entrada_dados => w_data_input_1,
                reset => '0',
                WE => rst or rst_1_2 or not(stall_1_rst_2),
                saida_dados(116 downto 111) => r_alu_selector_2,
                saida_dados(110 downto 109) => r_branch_2,
                saida_dados(108 downto 77) => r_epc_output_2,
                saida_dados(76) => r_has_shamt_2,
                saida_dados(75) => r_hi_we_2,
                saida_dados(74) => r_imm_unsig_2,
                saida_dados(73 downto 42) => r_instruction_value_2,
                saida_dados(41) => r_jump_2,
                saida_dados(40) => r_jump_r_2,
                saida_dados(39) => r_lo_we_2,
                saida_dados(38) => r_lw_2,
                saida_dados(37) => r_memd_we_2,
                saida_dados(36 downto 5) => r_next_instruction_2,
                saida_dados(4) => r_r_instruction_2,
                saida_dados(3 downto 1) => r_rd_source_2,
                saida_dados(0) => r_register_file_we_2);

-------------------------- Decode Reda Reg ---------------------------

        BADD : somador
            generic map(
                largura_dado => 32)
            port map(
                entrada_a => r_next_instruction_2,
                entrada_b => shift_lower_imm,
                saida => r_branch_output_2);

        REGF : banco_registradores
         -- generic map(
             -- largura_dado => 32,
             -- largura_ende => 5,
             -- reset_data_0 => ((13*MEMI_NUMBER_OF_WORDS)/4),
             -- reset_data_1 => (4*(MEMD_NUMBER_OF_WORDS+
             -- MEMI_NUMBER_OF_WORDS)),
             -- reset_data_2 => (4*(MEMD_NUMBER_OF_WORDS+
             -- MEMI_NUMBER_OF_WORDS)),
             -- reset_data_3 => 0)
            port map(
                clk => clk,
                ent_Rd_ende => r_write_address_5,
                ent_Rs_ende => r_instruction_value_2(25 downto 21),
                ent_Rt_ende => r_instruction_value_2(20 downto 16),
                ent_Rd_dado => rd_input,
                WE => r_register_file_we_5,
                rst => rst,
                sai_Rs_dado => rs_output,
                sai_Rt_dado => rt_output);

        r_rs_output_2 <= rd_input when (forward_rs_2 = '1') else
                         rs_output;
        r_rt_output_2 <= rd_input when (forward_rt_2 = '1') else
                         rt_output;
        reference_register <= r_instruction_value_2(15 downto 11) when
                              (r_r_instruction_2 = '1') else
                              r_instruction_value_2(20 downto 16);
        shift_lower_imm(31 downto 18) <= (others =>
        r_instruction_value_2(15));
        shift_lower_imm(17 downto 2) <=
        r_instruction_value_2(15 downto 0);
        shift_lower_imm(1 downto 0) <= (others => '0');
        r_write_address_2 <= "11111" when (r_jump_2 = '1') else
                             reference_register;
        w_data_input_2 <= (136 => '1', others => '0') when
                          ((rst or rst_1_2 or stall_1_rst_2) = '1')
                          else
                          w_data_reg_2;
        w_data_reg_2(216 downto 211) <= r_alu_selector_2;
        w_data_reg_2(210 downto 209) <= r_branch_2;
        w_data_reg_2(208 downto 177) <= r_branch_output_2;
        w_data_reg_2(176 downto 145) <= r_epc_output_2;
        w_data_reg_2(144) <= r_has_shamt_2;
        w_data_reg_2(143) <= r_hi_we_2;
        w_data_reg_2(142) <= r_imm_unsig_2;
        w_data_reg_2(141 downto 110) <= r_instruction_value_2;
        w_data_reg_2(109) <= r_jump_r_2;
        w_data_reg_2(108) <= r_lo_we_2;
        w_data_reg_2(107) <= r_lw_2;
        w_data_reg_2(106) <= r_memd_we_2;
        w_data_reg_2(105 downto 74) <= r_next_instruction_2;
        w_data_reg_2(73) <= r_r_instruction_2;
        w_data_reg_2(72 downto 70) <= r_rd_source_2;
        w_data_reg_2(69) <= r_register_file_we_2;
        w_data_reg_2(68 downto 37) <= r_rs_output_2;
        w_data_reg_2(36 downto 5) <= r_rt_output_2;
        w_data_reg_2(4 downto 0) <= r_write_address_2;

        rs_2 <= r_instruction_value_2(25 downto 21);
        rt_2 <= r_instruction_value_2(20 downto 16);

----------------------------------------------------------------------

        REG2 : registrador
            generic map(
                largura_dado => 217)
            port map(
                clk => clk,
                entrada_dados => w_data_input_2,
                reset => '0',
                WE => '1',
                saida_dados(216 downto 211) => r_alu_selector_3,
                saida_dados(210 downto 209) => r_branch_3,
                saida_dados(208 downto 177) => r_branch_output_3,
                saida_dados(176 downto 145) => r_epc_output_3,
                saida_dados(144) => r_has_shamt_3,
                saida_dados(143) => r_hi_we_3,
                saida_dados(142) => r_imm_unsig_3,
                saida_dados(141 downto 110) => r_instruction_value_3,
                saida_dados(109) => r_jump_r_3,
                saida_dados(108) => r_lo_we_3,
                saida_dados(107) => r_lw_3,
                saida_dados(106) => r_memd_we_3,
                saida_dados(105 downto 74) => r_next_instruction_3,
                saida_dados(73) => r_r_instruction_3,
                saida_dados(72 downto 70) => r_rd_source_3,
                saida_dados(69) => r_register_file_we_3,
                saida_dados(68 downto 37) => r_rs_output_3,
                saida_dados(36 downto 5) => r_rt_output_3,
                saida_dados(4 downto 0) => r_write_address_3);

---------------------------- Execute ALU -----------------------------

        ALU : extended_alu
            generic map(
                DATA_LENGTH => 32)
            port map(
                input_a => alu_input_a,
                input_b => alu_input_b,
                selector => r_alu_selector_3,
                output_a => r_alu_output_lo_3,
                output_b => alu_output_hi);

        HI : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => alu_output_hi,
                reset => rst,
                WE => r_hi_we_3,
                saida_dados => hi_output);

        LO : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => r_alu_output_lo_3,
                reset => rst,
                WE => r_lo_we_3,
                saida_dados => lo_output);

        alu_input_a <= shamt when (r_has_shamt_3 = '1') else
                       rs_output_3;
        alu_input_b <= rt_output_3 when (r_r_instruction_3 = '1') else
                       mux_2_0;
        r_rd_input_3 <= mux_1_2 when (r_rd_source_3(2) = '1') else
                        mux_1_0; 
        mux_1_0 <= mux_1_1 when (r_rd_source_3(1) = '1') else
                   r_alu_output_lo_3; 
        mux_1_1 <= lo_output when (r_rd_source_3(0) = '1') else
                   hi_output; 
        mux_1_2 <= r_next_instruction_3 when (r_rd_source_3(1) = '1')
                   else
                   mux_1_3; 
        mux_1_3 <= upper_imm when (r_rd_source_3(0) = '1') else
                   alu_output_hi; 
        mux_2_0(31 downto 16) <= (others => '0') when
                                 (r_imm_unsig_3 = '1') else
                                 (others =>
                                 r_instruction_value_3(15));
        mux_2_0(15 downto 0) <= r_instruction_value_3(15 downto 0);
        mux_4_0 <= rd_input when (forward_rs_3(0) = '1') else
                   r_rd_input_4; 
        mux_5_0 <= rd_input when (forward_rt_3(0) = '1') else
                   r_rd_input_4; 
        rs_output_3 <= mux_4_0 when (forward_rs_3(1) = '1') else
                       r_rs_output_3;
        rs_rt_compare <= bool2sl(rs_output_3 = rt_output_3);
        rt_output_3 <= mux_5_0 when (forward_rt_3(1) = '1') else
                       r_rt_output_3;
        shamt(31 downto 5) <= (others => '0');
        shamt(4 downto 0) <= r_instruction_value_3(10 downto 6);
        upper_imm(31 downto 16) <= r_instruction_value_3(15 downto 0);
        upper_imm(15 downto 0) <= (others => '0');
        w_data_input_3 <= (others => '0') when
                          (rst = '1') else
                          w_data_reg_3;
        w_data_reg_3(105 downto 74) <= r_alu_output_lo_3;
        w_data_reg_3(73) <= r_memd_we_3;
        w_data_reg_3(72 downto 41) <= r_rd_input_3;
        w_data_reg_3(40 downto 38) <= r_rd_source_3;
        w_data_reg_3(37) <= r_register_file_we_3;
        w_data_reg_3(36 downto 5) <= rt_output_3;
        w_data_reg_3(4 downto 0) <= r_write_address_3;

       
        branch_3 <= r_branch_3;
        jump_r_3 <= r_jump_r_3;
        lw_3 <= r_lw_3;
        rs_3 <= r_instruction_value_3(25 downto 21);
        rs_rt_compare_3 <= rs_rt_compare;
        rt_3 <= r_instruction_value_3(20 downto 16);
        write_address_3 <= r_write_address_3;
 
----------------------------------------------------------------------

        REG3 : registrador
            generic map(
                largura_dado => 106)
            port map(
                clk => clk,
                entrada_dados => w_data_input_3,
                reset => '0',
                WE => '1',
                saida_dados(105 downto 74) => r_alu_output_lo_4,
                saida_dados(73) => r_memd_we_4,
                saida_dados(72 downto 41) => r_rd_input_4,
                saida_dados(40 downto 38) => r_rd_source_4,
                saida_dados(37) => r_register_file_we_4,
                saida_dados(36 downto 5) => r_rt_output_4,
                saida_dados(4 downto 0) => r_write_address_4);

------------------------- Memory Read/Write --------------------------

        DMEM : memd
            generic map(
                number_of_words => MEMD_NUMBER_OF_WORDS,
                MD_DATA_WIDTH => 32,
                MD_ADDR_WIDTH => MEMD_ADDRESS_LENGTH,
                OUTPUT_ADDR => (OUTPUT_ADDR-MEMI_NUMBER_OF_WORDS)
            )
            port map(
                address_mem => memd_address, 
                clk => clk,
                mem_write => r_memd_we_4,
                write_data_mem => r_rt_output_4,
                output => w_output,
                read_data_mem => r_data_value_4);

        MADD : somador
            generic map(
                largura_dado => MEMD_ADDRESS_LENGTH)
            port map(
                entrada_a => r_alu_output_lo_4(
                (MEMD_ADDRESS_LENGTH+1) downto 2), 
                entrada_b => int2slv(-MEMI_NUMBER_OF_WORDS,
                MEMD_ADDRESS_LENGTH),
                saida => memd_address);

        w_data_input_4 <= (others => '0') when
                          (rst = '1') else
                          w_data_reg_4;
        w_data_reg_4(72 downto 41) <= r_data_value_4;
        w_data_reg_4(40 downto 9) <= r_rd_input_4;
        w_data_reg_4(8 downto 6) <= r_rd_source_4;
        w_data_reg_4(5) <= r_register_file_we_4;
        w_data_reg_4(4 downto 0) <= r_write_address_4;

        output <= w_output(15 downto 0);
        register_file_we_4 <= r_register_file_we_4;
        write_address_4 <= r_write_address_4;

----------------------------------------------------------------------

        REG4 : registrador
            generic map(
                largura_dado => 73)
            port map(
                clk => clk,
                entrada_dados => w_data_input_4,
                reset => '0',
                WE => '1',
                saida_dados(72 downto 41) => r_data_value_5,
                saida_dados(40 downto 9) => r_rd_input_5,
                saida_dados(8 downto 6) => r_rd_source_5,
                saida_dados(5) => r_register_file_we_5,
                saida_dados(4 downto 0) => r_write_address_5);

----------------------------- Write Reg ------------------------------

        rd_input <= r_data_value_5 when (r_rd_source_5 = "110") else
                    r_rd_input_5; 

        register_file_we_5 <= r_register_file_we_5;
        write_address_5 <= r_write_address_5;

----------------------------------------------------------------------

end architecture;
