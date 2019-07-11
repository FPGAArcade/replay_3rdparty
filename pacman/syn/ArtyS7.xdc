
# "GCLK"  -- Bank 34
set_property PACKAGE_PIN R2 [get_ports i_clk_ref]
create_clock -period 10.000 -name clk [get_ports i_clk_ref]

# ----------------------------------------------------------------------------
# User LEDs - Bank 14  - 3.3V
# ----------------------------------------------------------------------------

# looking at pmod connector
# vcc gnd
#  6  5  4  3  2  1
# 12 11 10  9  8  7

set_property PACKAGE_PIN L17 [get_ports {o_video_r[0]}]
set_property PACKAGE_PIN L18 [get_ports {o_video_r[1]}]
set_property PACKAGE_PIN M14 [get_ports {o_video_r[2]}]
set_property PACKAGE_PIN N14 [get_ports {o_video_r[3]}]

set_property PACKAGE_PIN M16 [get_ports {o_video_b[0]}]
set_property PACKAGE_PIN M17 [get_ports {o_video_b[1]}]
set_property PACKAGE_PIN M18 [get_ports {o_video_b[2]}]
set_property PACKAGE_PIN N18 [get_ports {o_video_b[3]}]

set_property PACKAGE_PIN P17 [get_ports {o_video_g[0]}]
set_property PACKAGE_PIN P18 [get_ports {o_video_g[1]}]
set_property PACKAGE_PIN R18 [get_ports {o_video_g[2]}]
set_property PACKAGE_PIN T18 [get_ports {o_video_g[3]}]

set_property PACKAGE_PIN P14 [get_ports o_hysnc]
set_property PACKAGE_PIN P15 [get_ports o_vsync]
set_property PACKAGE_PIN N15 [get_ports o_video_de]
set_property PACKAGE_PIN P16 [get_ports o_video_clk]

# Up # Blue Wire
set_property PACKAGE_PIN U15 [get_ports {i_pmod_button[0]}]
set_property PULLDOWN true [get_ports {i_pmod_button[0]}]

# Down # Red Wire
set_property PACKAGE_PIN V16 [get_ports {i_pmod_button[1]}]
set_property PULLDOWN true [get_ports {i_pmod_button[1]}]


# Left # Green Wire
set_property PACKAGE_PIN U17 [get_ports {i_pmod_button[2]}]
set_property PULLDOWN true [get_ports {i_pmod_button[2]}]

# Right # White Wire
set_property PACKAGE_PIN U18 [get_ports {i_pmod_button[3]}]
set_property PULLDOWN true [get_ports {i_pmod_button[3]}]


set_property PACKAGE_PIN G15 [get_ports {i_button[0]}]
set_property PACKAGE_PIN K16 [get_ports {i_button[1]}]
set_property PACKAGE_PIN J16 [get_ports {i_button[2]}]
set_property PACKAGE_PIN H13 [get_ports {i_button[3]}]


# ----------------------------------------------------------------------------
# Audio - Bank 14  - 3.3V
# ----------------------------------------------------------------------------

# DAC Out to Line out - 3.3k +4.7nF Tiefpass erford.
##JD10
set_property PACKAGE_PIN U11 [get_ports o_audio]
set_property DRIVE 16 [get_ports o_audio]
set_property SLEW SLOW [get_ports o_audio]


# Reset
set_property PACKAGE_PIN C18 [get_ports i_reset_l]

# ----------------------------------------------------------------------------
# User LEDs - Bank 15  - 3.3V
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN E18 [get_ports {o_led[0]}]
set_property PACKAGE_PIN F13 [get_ports {o_led[1]}]
set_property PACKAGE_PIN E13 [get_ports {o_led[2]}]
set_property PACKAGE_PIN H15 [get_ports {o_led[3]}]

# ----------------------------------------------------------------------------
# User DIP Switches - Bank 15
# ----------------------------------------------------------------------------
# on board
set_property PACKAGE_PIN H14 [get_ports {i_sw[0]}]
set_property PACKAGE_PIN H18 [get_ports {i_sw[1]}]
set_property PACKAGE_PIN G18 [get_ports {i_sw[2]}]
set_property PACKAGE_PIN M5  [get_ports {i_sw[3]}]


# Note that the bank voltage for IO Bank 15 is fixed to 3.3V on Arty.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 15]]

# Set the bank voltage for IO Bank 34 to 3.3V by default.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]]

# Set the bank voltage for IO Bank 14 to 3.3V by default.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 14]]


set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]