library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALU_COMPONENTS.extended_alu;
use work.GENERIC_COMPONENTS.banco_registradores;
use work.GENERIC_COMPONENTS.interrupt_controller;
use work.GENERIC_COMPONENTS.memd;
use work.GENERIC_COMPONENTS.memi;
use work.GENERIC_COMPONENTS.registrador;
use work.GENERIC_COMPONENTS.somador;
use work.GENERIC_FUNCTIONS.bool2sl;
use work.GENERIC_FUNCTIONS.ceil_log_2;
use work.GENERIC_FUNCTIONS.int2slv;
use work.GENERIC_FUNCTIONS.reductive_and;
use work.GENERIC_FUNCTIONS.reductive_or;
use work.GENERIC_FUNCTIONS.slv2int;

entity single_cycle_datapath is
    generic(
        FIRST_INSTRUCTION : natural := 48;
        MEMD_NUMBER_OF_WORDS : natural := 128;
        MEMI_NUMBER_OF_WORDS : natural := 128;
        OUTPUT_ADDR          : natural := 255);
    port(
        alu_selector : in std_logic_vector(5 downto 0);
        arith : in std_logic_vector(2 downto 0);
        clk : in std_logic;
        epc_we : in std_logic;
        er_0_en : in std_logic;
        er_0_input : in std_logic_vector(31 downto 0);
        er_1_en : in std_logic;
        er_1_input : in std_logic_vector(31 downto 0);
        er_2_en : in std_logic;
        er_2_input : in std_logic;
        er_3_en : in std_logic;
        er_3_input : in std_logic;
        has_shamt : in std_logic;
        hi_we : in std_logic;
        i_instruction : in std_logic_vector(1 downto 0);
        jump : in std_logic;
        lo_we : in std_logic;
        lsw : in std_logic_vector(1 downto 0);
        memd_we : in std_logic;
        pc_source : in std_logic_vector(2 downto 0);
        r_instruction : in std_logic;
        rd_source : in std_logic_vector(2 downto 0);
        register_file_we : in std_logic;
        rst : in std_logic;
        er_0_flag : out std_logic;
        er_0_output : out std_logic_vector(31 downto 0);
        er_1_flag : out std_logic;
        er_1_output : out std_logic_vector(31 downto 0);
        er_2_flag : out std_logic;
        er_2_output : out std_logic;
        er_3_flag : out std_logic;
        er_3_output : out std_logic;
        instruction : out std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0));
end entity;

architecture structure_single_cycle_datapath of single_cycle_datapath
is
    constant MEMD_ADDRESS_LENGTH : integer :=
    ceil_log_2(MEMD_NUMBER_OF_WORDS);

    signal alu_input_a : std_logic_vector(31 downto 0);
    signal alu_input_b : std_logic_vector(31 downto 0);
    signal alu_output_hi : std_logic_vector(31 downto 0);
    signal alu_output_lo : std_logic_vector(31 downto 0);
    signal alu_zero : std_logic; 
    signal branch : std_logic_vector(31 downto 0); 
    signal branch_output : std_logic_vector(31 downto 0); 
    signal current_instruction : std_logic_vector(31 downto 0); 
    signal data_value : std_logic_vector(31 downto 0); 
    signal delayed_next_instruction : std_logic_vector(31 downto 0);
    signal epc_output : std_logic_vector(31 downto 0); 
    signal hi_output : std_logic_vector(31 downto 0); 
    signal imm_2nd_input : std_logic_vector(31 downto 0); 
    signal instruction_value : std_logic_vector(31 downto 0); 
    signal interrupt : std_logic_vector(31 downto 0); 
    signal interrupts : std_logic_vector(5 downto 0); 
    signal interrupts_enabled : std_logic_vector(6 downto 0); 
    signal jump_address : std_logic_vector(31 downto 0); 
    signal lo_output : std_logic_vector(31 downto 0); 
    signal memd_address : std_logic_vector((MEMD_ADDRESS_LENGTH-1)
    downto 0); 
    signal mux_0_0 : std_logic_vector(31 downto 0); 
    signal mux_0_1 : std_logic_vector(31 downto 0); 
    signal mux_0_2 : std_logic_vector(31 downto 0); 
    signal mux_0_3 : std_logic_vector(31 downto 0); 
    signal mux_1_0 : std_logic_vector(31 downto 0); 
    signal mux_1_1 : std_logic_vector(31 downto 0); 
    signal mux_1_2 : std_logic_vector(31 downto 0); 
    signal mux_1_3 : std_logic_vector(31 downto 0); 
    signal mux_1_4 : std_logic_vector(31 downto 0); 
    signal mux_1_5 : std_logic_vector(31 downto 0); 
    signal mux_2_0 : std_logic_vector(31 downto 0); 
    signal mux_3_0 : std_logic_vector(31 downto 0); 
    signal mux_3_1 : std_logic_vector(31 downto 0); 
    signal mux_4_0 : std_logic_vector(31 downto 0); 
    signal mux_4_1 : std_logic_vector(31 downto 0); 
    signal mux_4_2 : std_logic_vector(31 downto 0); 
    signal mux_4_3 : std_logic_vector(31 downto 0); 
    signal next_instruction : std_logic_vector(31 downto 0);
    signal pc_input : std_logic_vector(31 downto 0); 
    signal peripheral : std_logic; 
    signal peripheral_address : std_logic_vector(MEMD_ADDRESS_LENGTH
    downto 0); 
    signal rd_input : std_logic_vector(31 downto 0); 
    signal read_peripheral : std_logic; 
    signal reference_register : std_logic_vector(4 downto 0); 
    signal rs_output : std_logic_vector(31 downto 0); 
    signal rt_output : std_logic_vector(31 downto 0); 
    signal shamt : std_logic_vector(31 downto 0); 
    signal shift_lower_imm : std_logic_vector(31 downto 0);
    signal upper_imm : std_logic_vector(31 downto 0); 
    signal w_er_0_en : std_logic; 
    signal w_er_0_flag : std_logic; 
    signal w_er_0_output : std_logic_vector(31 downto 0); 
    signal w_er_1_en : std_logic; 
    signal w_er_1_flag : std_logic; 
    signal w_er_1_output : std_logic_vector(31 downto 0); 
    signal w_er_2_en : std_logic; 
    signal w_er_2_flag : std_logic; 
    signal w_er_2_output : std_logic; 
    signal w_er_3_en : std_logic; 
    signal w_er_3_flag : std_logic; 
    signal w_er_3_output : std_logic; 
    signal write_address : std_logic_vector(4 downto 0); 
    signal write_peripheral : std_logic; 


    begin
        ALU : extended_alu
            generic map(
                DATA_LENGTH => 32)
            port map(
                input_a => alu_input_a,
                input_b => alu_input_b,
                selector => alu_selector,
                output_a => alu_output_lo,
                output_b => alu_output_hi,
                zero => alu_zero);

        BADD : somador
            generic map(
                largura_dado => 32)
            port map(
                entrada_a => next_instruction,
                entrada_b => shift_lower_imm,
                saida => branch);

        DEPC : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => mux_3_1,
                reset => rst,
                WE => '1',
                saida_dados => delayed_next_instruction);

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
                mem_write => memd_we and not(write_peripheral),
                write_data_mem => rt_output,
                output => output,
                read_data_mem => data_value);

        EPC : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => delayed_next_instruction,
                reset => rst,
                WE => epc_we,
                saida_dados => epc_output);

        ER0_0 : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => er_0_input,
                reset => rst,
                WE => er_0_en,
                saida_dados => w_er_0_output);

        ER0_1 : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => rt_output,
                reset => rst,
                WE => w_er_0_en,
                saida_dados => er_0_output);

        ER1_0 : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => er_1_input,
                reset => rst,
                WE => er_1_en,
                saida_dados => w_er_1_output);

        ER1_1 : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => rt_output,
                reset => rst,
                WE => w_er_1_en,
                saida_dados => er_1_output);

        ER2_0 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados(0) => er_2_input,
                reset => rst,
                WE => er_2_en,
                saida_dados(0) => w_er_2_output);

        ER2_1 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados(0) => rt_output(0),
                reset => rst,
                WE => w_er_2_en,
                saida_dados(0) => er_2_output);

        ER3_0 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados(0) => er_3_input,
                reset => rst,
                WE => er_3_en,
                saida_dados(0) => w_er_3_output);

        ER3_1 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados(0) => rt_output(0),
                reset => rst,
                WE => w_er_3_en,
                saida_dados(0) => er_3_output);

        FR0 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or (w_er_0_flag and not(w_er_0_en)),
                WE => w_er_0_en,
                saida_dados(0) => w_er_0_flag);

        FR1 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or (w_er_1_flag and not(w_er_1_en)),
                WE => w_er_1_en,
                saida_dados(0) => w_er_1_flag);

        FR2 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or (w_er_2_flag and not(w_er_2_en)),
                WE => w_er_2_en,
                saida_dados(0) => w_er_2_flag);

        FR3 : registrador
            generic map(
                largura_dado => 1)
            port map(
                clk => clk,
                entrada_dados => "1",
                reset => rst or (w_er_3_flag and not(w_er_3_en)),
                WE => w_er_3_en,
                saida_dados(0) => w_er_3_flag);

        HI : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => alu_output_hi,
                reset => rst,
                WE => hi_we,
                saida_dados => hi_output);

        IC : interrupt_controller
            generic map(
                ADDRESS_LENGTH => 32,
                INTERRUPTION_CHANNELS => 6)
            port map(
                addresses(191 downto 160) => (162 => '1',
                others => '0'),
                addresses(159 downto 128) => (130 => '1', --135 => '1', 132 => '1',
                others => '0'),
                addresses(127 downto 96) => (98 => '1', --102 => '1', 101 => '1',
                others => '0'),
                addresses(95 downto 64) => (67 => '1', --68 => '1',
                others => '0'),
                addresses(63 downto 32) => (34 => '1', --36 => '1', 34 => '1',
                others => '0'),
                addresses(31 downto 0) => (2 => '1', others => '0'),
                break => not(pc_source(2)) and pc_source(1) and
                pc_source(0),
                clk => clk,
                interruptions => interrupts,
                interruptions_to_enable => (others => '1'),
                interruptions_enabled => interrupts_enabled,
                rst => rst,
                jump_address => interrupt);

        IMEM : memi
            generic map(
                INSTR_WIDTH => 32,
                MI_ADDR_WIDTH => ceil_log_2(MEMI_NUMBER_OF_WORDS))
            port map(
                Endereco => current_instruction(
                (ceil_log_2(MEMI_NUMBER_OF_WORDS)+1) downto 2), 
                Instrucao => instruction_value);

        LO : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => alu_output_lo,
                reset => rst,
                WE => lo_we,
                saida_dados => lo_output);

        MADD : somador
            generic map(
                largura_dado => MEMD_ADDRESS_LENGTH)
            port map(
                entrada_a => alu_output_lo(
                (MEMD_ADDRESS_LENGTH+1) downto 2), 
                entrada_b => int2slv(-MEMI_NUMBER_OF_WORDS,
                MEMD_ADDRESS_LENGTH),
                saida => memd_address);

        PADD : somador
            generic map(
                largura_dado => MEMD_ADDRESS_LENGTH+1)
            port map(
                entrada_a => alu_output_lo(
                (MEMD_ADDRESS_LENGTH+2) downto 2), 
                entrada_b => int2slv(-MEMI_NUMBER_OF_WORDS-
                MEMI_NUMBER_OF_WORDS, MEMD_ADDRESS_LENGTH+1),
                saida => peripheral_address);

        PC : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => pc_input,
                reset => '0',
                WE => '1',
                saida_dados => current_instruction);

        PCADD : somador
            generic map(
                largura_dado => 32)
            port map(
                entrada_a => current_instruction,
                entrada_b => (2=>'1',others=>'0'),
                saida => next_instruction);

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
                ent_Rd_ende => write_address,
                ent_Rs_ende => instruction_value(25 downto 21),
                ent_Rt_ende => instruction_value(20 downto 16),
                ent_Rd_dado => rd_input,
                WE => register_file_we,
                rst => rst,
                sai_Rs_dado => rs_output,
                sai_Rt_dado => rt_output);

        alu_input_a <= shamt when (has_shamt = '1') else
                       rs_output;
        alu_input_b <= rt_output when (r_instruction = '1') else
                       imm_2nd_input;
        branch_output <= branch when (((not(i_instruction(1)) and
                         i_instruction(0) and alu_zero) = '1') or
                         ((i_instruction(1) and not(i_instruction(0))
                         and not(alu_zero)) = '1')) else
                         next_instruction;
        imm_2nd_input <=  rt_output when ((i_instruction(1) xor
                      i_instruction(0)) = '1') else
                      mux_2_0;
        
        interrupts(0) <= arith(2) and ((not(arith(1)) and
        not(arith(0)) and not(alu_input_b(31) xor rs_output(31)) and
        (rs_output(31) xor alu_output_lo(31))) or (not(arith(1)) and
        arith(0) and (alu_input_b(31) xor rs_output(31)) and
        (rs_output(31) xor alu_output_lo(31))));

        interrupts(1) <= arith(2) and arith(1) and arith(0) and
        not((not(reductive_or(rs_output(31 downto 11))) or
        reductive_and(rs_output(31 downto 11))) and
        (not(reductive_or(rt_output(31 downto 9))) or
        reductive_and(rt_output(31 downto 9))));

        interrupts(2) <= er_0_en;
        interrupts(3) <= er_1_en;
        interrupts(4) <= er_2_en;
        interrupts(5) <= er_3_en;

        jump_address(31 downto 28) <= next_instruction(31 downto 28); 
        jump_address(27 downto 2) <= instruction_value(25 downto 0); 
        jump_address(1 downto 0) <= (others => '0'); 
        pc_input <= int2slv(4*FIRST_INSTRUCTION,32) when (rst = '1')
                    else
                    mux_3_0; 
        mux_0_0 <= mux_0_1 when (pc_source(1) = '1') else
                   next_instruction; 
        mux_0_1 <= epc_output when (pc_source(0) = '1') else
                   rs_output; 
        mux_0_2 <= interrupt when (pc_source(1) = '1') else
                   mux_0_3; 
        mux_0_3 <= jump_address when (pc_source(0) = '1') else
                   branch_output; 
        rd_input <= mux_1_2 when (rd_source(2) = '1') else
                    mux_1_0; 
        mux_1_0 <= mux_1_1 when (rd_source(1) = '1') else
                   alu_output_lo; 
        mux_1_1 <= lo_output when (rd_source(0) = '1') else
                   hi_output; 
        mux_1_2 <= mux_1_4 when (rd_source(1) = '1') else
                   mux_1_3; 
        mux_1_3 <= upper_imm when (rd_source(0) = '1') else
                   alu_output_hi; 
        mux_1_4 <= next_instruction when (rd_source(0) = '1') else
                   mux_4_0; 
        mux_2_0(31 downto 16) <= (others => '0') when (
                                 (i_instruction(1) and
                                 i_instruction(0)) = '1') else
                                 (others => instruction_value(15));
        mux_2_0(15 downto 0) <= instruction_value(15 downto 0);
        mux_3_0 <= X"00000000" when ((reductive_or(interrupts and
                   interrupts_enabled(5 downto 0)) and
                   interrupts_enabled(6)) = '1') else
                   mux_3_1;
        mux_3_1 <= mux_0_2 when (pc_source(2) = '1') else
                   mux_0_0;
        mux_4_0 <= mux_4_1 when (read_peripheral = '1') else
                   data_value;
        mux_4_1 <= mux_4_2 when (peripheral_address(1) = '1') else
                   mux_4_3;
        mux_4_2 <= X"0000000" & "000" & w_er_3_output when
                   (peripheral_address(0) = '1') else
                   X"0000000" & "000" & w_er_2_output;
        mux_4_3 <= w_er_1_output when (peripheral_address(0) = '1') else
                   w_er_0_output;

        peripheral <= bool2sl(slv2int(peripheral_address) >= 0);
        read_peripheral <= lsw(1) and not(lsw(0)) and peripheral; 
        
        reference_register <= instruction_value(15 downto 11) when
                              (r_instruction = '1') else
                              instruction_value(20 downto 16);

        shamt(31 downto 5) <= (others => '0');
        shamt(4 downto 0) <= instruction_value(10 downto 6);
        shift_lower_imm(31 downto 18) <= (others =>
        instruction_value(15));
        shift_lower_imm(17 downto 2) <= instruction_value(15 downto 0);
        shift_lower_imm(1 downto 0) <= (others => '0');
        upper_imm(31 downto 16) <= instruction_value(15 downto 0);
        upper_imm(15 downto 0) <= (others => '0');

        w_er_0_en <= write_peripheral and not(peripheral_address(1))
        and not(peripheral_address(0));
        w_er_1_en <= write_peripheral and not(peripheral_address(1))
        and peripheral_address(0);
        w_er_2_en <= write_peripheral and peripheral_address(1) and
        not(peripheral_address(0));
        w_er_3_en <= write_peripheral and peripheral_address(1) and
        peripheral_address(0);

        write_address <= "11111" when (jump = '1') else
                         reference_register;
        
        write_peripheral <= lsw(1) and lsw(0) and peripheral; 
       
        er_0_flag <= w_er_0_flag;
        er_1_flag <= w_er_1_flag;
        er_2_flag <= w_er_2_flag;
        er_3_flag <= w_er_3_flag;
        instruction <= instruction_value;
end architecture;
