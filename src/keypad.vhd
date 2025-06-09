library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity keypad is
    Port (
        clk       : in  STD_LOGIC;
        rows      : out STD_LOGIC_VECTOR(3 downto 0);
        cols      : in  STD_LOGIC_VECTOR(3 downto 0);
        key       : out STD_LOGIC_VECTOR(3 downto 0);
        key_valid : out STD_LOGIC
    );
end keypad;

architecture Behavioral of keypad is

    signal row_sel      : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal clk_count    : INTEGER := 0;
    signal debounce     : INTEGER := 0;
    signal key_temp     : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal valid        : STD_LOGIC := '0';

    constant debounce_limit : INTEGER := 200000;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            clk_count <= clk_count + 1;
            if clk_count = 50000 then
                clk_count <= 0;
                row_sel <= std_logic_vector(unsigned(row_sel) + 1);
            end if;

            case row_sel is
                when "00" => rows <= "1110";
                when "01" => rows <= "1101";
                when "10" => rows <= "1011";
                when others => rows <= "0111";
            end case;

            if debounce = 0 then
                if cols = "1110" or cols = "1101" or cols = "1011" or cols = "0111" then
                    valid <= '1';

                    case row_sel is
                        when "00" =>
                            case cols is
                                when "1110" => key_temp <= "0001";
                                when "1101" => key_temp <= "0010";
                                when "1011" => key_temp <= "0011";
                                when "0111" => key_temp <= "1010";
                                when others => valid <= '0';
                            end case;

                        when "01" =>
                            case cols is
                                when "1110" => key_temp <= "0100";
                                when "1101" => key_temp <= "0101";
                                when "1011" => key_temp <= "0110";
                                when "0111" => key_temp <= "1011";
                                when others => valid <= '0';
                            end case;

                        when "10" =>
                            case cols is
                                when "1110" => key_temp <= "0111";
                                when "1101" => key_temp <= "1000";
                                when "1011" => key_temp <= "1001";
                                when "0111" => key_temp <= "1100";
                                when others => valid <= '0';
                            end case;

                        when others =>
                            case cols is
                                when "1110" => key_temp <= "1110";
                                when "1101" => key_temp <= "0000";
                                when "1011" => key_temp <= "1111";
                                when "0111" => key_temp <= "1101";
                                when others => valid <= '0';
                            end case;
                    end case;

                    debounce <= debounce + 1;
                else
                    valid <= '0';
                end if;

            else
                debounce <= debounce + 1;
                if debounce > debounce_limit then
                    debounce <= 0;
                    valid <= '0';
                end if;
            end if;
        end if;
    end process;

    key       <= key_temp;
    key_valid <= valid;

end Behavioral;
