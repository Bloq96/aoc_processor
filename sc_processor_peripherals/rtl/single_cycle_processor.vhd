library ieee;
use ieee.std_logic_1164.all;

library work;
use work.GENERIC_COMPONENTS.registrador;
use work.GENERIC_FUNCTIONS.bool2sl;
use work.GENERIC_FUNCTIONS.slv2int;
use work.PERIPHERAL_COMPONENTS.byte_2_word;
use work.PERIPHERAL_COMPONENTS.gpio;
use work.PERIPHERAL_COMPONENTS.timer;
use work.PERIPHERAL_COMPONENTS.uart_rx;
use work.PERIPHERAL_COMPONENTS.uart_tx;
use work.PERIPHERAL_COMPONENTS.word_2_byte;
use work.SINGLE_CYCLE_COMPONENTS.all;

entity single_cycle_processor is
    port(
        clk : in std_logic;
        rst : in std_logic;
        uart_rx_bit : in std_logic;
        gpio_data : inout std_logic_vector(1 downto 0);
        output : out std_logic_vector(7 downto 0);
        uart_tx_bit : out std_logic);
end entity;

architecture structure_single_cycle_processor of
single_cycle_processor is
    signal w_alu_selector : std_logic_vector(5 downto 0);
    signal w_arith : std_logic_vector(2 downto 0);
    signal w_epc_we : std_logic;
    signal w_er_0_en : std_logic;
    signal w_er_0_flag : std_logic;
    signal w_er_0_input : std_logic_vector(31 downto 0);
    signal w_er_1_en : std_logic;
    signal w_er_1_flag : std_logic;
    signal w_er_1_input : std_logic_vector(31 downto 0);
    signal w_er_1_output : std_logic_vector(31 downto 0);
    signal w_er_2_en : std_logic;
    signal w_er_2_input : std_logic;
    signal w_er_2_output : std_logic;
    signal w_er_3_en : std_logic;
    signal w_er_3_input : std_logic;
    signal w_er_3_output : std_logic;
    signal w_has_shamt : std_logic;
    signal w_hi_we : std_logic;
    signal w_instruction : std_logic_vector(31 downto 0);
    signal w_i_instruction : std_logic_vector(1 downto 0);
    signal w_jump : std_logic;
    signal w_lo_we : std_logic;
    signal w_lsw : std_logic_vector(1 downto 0);
    signal w_memd_we : std_logic;
    signal w_pc_source : std_logic_vector(2 downto 0);
    signal w_r_instruction : std_logic;
    signal w_rd_source : std_logic_vector(2 downto 0);
    signal w_register_file_we : std_logic;

    signal w_load_byte : std_logic;
    signal w_next_byte : std_logic;
    signal w_rx_byte : std_logic_vector(7 downto 0);
    signal w_tx_byte : std_logic_vector(7 downto 0);
    signal w_valid_byte : std_logic;

    signal w_gold : std_logic_vector(1 downto 0);
    signal w_mode : std_logic_vector(1 downto 0);
    signal w_silver : std_logic_vector(1 downto 0);
    
    signal dummy : std_logic_vector(23 downto 0);

    begin
        SCC : single_cycle_controller
            port map(
                instruction => w_instruction,
                alu_selector => w_alu_selector,
                arith => w_arith,
                epc_we => w_epc_we,
                has_shamt => w_has_shamt,
                hi_we => w_hi_we,
                i_instruction => w_i_instruction,
                jump => w_jump,
                lo_we => w_lo_we,
                lsw => w_lsw,
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
                OUTPUT_ADDR => 128)
            port map(
                alu_selector => w_alu_selector,
                arith => w_arith,
                clk => clk,
                epc_we => w_epc_we,
                er_0_en => w_er_0_en,
                er_0_input => w_er_0_input,
                er_1_en => w_er_1_en,
                er_1_input => w_er_1_input,
                er_2_en => w_er_2_en,
                er_2_input => w_er_2_input,
                er_3_en => w_er_3_en,
                er_3_input => w_er_3_input,
                has_shamt => w_has_shamt,
                hi_we => w_hi_we,
                i_instruction => w_i_instruction,
                jump => w_jump,
                lo_we => w_lo_we,
                lsw => w_lsw,
                memd_we => w_memd_we,
                pc_source => w_pc_source,
                r_instruction => w_r_instruction,
                rd_source => w_rd_source,
                register_file_we => w_register_file_we,
                rst => rst,
                er_0_flag => w_er_0_flag,
                er_1_flag => w_er_1_flag,
                er_1_output => w_er_1_output,
                er_2_output => w_er_2_output,
                er_3_output => w_er_3_output,
                instruction => w_instruction,
                output(7 downto 0) => output,
                output(31 downto 8) => dummy);

        TIM : timer
            generic map(
                DATA_LENGTH => 32)
            port map(
                clk => clk,
                clk_division => X"0000000B",
                count => '1',
                max_count => X"0000000B",
                rst => rst,
                set => w_er_0_flag,
                value_count => w_er_0_input,
                reset => w_er_0_en);

        B2W : byte_2_word
            generic map(
                DATA_LENGTH => 32)
            port map(
                byte => w_rx_byte,
                clk => clk,
                rst => rst,
                set_byte => w_load_byte,
                valid_word => w_er_1_en,
                word => w_er_1_input);

        RX : uart_rx
            generic map(
                MAX_LENGTH => 32)
            port map(
                clk => clk,
                clk_ticks => X"00000001",
                data_bit => uart_rx_bit,
                rst => rst,
                byte => w_rx_byte,
                recv => w_load_byte);

        TX : uart_tx
            generic map(
                MAX_LENGTH => 32)
            port map(
                byte => w_tx_byte, 
                clk => clk,
                clk_ticks => X"00000001",
                rst => rst,
                send => w_valid_byte,
                data_bit => uart_tx_bit,
                ready => w_next_byte);

        W2B : word_2_byte
            generic map(
                DATA_LENGTH => 32)
            port map(
                clk => clk,
                rst => rst,
                set_word => w_er_1_flag,
                shift => w_next_byte,
                word => w_er_1_output,
                byte => w_tx_byte,
                valid_byte => w_valid_byte);

        GPIOn : gpio
            generic map(
                DATA_LENGTH => 2)
            port map(
                data_in => w_er_3_output & w_er_2_output,
                mode => w_mode,
                data => gpio_data,
                data_out(0) => w_er_2_input,
                data_out(1) => w_er_3_input);
        
        GOLD : registrador
            generic map(
                largura_dado => 2)
            port map(
                clk => clk,
                entrada_dados => w_silver,
                reset => '0',
                WE => '1',
                saida_dados => w_gold);
         
        w_er_2_en <= not(bool2sl(w_gold(0) = w_silver(0)));
        w_er_3_en <= not(bool2sl(w_gold(1) = w_silver(1)));
        w_mode <= "11";
        w_silver <= (w_er_3_input & w_er_2_input) or w_mode; 
end architecture;
