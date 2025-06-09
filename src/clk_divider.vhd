library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk_divider is
    Port (
        clk           : in  STD_LOGIC;
        refresh_phase : out STD_LOGIC_VECTOR(1 downto 0)
    );
end clk_divider;

architecture Behavioral of clk_divider is
    signal count : unsigned(15 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;

    refresh_phase <= std_logic_vector(count(15 downto 14));

end Behavioral;
