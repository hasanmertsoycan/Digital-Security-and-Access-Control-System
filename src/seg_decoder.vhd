library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seg_decoder is
    Port (
        digit_value : in  STD_LOGIC_VECTOR(3 downto 0);
        segments    : out STD_LOGIC_VECTOR(6 downto 0)
    );
end seg_decoder;

architecture lookup of seg_decoder is
begin

    process(digit_value)
    begin
        case digit_value is
            when "0000" => segments <= "0000001"; -- 0
            when "0001" => segments <= "1001111"; -- 1
            when "0010" => segments <= "0010010"; -- 2
            when "0011" => segments <= "0000110"; -- 3
            when "0100" => segments <= "1001100"; -- 4
            when "0101" => segments <= "0100100"; -- 5
            when "0110" => segments <= "0100000"; -- 6
            when "0111" => segments <= "0001111"; -- 7
            when "1000" => segments <= "0000000"; -- 8
            when "1001" => segments <= "0000100"; -- 9
            when "1010" => segments <= "0000010"; -- A
            when "1011" => segments <= "1100000"; -- B
            when "1100" => segments <= "0110001"; -- C
            when "1101" => segments <= "1000010"; -- D
            when "1110" => segments <= "0110000"; -- E
            when "1111" => segments <= "0111000"; -- F
            when others => segments <= "1111111"; -- Blank
        end case;
    end process;

end lookup;
