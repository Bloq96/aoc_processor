library ieee;
use ieee.std_logic_1164.all;

library work;
use work.GENERIC_COMPONENTS.registrador;
use work.GENERIC_FUNCTIONS.ceil_log_2;
use work.GENERIC_FUNCTIONS.int2slv;
use work.GENERIC_FUNCTIONS.reductive_or;
use work.GENERIC_FUNCTIONS.slv2nat;

entity interrupt_controller is
    generic(
        ADDRESS_LENGTH : natural;
        INTERRUPTION_CHANNELS : natural);
    port(
        addresses : in std_logic_vector(((ADDRESS_LENGTH*
        INTERRUPTION_CHANNELS)-1) downto 0);
        break : in std_logic;
        clk : in std_logic;
        interruptions : in std_logic_vector((INTERRUPTION_CHANNELS-1)
        downto 0);
        interruptions_to_enable : in std_logic_vector(
        (INTERRUPTION_CHANNELS-1) downto 0);
        rst : in std_logic;
        interruptions_enabled : out std_logic_vector(
        INTERRUPTION_CHANNELS downto 0);
        interruption_flags : out std_logic_vector(
        (INTERRUPTION_CHANNELS-1) downto 0);
        jump_address : out std_logic_vector(
        (ADDRESS_LENGTH-1) downto 0));
end entity;

architecture structure_interrupt_controller of
interrupt_controller is
    constant IC_INDEX : natural := ceil_log_2(INTERRUPTION_CHANNELS);
    type std_logic_vector_array is array((INTERRUPTION_CHANNELS-1)
    downto 0) of std_logic_vector((ADDRESS_LENGTH-1) downto 0);
    type std_logic_vector_mux is array((INTERRUPTION_CHANNELS-1)
    downto 0) of std_logic_vector((IC_INDEX-1) downto 0);
    
    signal interrupt : std_logic;
    signal interruption_value : std_logic_vector((IC_INDEX-1) downto
    0);
    signal w_addresses : std_logic_vector_array;
    signal w_mux : std_logic_vector_mux;
    signal w_interruptions_enabled : std_logic_vector(
    INTERRUPTION_CHANNELS downto 0);
    signal w_interruption_flags : std_logic_vector(
    (INTERRUPTION_CHANNELS-1) downto 0);

    begin
        IER : registrador
            generic map(
                largura_dado => (INTERRUPTION_CHANNELS+1))
            port map(
                clk => clk,
                entrada_dados => (rst or not(interrupt)) &
                interruptions_to_enable,
                reset => '0',
                WE => rst or interrupt or break,
                saida_dados => w_interruptions_enabled);
        
        IFR : registrador
            generic map(
                largura_dado => INTERRUPTION_CHANNELS)
            port map(
                clk => clk,
                entrada_dados => interruptions,
                reset => rst,
                WE => '1',
                saida_dados => w_interruption_flags(
                (INTERRUPTION_CHANNELS-1) downto 0));


        INTERRUPT_VECTOR : for I in 0 to (INTERRUPTION_CHANNELS-1)
        generate
            R : registrador
                generic map(
                    largura_dado => ADDRESS_LENGTH)
                port map(
                    clk => clk,
                    entrada_dados => addresses((((I+1)*
                    ADDRESS_LENGTH)-1) downto I*ADDRESS_LENGTH),
                    reset => '0',
                    WE => rst,
                    saida_dados => w_addresses(I));
        end generate;

        INTERRUPT_INDEX : for I in (INTERRUPTION_CHANNELS-1) downto 1
        generate
            w_mux(I) <= int2slv(I,IC_INDEX) when
                        (w_interruption_flags(I) = '1') else
                        w_mux(I-1);
        end generate;

        interrupt <= w_interruptions_enabled(INTERRUPTION_CHANNELS)
        and reductive_or(w_interruptions_enabled(
        (INTERRUPTION_CHANNELS-1) downto 0) and interruptions);
        interruption_value <= w_mux(INTERRUPTION_CHANNELS-1);
        w_mux(0) <= int2slv(0,IC_INDEX);
 
        interruptions_enabled <= w_interruptions_enabled;
        interruption_flags <= w_interruption_flags;
        jump_address <= w_addresses(slv2nat(interruption_value)); 
end architecture;
