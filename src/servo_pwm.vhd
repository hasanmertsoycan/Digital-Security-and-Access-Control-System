library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity servo_pwm is
    Port (
        clk      : in  STD_LOGIC;
        position : in  STD_LOGIC;
        pwm_out  : out STD_LOGIC
    );
end servo_pwm;

architecture Behavioral of servo_pwm is
    signal counter      : INTEGER := 0;
    signal pulse_width  : INTEGER := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if counter < 2000000 then
                counter <= counter + 1;
            else
                counter <= 0;
            end if;

            if position = '1' then
                pulse_width <= 200000;  -- Approx. 2ms pulse for "open"
            else
                pulse_width <= 100000;  -- Approx. 1ms pulse for "closed"
            end if;

            if counter < pulse_width then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
        end if;
    end process;

end Behavioral;
