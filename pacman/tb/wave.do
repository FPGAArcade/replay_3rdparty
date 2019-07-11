onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_pacman_artys7_tb/clk_a
add wave -noupdate /a_pacman_artys7_tb/por_l
add wave -noupdate /a_pacman_artys7_tb/button
add wave -noupdate /a_pacman_artys7_tb/pmod_button
add wave -noupdate /a_pacman_artys7_tb/sw
add wave -noupdate -divider {New Divider}
add wave -noupdate /a_pacman_artys7_tb/hsync
add wave -noupdate /a_pacman_artys7_tb/vsync
add wave -noupdate /a_pacman_artys7_tb/video_r
add wave -noupdate /a_pacman_artys7_tb/video_g
add wave -noupdate /a_pacman_artys7_tb/video_b
add wave -noupdate /a_pacman_artys7_tb/video_data
add wave -noupdate /a_pacman_artys7_tb/video_clk
add wave -noupdate /a_pacman_artys7_tb/video_de
add wave -noupdate /a_pacman_artys7_tb/audio
add wave -noupdate -divider {New Divider}
add wave -noupdate /a_pacman_artys7_tb/u_top/u_Program_ROM/i_addr
add wave -noupdate /a_pacman_artys7_tb/u_top/u_Program_ROM/o_data
add wave -noupdate /a_pacman_artys7_tb/u_top/u_Program_ROM/i_clk
add wave -noupdate /a_pacman_artys7_tb/u_top/u_Program_ROM/i_ena
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {271974478 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 258
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {647111688 ps}
