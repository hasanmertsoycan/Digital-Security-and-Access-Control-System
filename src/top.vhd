library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (
        clk               : in  STD_LOGIC;
        verify_btn        : in  STD_LOGIC;
        rows              : out STD_LOGIC_VECTOR(3 downto 0);
        cols              : in  STD_LOGIC_VECTOR(3 downto 0);
        pwm_out           : out STD_LOGIC;
        display_anodes    : out STD_LOGIC_VECTOR(3 downto 0);
        display_segments  : out STD_LOGIC_VECTOR(6 downto 0);
        progress_leds     : out STD_LOGIC_VECTOR(3 downto 0);
        buzzer            : out STD_LOGIC;
        led0              : out STD_LOGIC;
        led1              : out STD_LOGIC;
        led2              : out STD_LOGIC;
        pir_in            : in  STD_LOGIC;
        pir_out           : out STD_LOGIC
    );
end top;

architecture Behavioral of top is

    type state_type is (
        IDLE, DIGIT1, DIGIT2, DIGIT3,
        CHECK, OPEN_STATE, WAIT_10S, CLOSE,
        LOCKED_WAIT, LOCKED_ALARM
    );

    signal state            : state_type := IDLE;
    signal input_code       : STD_LOGIC_VECTOR(15 downto 0);
    signal correct_code     : STD_LOGIC_VECTOR(15 downto 0) := "0001001010000011";
    signal key              : STD_LOGIC_VECTOR(3 downto 0);
    signal key_valid        : STD_LOGIC;
    signal position         : STD_LOGIC := '0';
    signal timer            : INTEGER := 0;
    signal alarm_timer      : INTEGER := 0;
    signal alarm_cycle      : INTEGER range 0 to 80 := 0;
    signal buzzer_on        : STD_LOGIC := '0';
    signal fail_count       : INTEGER range 0 to 3 := 0;
    signal progress         : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal entered_digits   : INTEGER range 0 to 4 := 0;
    signal verify_btn_prev  : STD_LOGIC := '0';
    signal verify_edge      : STD_LOGIC := '0';
    signal debounce_count   : INTEGER := 0;

    constant debounce_max      : INTEGER := 50000000;
    constant check_delay       : INTEGER := 100000000;
    constant locked_wait_time  : INTEGER := 100000000;
    constant half_cycle_time   : INTEGER := 37500000;

    signal refresh_phase : STD_LOGIC_VECTOR(1 downto 0);

    component keypad
        Port (
            clk       : in  STD_LOGIC;
            rows      : out STD_LOGIC_VECTOR(3 downto 0);
            cols      : in  STD_LOGIC_VECTOR(3 downto 0);
            key       : out STD_LOGIC_VECTOR(3 downto 0);
            key_valid : out STD_LOGIC
        );
    end component;

    component servo_pwm
        Port (
            clk      : in  STD_LOGIC;
            position : in  STD_LOGIC;
            pwm_out  : out STD_LOGIC
        );
    end component;

    component clk_divider
        Port (
            clk            : in  STD_LOGIC;
            refresh_phase  : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    component display_driver
        Port (
            input_code      : in  STD_LOGIC_VECTOR(15 downto 0);
            entered_digits  : in  INTEGER range 0 to 4;
            refresh_phase   : in  STD_LOGIC_VECTOR(1 downto 0);
            display_anodes  : out STD_LOGIC_VECTOR(3 downto 0);
            display_segments: out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

begin

    keypad_inst: keypad port map(
        clk       => clk,
        rows      => rows,
        cols      => cols,
        key       => key,
        key_valid => key_valid
    );

    servo_inst: servo_pwm port map(
        clk      => clk,
        position => position,
        pwm_out  => pwm_out
    );

    clk_div_inst: clk_divider port map(
        clk            => clk,
        refresh_phase  => refresh_phase
    );

    display_inst: display_driver port map(
        input_code      => input_code,
        entered_digits  => entered_digits,
        refresh_phase   => refresh_phase,
        display_anodes  => display_anodes,
        display_segments=> display_segments
    );

    process(clk)
    begin
        if rising_edge(clk) then
            verify_edge <= '0';
            if debounce_count = 0 then
                if verify_btn = '1' and verify_btn_prev = '0' then
                    verify_edge    <= '1';
                    debounce_count <= debounce_count + 1;
                end if;
            else
                if debounce_count < debounce_max then
                    debounce_count <= debounce_count + 1;
                else
                    debounce_count <= 0;
                end if;
            end if;
            verify_btn_prev <= verify_btn;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            case state is

                when IDLE =>
                    buzzer_on <= '0';
                    if fail_count = 3 then
                        timer <= 0;
                        state <= LOCKED_WAIT;
                    elsif verify_edge = '1' and key_valid = '1' then
                        input_code(15 downto 12) <= key;
                        state <= DIGIT1;
                    end if;

                when DIGIT1 =>
                    if verify_edge = '1' and key_valid = '1' then
                        input_code(11 downto 8) <= key;
                        state <= DIGIT2;
                    end if;

                when DIGIT2 =>
                    if verify_edge = '1' and key_valid = '1' then
                        input_code(7 downto 4) <= key;
                        state <= DIGIT3;
                    end if;

                when DIGIT3 =>
                    if verify_edge = '1' and key_valid = '1' then
                        input_code(3 downto 0) <= key;
                        timer <= 0;
                        state <= CHECK;
                    end if;

                when CHECK =>
                    if timer < check_delay then
                        timer <= timer + 1;
                    else
                        timer <= 0;
                        if input_code = correct_code then
                            fail_count <= 0;
                            state <= OPEN_STATE;
                        else
                            position <= '0';
                            if fail_count < 3 then
                                fail_count <= fail_count + 1;
                            end if;
                            state <= IDLE;
                        end if;
                    end if;

                when OPEN_STATE =>
                    position <= '1';
                    timer <= 0;
                    state <= WAIT_10S;

                when WAIT_10S =>
                    if timer < 1000000000 then
                        timer <= timer + 1;
                    else
                        state <= CLOSE;
                    end if;

                when CLOSE =>
                    position <= '0';
                    state <= IDLE;

                when LOCKED_WAIT =>
                    buzzer_on <= '0';
                    if timer < locked_wait_time then
                        timer <= timer + 1;
                    else
                        timer <= 0;
                        alarm_cycle <= 0;
                        alarm_timer <= 0;
                        state <= LOCKED_ALARM;
                    end if;

                when LOCKED_ALARM =>
                    if alarm_timer < half_cycle_time then
                        alarm_timer <= alarm_timer + 1;
                    else
                        alarm_timer <= 0;
                        alarm_cycle <= alarm_cycle + 1;
                        buzzer_on <= not buzzer_on;
                    end if;

                    if alarm_cycle = 80 then
                        alarm_cycle <= 0;
                        buzzer_on <= '0';
                        fail_count <= 0;
                        state <= IDLE;
                    end if;

                when others =>
                    state <= IDLE;

            end case;
        end if;
    end process;

    process(state)
    begin
        case state is
            when IDLE        => entered_digits <= 0; progress <= "0000";
            when DIGIT1      => entered_digits <= 1; progress <= "0001";
            when DIGIT2      => entered_digits <= 2; progress <= "0011";
            when DIGIT3      => entered_digits <= 3; progress <= "0111";
            when CHECK       => entered_digits <= 4; progress <= "1111";
            when others      => entered_digits <= 0; progress <= "0000";
        end case;
    end process;

    progress_leds <= progress;

    led0 <= buzzer_on when state = LOCKED_ALARM else
            '1' when fail_count >= 1 else '0';

    led1 <= buzzer_on when state = LOCKED_ALARM else
            '1' when fail_count >= 2 else '0';

    led2 <= buzzer_on when state = LOCKED_ALARM else
            '1' when fail_count = 3 else '0';

    buzzer   <= buzzer_on;
    pir_out  <= '1' when pir_in = '1' else '0';

end Behavioral;
