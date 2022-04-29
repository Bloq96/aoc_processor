library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALU_COMPONENTS.extended_alu;
use work.GENERIC_COMPONENTS.banco_registradores;
use work.GENERIC_COMPONENTS.memd;
use work.GENERIC_COMPONENTS.memi;
use work.GENERIC_COMPONENTS.registrador;
use work.GENERIC_COMPONENTS.somador;
use work.GENERIC_FUNCTIONS.ceil_log_2;

entity single_cycle_datapath is
    generic(
        MEMD_NUMBER_OF_WORDS : natural := 608;
        MEMI_NUMBER_OF_WORDS : natural := 160);
    port(
        alu_selector : in std_logic_vector(5 downto 0);
        beq : in std_logic;
        bne : in std_logic;
        clk : in std_logic;
        epc_we : in std_logic;
        has_shamt : in std_logic;
        hi_we : in std_logic;
        jump : in std_logic;
        lo_we : in std_logic;
        memd_we : in std_logic;
        pc_we : in std_logic;
        pc_source : in std_logic_vector(2 downto 0);
        r_instruction : in std_logic;
        rd_source : in std_logic_vector(2 downto 0);
        register_file_we : in std_logic;
        rst : in std_logic;
        slt : in std_logic;
        instruction : out std_logic_vector(31 downto 0));
end entity;

architecture structure_single_cycle_datapath of single_cycle_datapath
is
    signal alu_input_a : std_logic_vector(31 downto 0);
    signal alu_input_b : std_logic_vector(31 downto 0);
    signal alu_output_hi : std_logic_vector(31 downto 0);
    signal alu_output_lo : std_logic_vector(31 downto 0);
    signal alu_zero : std_logic; 
    signal branch : std_logic_vector(31 downto 0); 
    signal branch_output : std_logic_vector(31 downto 0); 
    signal branch_route : std_logic_vector(31 downto 0); 
    signal current_instruction : std_logic_vector(31 downto 0); 
    signal data_value : std_logic_vector(31 downto 0); 
    signal epc_output : std_logic_vector(31 downto 0); 
    signal hi_output : std_logic_vector(31 downto 0); 
    signal instruction_value : std_logic_vector(31 downto 0); 
    signal jump_address : std_logic_vector(31 downto 0); 
    signal lo_output : std_logic_vector(31 downto 0); 
    signal lower_immediate : std_logic_vector(31 downto 0); 
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
    signal next_instruction : std_logic_vector(31 downto 0);
    signal pc_input : std_logic_vector(31 downto 0); 
    signal rd_input : std_logic_vector(31 downto 0); 
    signal reference_register : std_logic_vector(4 downto 0); 
    signal rs_output : std_logic_vector(31 downto 0); 
    signal rt_output : std_logic_vector(31 downto 0); 
    signal shamt : std_logic_vector(31 downto 0); 
    signal upper_immediate : std_logic_vector(31 downto 0); 
    signal write_address : std_logic_vector(4 downto 0); 


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
                entrada_b => branch,
                saida => branch_route);

        DMEM : memd
            generic map(
                number_of_words => MEMD_NUMBER_OF_WORDS,
                MD_DATA_WIDTH => 32,
                MD_ADDR_WIDTH => ceil_log_2(MEMD_NUMBER_OF_WORDS))
            port map(
                address_mem => alu_output_lo(
                (ceil_log_2(MEMD_NUMBER_OF_WORDS)-1) downto 0), 
                clk => clk,
                mem_write => memd_we,
                mem_read => '1',
                write_data_mem => rt_output,
                read_data_mem => data_value);

        EPC : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => next_instruction,
                reset => rst,
                WE => epc_we,
                saida_dados => epc_output);

        HI : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => alu_output_hi,
                reset => rst,
                WE => hi_we,
                saida_dados => hi_output);

        IMEM : memi
            generic map(
                INSTR_WIDTH => 32,
                MI_ADDR_WIDTH => ceil_log_2(MEMI_NUMBER_OF_WORDS))
            port map(
                clk => clk,
                Endereco => current_instruction(
                (ceil_log_2(MEMI_NUMBER_OF_WORDS)-1) downto 0), 
                reset => rst,
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

        PC : registrador
            generic map(
                largura_dado => 32)
            port map(
                clk => clk,
                entrada_dados => pc_input,
                reset => rst,
                WE => pc_we,
                saida_dados => current_instruction);

        PCADD : somador
            generic map(
                largura_dado => 32)
            port map(
                entrada_a => current_instruction,
                entrada_b => (2=>'1',others=>'0'),
                saida => next_instruction);

        REGB : banco_registradores
            generic map(
                largura_dado => 32,
                largura_ende => 5)
            port map(
                clk => clk,
                ent_Rd_ende => write_address,
                ent_Rs_ende => instruction_value(25 downto 21),
                ent_Rt_ende => instruction_value(20 downto 16),
                ent_Rd_dado => rd_input,
                WE => register_file_we,
                sai_Rs_dado => rs_output,
                sai_Rt_dado => rt_output);

        alu_input_a <= shamt when (has_shamt = '1') else
                       rs_output;
        alu_input_b <= rt_output when (r_instruction = '1') else
                       lower_immediate;
        branch(31 downto 18) <= (others => instruction_value(15));
        branch(17 downto 2) <= instruction_value(15 downto 0);
        branch(1 downto 0) <= (others => '0');
        branch_output <= branch_route when (((beq and alu_zero) = '1')
                         or ((bne and not(alu_zero)) = '1')) else
                         next_instruction;
        jump_address(31 downto 28) <= next_instruction(31 downto 28); 
        jump_address(27 downto 2) <= instruction_value(25 downto 0); 
        jump_address(1 downto 0) <= (others => '0'); 
        lower_immediate(31 downto 16) <= (others => instruction_value(15));
        lower_immediate(15 downto 0) <= instruction_value(15 downto 0);
        pc_input <= mux_0_2 when (pc_source(2) = '1') else
                    mux_0_0; 
        mux_0_0 <= mux_0_1 when (pc_source(1) = '1') else
                   next_instruction; 
        mux_0_1 <= epc_output when (pc_source(0) = '1') else
                   rs_output; 
        mux_0_2 <= X"00000000" when (pc_source(1) = '1') else
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
        mux_1_3 <= upper_immediate when (rd_source(0) = '1') else
                   alu_output_hi; 
        mux_1_4 <= next_instruction when (rd_source(0) = '1') else
                   data_value; 
        reference_register <= instruction_value(15 downto 11) when
                              (r_instruction = '1') else
                              instruction_value(20 downto 16);
        shamt(31 downto 5) <= (others => '0');
        shamt(4 downto 0) <= instruction_value(10 downto 6);
        upper_immediate(31 downto 16) <= instruction_value(15 downto 0);
        upper_immediate(15 downto 0) <= (others => '0');
        write_address <= "11111" when (jump = '1') else
                         reference_register;
        
        instruction <= instruction_value;
end architecture;