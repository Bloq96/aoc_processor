library ieee;
use ieee.std_logic_1164.all;

entity single_cycle_controller is
    port(
        instruction : in std_logic_vector(31 downto 0)
        alu_selector : out std_logic_vector(5 downto 0);
        beq : out std_logic;
        bne : out std_logic;
        epc_we : out std_logic;
        has_shamt : out std_logic;
        hi_we : out std_logic;
        jump : out std_logic;
        lo_we : out std_logic;
        memd_we : out std_logic;
        pc_source : out std_logic_vector(2 downto 0);
        pc_we : out std_logic;
        r_instruction : out std_logic;
        rd_source : out std_logic_vector(2 downto 0);
        register_bank_we : out std_logic);
end entity;

architecture behaviour_single_cycle_controller of
single_cycle_controller is
    signal mux_0 : std_logic_vector(5 downto 0);
    signal mux_1 : std_logic_vector(5 downto 0);
    signal mux_2 : std_logic_vector(5 downto 0);
    signal w_r_instruction : std_logic;

    begin
        decode : process(instruction)
            begin
                case instruction(31 downto 26) is
                    when "000001" =>    -- nop
                        beq <= '0';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '1'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        pc_we <= '0'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_bank_we <= '0'; 
                    when "000010" =>    -- j
                        beq <= '0';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '1'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "101"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_bank_we <= '0'; 
                    when "000011" =>    -- jal
                        beq <= '0';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '1'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "101"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "111"; 
                        register_bank_we <= '1'; 
                    when "000100" =>    -- beq
                        beq <= '1';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '0'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "100"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_bank_we <= '0'; 
                    when "000101" =>    -- bne
                        beq <= '0';
                        bne <= '1'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '0'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "100"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_bank_we <= '0'; 
                    when "001101" =>    -- ori
                        beq <= '0';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '0'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_bank_we <= '1'; 
                    when "001111" =>    -- lui
                        beq <= '0';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '0'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "101"; 
                        register_bank_we <= '1'; 
                    when "100011" =>    -- lw
                        beq <= '0';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '0'; 
                        lo_we <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "110"; 
                        register_bank_we <= '1'; 
                    when "101011" =>    -- sw
                        beq <= '0';
                        bne <= '0'; 
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        jump <= '0'; 
                        lo_we <= '0'; 
                        memd_we <= '1'; 
                        pc_source <= "000"; 
                        pc_we <= '1'; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_bank_we <= '0'; 
                    when others =>
                        case instruction(5 downto 0) is
                            when "000000" =>    -- sll
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '1'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '1'; 
                            when "000011" =>    -- sra
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '1'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '1'; 
                            when "001000" =>    -- jr
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "010"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '0'; 
                            when "001001" =>    -- jalr
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "010"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "111"; 
                                register_bank_we <= '1'; 
                            when "001100" =>    -- syscall
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '1';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "111"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '0'; 
                            when "001101" =>    -- break
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "011"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '0'; 
                            when "010000" =>    -- mfhi
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "010"; 
                                register_bank_we <= '1'; 
                            when "010010" =>    -- mflo
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "011"; 
                                register_bank_we <= '1'; 
                            when "011000" =>    -- mult
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '1'; 
                                jump <= '0'; 
                                lo_we <= '1'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '0'; 
                            when "011010" =>    -- div
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '1'; 
                                jump <= '0'; 
                                lo_we <= '1'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '0'; 
                            when "101010" =>    -- slt
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "100"; 
                                register_bank_we <= '1';
                            -- sllv,srav,add,sub,and,or,xor,nor --
                            when others =>
                                beq <= '0';
                                bne <= '0'; 
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                jump <= '0'; 
                                lo_we <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                pc_we <= '1'; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_bank_we <= '1'; 
                        end case; 
                end case; 
        end process;

        alu_selector <= instruction(5 downto 0) when
                        (w_r_instruction = '1') else
                        mux_0;
        mux_0 <= mux_2 when ((not(instruction(5)) and instruction(3))
                 = '1') else
                 mus_1;
        mux_1 <= "100000" when (instruction(1) = '1') else
                 "100010";
        mux_2 <= "000000" when (instruction(1) = '1') else
                 "100101";
end architecture;
