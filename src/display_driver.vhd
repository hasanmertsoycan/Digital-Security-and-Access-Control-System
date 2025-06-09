library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
    Port (
        input_code       : in  STD_LOGIC_VECTOR(15 downto 0);
        entered_digits   : in  integer range 0 to 4;
        refresh_phase    : in  STD_LOGIC_VECTOR(1 downto 0);
        display_anodes   : out STD_LOGIC_VECTOR(3 downto 0);
        display_segments : out STD_LOGIC_VECTOR(6 downto 0)
    );
end display_driver;

architecture Behavioral of display_driver is

    signal current_digit       : STD_LOGIC_VECTOR(3 downto 0);
    signal active_digit_index  : integer range 0 to 3;
    signal show_blank          : boolean;
    signal segments_raw        : STD_LOGIC_VECTOR(6 downto 0);

    component seg_decoder
        Port (
            digit_value : in  STD_LOGIC_VECTOR(3 downto 0);
            segments    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

begin

    process(refresh_phase, input_code, entered_digits)
    begin
        show_blank <= false;

        case refresh_phase is
            when "00" =>
                current_digit      <= input_code(15 downto 12);
                display_anodes     <= "1110";
                active_digit_index <= 0;

            when "01" =>
                current_digit      <= input_code(11 downto 8);
                display_anodes     <= "1101";
                active_digit_index <= 1;

            when "10" =>
                current_digit      <= input_code(7 downto 4);
                display_anodes     <= "1011";
                active_digit_index <= 2;

            when others =>
                current_digit      <= input_code(3 downto 0);
                display_anodes     <= "0111";
                active_digit_index <= 3;
        end case;

        if active_digit_index >= entered_digits then
            show_blank <= true;
        end if;
    end process;

    decoder_inst: seg_decoder
        port map(
            digit_value => current_digit,
            segments    => segments_raw
        );

    display_segments <= segments_raw when not show_blank else "1111111";

end Behavioral;
