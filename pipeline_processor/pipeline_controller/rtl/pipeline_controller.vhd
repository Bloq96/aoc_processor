library ieee;
use ieee.std_logic_1164.all;

library work;
use work.GENERIC_FUNCTIONS.bool2sl;

entity pipeline_controller is
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
        pc_source_p_1 : out std_logic_vector(2 downto 0);
        rst_1_2 : out std_logic;
        stall_1_rst_2 : out std_logic);
end entity;

architecture dataflow_pipeline_controller of
pipeline_controller is
    signal branch_logic_3 : std_logic;
    signal forward_rs_4 : std_logic;
    signal forward_rs_5 : std_logic;
    signal forward_rt_4 : std_logic;
    signal forward_rt_5 : std_logic;
    signal jump_logic_1 : std_logic_vector(1 downto 0);
    signal rs_2_wa_3_comp : std_logic;
    signal rs_2_wa_5_comp : std_logic;
    signal rs_3_wa_4_comp : std_logic;
    signal rs_3_wa_5_comp : std_logic;
    signal rt_2_wa_3_comp : std_logic;
    signal rt_2_wa_5_comp : std_logic;
    signal rt_3_wa_4_comp : std_logic;
    signal rt_3_wa_5_comp : std_logic;
    signal rst_3 : std_logic;

    begin
        branch_logic_3 <= (rs_rt_compare_3 and branch_3(0)) or
        (not(rs_rt_compare_3) and branch_3(1));
        jump_logic_1 <= jump_r_3 & branch_logic_3;
        rs_2_wa_3_comp <= bool2sl(rs_2=write_address_3);
        rs_2_wa_5_comp <= bool2sl(rs_2=write_address_5);
        rs_3_wa_4_comp <= bool2sl(rs_3=write_address_4);
        rs_3_wa_5_comp <= bool2sl(rs_3=write_address_5);
        rt_2_wa_3_comp <= bool2sl(rt_2=write_address_3);
        rt_2_wa_5_comp <= bool2sl(rt_2=write_address_5);
        rt_3_wa_4_comp <= bool2sl(rt_3=write_address_4);
        rt_3_wa_5_comp <= bool2sl(rt_3=write_address_5);
        forward_rs_4 <= register_file_we_4 and rs_3_wa_4_comp;
        forward_rs_5 <= register_file_we_5 and rs_3_wa_5_comp;
        forward_rt_4 <= register_file_we_4 and rt_3_wa_4_comp;
        forward_rt_5 <= register_file_we_5 and rt_3_wa_5_comp;
        rst_3 <= jump_r_3 xor branch_logic_3;

        forward_rs_2 <= register_file_we_5 and rs_2_wa_5_comp;
        forward_rs_3 <= (forward_rs_4 or forward_rs_5) &
        (not(forward_rs_4) and forward_rs_5);
        forward_rt_2 <= register_file_we_5 and rt_2_wa_5_comp;
        forward_rt_3 <= (forward_rt_4 or forward_rt_5) &
        (not(forward_rt_4) and forward_rt_5);
        pc_source_p_1 <= jump_logic_1 & '0' when (rst_3 = '1') else
                         pc_source_1;
        rst_1_2 <= rst_3;
        stall_1_rst_2 <= lw_3 and (rs_2_wa_3_comp or rt_2_wa_3_comp);
end architecture;
