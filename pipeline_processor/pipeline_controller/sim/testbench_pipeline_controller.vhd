library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity testbench_pipeline_controller is
end entity;

architecture dataflow_testbench_pc of
testbench_pipeline_controller is
    signal w_branch_3 : std_logic_vector(1 downto 0);
    signal w_forward_rs_2 : std_logic;
    signal w_forward_rs_3 : std_logic_vector(1 downto 0);
    signal w_forward_rt_2 : std_logic;
    signal w_forward_rt_3 : std_logic_vector(1 downto 0);
    signal w_jump_logic_1 : std_logic_vector(1 downto 0);
    signal w_jump_r_3 : std_logic;
    signal w_lw_3 : std_logic;
    signal w_pc_source_1 : std_logic_vector(2 downto 0);
    signal w_pc_source_p_1 : std_logic_vector(2 downto 0);
    signal w_register_file_we_4 : std_logic;
    signal w_register_file_we_5 : std_logic;
    signal w_rs_2 : std_logic_vector(4 downto 0);
    signal w_rs_3 : std_logic_vector(4 downto 0);
    signal w_rs_rt_compare_3 : std_logic;
    signal w_rst_1_2 : std_logic;
    signal w_rt_2 : std_logic_vector(4 downto 0);
    signal w_rt_3 : std_logic_vector(4 downto 0);
    signal w_stall_1_rst_2 : std_logic;
    signal w_write_address_3 : std_logic_vector(4 downto 0);
    signal w_write_address_4 : std_logic_vector(4 downto 0);
    signal w_write_address_5 : std_logic_vector(4 downto 0);
	
    component pipeline_controller is
        port(
            branch_3 : in std_logic_vector(1 downto 0);
            jump_r_3 : in std_logic;
            lw_3 : in std_logic;
            pc_source_1 : in std_logic_vector(2 downto 0);
            register_file_we_4 : in std_logic;
            register_file_we_5 : in std_logic;
            rs_2 : in std_logic_vector(4 downto 0);
            rs_3 : in std_logic_vector(4 downto 0);
            rs_rt_compare_3 : in std_logic;
            rt_2 : in std_logic_vector(4 downto 0);
            rt_3 : in std_logic_vector(4 downto 0);
            write_address_3 : in std_logic_vector(4 downto 0);
            write_address_4 : in std_logic_vector(4 downto 0);
            write_address_5 : in std_logic_vector(4 downto 0);
            forward_rs_2 : out std_logic;
            forward_rs_3 : out std_logic_vector(1 downto 0);
            forward_rt_2 : out std_logic;
            forward_rt_3 : out std_logic_vector(1 downto 0);
            jump_logic_1 : out std_logic_vector(1 downto 0);
            pc_source_p_1 : out std_logic_vector(2 downto 0);
            rst_1_2 : out std_logic;
            stall_1_rst_2 : out std_logic);
    end component;

    begin
        PC : pipeline_controller
            port map(
                branch_3 => w_branch_3,
                jump_r_3 => w_jump_r_3,
                lw_3 => w_lw_3,
                pc_source_1 => w_pc_source_1,
                register_file_we_4 => w_register_file_we_4,
                register_file_we_5 => w_register_file_we_5,
                rs_2 => w_rs_2,
                rs_3 => w_rs_3,
                rs_rt_compare_3 => w_rs_rt_compare_3,
                rt_2 => w_rt_2,
                rt_3 => w_rt_3,
                write_address_3 => w_write_address_3,
                write_address_4 => w_write_address_4,
                write_address_5 => w_write_address_5,
                forward_rs_2 => w_forward_rs_2,
                forward_rs_3 => w_forward_rs_3,
                forward_rt_2 => w_forward_rt_2,
                forward_rt_3 => w_forward_rt_3,
                jump_logic_1 => w_jump_logic_1,
                pc_source_p_1 => w_pc_source_p_1,
                rst_1_2 => w_rst_1_2,
                stall_1_rst_2 => w_stall_1_rst_2);


        w_pc_source_1 <= "000";
        w_branch_3 <= "00", "01" after 10001 ps, "10" after 30001 ps,
                      "00" after 50001 ps;
        w_jump_r_3 <= '0', '1' after 50001 ps;
        w_lw_3 <= '0', '1' after 60001 ps, '0' after 90001 ps;
        w_register_file_we_4 <= '0', '1' after 140001 ps, '0' after 200001 ps;
        w_register_file_we_5 <= '0', '1' after 90001 ps;
        w_rs_2 <= "00000", "00100" after 70001 ps,
                  "00000" after 80001 ps, "00110" after 220001 ps,
                  "00111" after 240001 ps;
        w_rs_3 <= "00001", "00110" after 100001 ps,
                  "00001" after 120001 ps, "00101" after 160001 ps,
                  "00111" after 180001 ps;
        w_rs_rt_compare_3 <= '0', '1' after 20001 ps,
                             '0' after 30001 ps, '1' after 40001 ps;
        w_rt_2 <= "00010", "00100" after 80001 ps,
                  "00110" after 240001 ps, "00111" after 260001 ps;
        w_rt_3 <= "00011", "00110" after 120001 ps,
                  "00011" after 140001 ps, "00101" after 180001 ps,
                  "00111" after 200001 ps;
        w_write_address_3 <= "00100";
        w_write_address_4 <= "00101";
        w_write_address_5 <= "00110", "00101" after 160001 ps, "00110" after 180001 ps;
end architecture;
