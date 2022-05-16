library ieee;
use ieee.std_logic_1164.all;

entity updated_controller is
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

architecture behaviour_updated_controller of
updated_controller is
    signal alu_control : std_logic_vector(1 downto 0);
    signal mux_0 : std_logic_vector(5 downto 0);
    signal mux_1 : std_logic_vector(5 downto 0);
    signal mux_2 : std_logic_vector(5 downto 0);
    signal w_r_instruction : std_logic;

    begin
        decode : process(instruction)
            begin
                case instruction(31 downto 26) is
                    when "000001" =>    -- nop
                        alu_control <= "11";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_file_we <= '0'; 
                    when "000010" =>    -- j
                        alu_control <= "01";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '1'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "101"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_file_we <= '0'; 
                    when "000011" =>    -- jal
                        alu_control <= "01";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '1'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "101"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "111"; 
                        register_file_we <= '1'; 
                    when "000100" =>    -- beq
                        alu_control <= "00";
                        branch <= "01";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_file_we <= '0'; 
                    when "000101" =>    -- bne
                        alu_control <= "00";
                        branch <= "10";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_file_we <= '0'; 
                    when "001000" =>    -- addi
                        alu_control <= "01";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_file_we <= '1'; 
                    when "001101" =>    -- ori
                        alu_control <= "10";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '1';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_file_we <= '1'; 
                    when "001111" =>    -- lui
                        alu_control <= "11";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "101"; 
                        register_file_we <= '1'; 
                    when "100011" =>    -- lw
                        alu_control <= "01";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '1'; 
                        memd_we <= '0'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "110"; 
                        register_file_we <= '1'; 
                    when "101011" =>    -- sw
                        alu_control <= "01";
                        branch <= "00";
                        epc_we <= '0';
                        has_shamt <= '0'; 
                        hi_we <= '0'; 
                        imm_unsig <= '0';
                        jump <= '0'; 
                        jump_r <= '0'; 
                        lo_we <= '0'; 
                        lw <= '0'; 
                        memd_we <= '1'; 
                        pc_source <= "000"; 
                        w_r_instruction <= '0'; 
                        rd_source <= "000"; 
                        register_file_we <= '0'; 
                    when others =>
                        case instruction(5 downto 0) is
                            when "000000" =>    -- sll
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '1'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '1'; 
                            when "000011" =>    -- sra
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '1'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '1'; 
                            when "001000" =>    -- jr
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '1'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '0'; 
                            when "001001" =>    -- jalr
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '1'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "111"; 
                                register_file_we <= '1'; 
                            when "001100" =>    -- syscall
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '1';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "111"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '0'; 
                            when "001101" =>    -- break
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "011"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '0'; 
                            when "010000" =>    -- mfhi
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "010"; 
                                register_file_we <= '1'; 
                            when "010010" =>    -- mflo
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "011"; 
                                register_file_we <= '1'; 
                            when "011000" =>    -- mult
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '1'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '1'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '0'; 
                            when "011010" =>    -- div
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '1'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '1'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '0'; 
                            when "101010" =>    -- slt
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "100"; 
                                register_file_we <= '1';
                            -- sllv,srav,add,sub,and,or,xor,nor --
                            when others =>
                                alu_control <= "00";
                                branch <= "00";
                                epc_we <= '0';
                                has_shamt <= '0'; 
                                hi_we <= '0'; 
                                imm_unsig <= '0';
                                jump <= '0'; 
                                jump_r <= '0'; 
                                lo_we <= '0'; 
                                lw <= '0'; 
                                memd_we <= '0'; 
                                pc_source <= "000"; 
                                w_r_instruction <= '1'; 
                                rd_source <= "000"; 
                                register_file_we <= '1'; 
                        end case; 
                end case; 
        end process;

        alu_selector <= instruction(5 downto 0) when
                        (w_r_instruction = '1') else
                        mux_0;
        mux_0 <= mux_2 when (alu_control(1) = '1') else
                 mux_1;
        mux_1 <= "100000" when (alu_control(0) = '1') else
                 "100010";
        mux_2 <= "000000" when (alu_control(0) = '1') else
                 "100101";
        r_instruction <= w_r_instruction;
end architecture;
