# Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.0 [get_ports clk]

# Verify Button
set_property PACKAGE_PIN U18 [get_ports verify_btn]
set_property IOSTANDARD LVCMOS33 [get_ports verify_btn]

# Keypad Rows
set_property PACKAGE_PIN J1 [get_ports {rows[0]}]
set_property PACKAGE_PIN L2 [get_ports {rows[1]}]
set_property PACKAGE_PIN J2 [get_ports {rows[2]}]
set_property PACKAGE_PIN G2 [get_ports {rows[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rows[*]}]

# Keypad Columns
set_property PACKAGE_PIN H1 [get_ports {cols[0]}]
set_property PACKAGE_PIN K2 [get_ports {cols[1]}]
set_property PACKAGE_PIN H2 [get_ports {cols[2]}]
set_property PACKAGE_PIN G3 [get_ports {cols[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cols[*]}]

# Servo PWM Output
set_property PACKAGE_PIN K17 [get_ports {pwm_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out}]

# Progress LEDs
set_property PACKAGE_PIN A14 [get_ports {progress_leds[0]}]
set_property PACKAGE_PIN A16 [get_ports {progress_leds[1]}]
set_property PACKAGE_PIN B15 [get_ports {progress_leds[2]}]
set_property PACKAGE_PIN B16 [get_ports {progress_leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {progress_leds[*]}]

# 7-Segment Display Segments
set_property PACKAGE_PIN W7 [get_ports {display_segments[6]}]
set_property PACKAGE_PIN W6 [get_ports {display_segments[5]}]
set_property PACKAGE_PIN U8 [get_ports {display_segments[4]}]
set_property PACKAGE_PIN V8 [get_ports {display_segments[3]}]
set_property PACKAGE_PIN U5 [get_ports {display_segments[2]}]
set_property PACKAGE_PIN V5 [get_ports {display_segments[1]}]
set_property PACKAGE_PIN U7 [get_ports {display_segments[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_segments[*]}]

# 7-Segment Display Anodes
set_property PACKAGE_PIN W4 [get_ports {display_anodes[0]}]
set_property PACKAGE_PIN V4 [get_ports {display_anodes[1]}]
set_property PACKAGE_PIN U4 [get_ports {display_anodes[2]}]
set_property PACKAGE_PIN U2 [get_ports {display_anodes[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display_anodes[*]}]

# LEDs
set_property PACKAGE_PIN L17 [get_ports led0]
set_property PACKAGE_PIN M19 [get_ports led1]
set_property PACKAGE_PIN P17 [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports {led0}]
set_property IOSTANDARD LVCMOS33 [get_ports {led1}]
set_property IOSTANDARD LVCMOS33 [get_ports {led2}]

# Buzzer
set_property PACKAGE_PIN R18 [get_ports buzzer]
set_property IOSTANDARD LVCMOS33 [get_ports buzzer]

# PIR Sensor
set_property PACKAGE_PIN M18 [get_ports pir_in]
set_property IOSTANDARD LVCMOS33 [get_ports pir_in]
set_property PACKAGE_PIN N17 [get_ports pir_out]
set_property IOSTANDARD LVCMOS33 [get_ports pir_out]
