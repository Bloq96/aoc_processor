library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PERIPHERAL_COMPONENTS.byte_2_word;
use work.PERIPHERAL_COMPONENTS.uart_rx;
use work.PERIPHERAL_COMPONENTS.uart_tx;
use work.PERIPHERAL_COMPONENTS.word_2_byte;
use work.SINGLE_CYCLE_COMPONENTS.all;

entity single_cycle_processor is
    port(
        clk : in std_logic;
        rst : in std_logic;
        uart_rx_bit : in std_logic;
        output : out std_logic_vector(31 downto 0);
        uart_tx_bit : out std_logic);
end entity;

architecture structure_single_cycle_processor of
single_cycle_processor is
    signal w_alu_selector : std_logic_vector(5 downto 0);
    signal w_arith : std_logic_vector(2 downto 0);
    signal w_epc_we : std_logic;
    signal w_er_0_en : std_logic;
    signal w_er_0_input : std_logic_vector(31 downto 0);
    signal w_er_0_output : std_logic_vector(31 downto 0);
    signal w_er_1_en : std_logic;
    signal w_er_1_flag : std_logic;
    signal w_er_1_input : std_logic_vector(31 downto 0);
    signal w_er_1_output : std_logic_vector(31 downto 0);
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
                OUTPUT_ADDR => 255)
            port map(
                alu_selector => w_alu_selector,
                arith => w_arith,
                clk => clk,
                epc_we => w_epc_we,
                er_0_en => w_er_0_en,
                er_0_input => w_er_0_input,
                er_1_en => w_er_1_en,
                er_1_input => w_er_1_input,
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
                er_0_output => w_er_0_output,
                er_1_flag => w_er_1_flag,
                er_1_output => w_er_1_output,
                instruction => w_instruction,
                output => output);

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

        w_er_0_en <= '0', '1' after 100001 ps, '0' after 200001 ps;
        w_er_0_input <= X"00000001";
end architecture;
