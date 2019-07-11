-- rmake simgui --top=ArtyS7_Replay_Top

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_textio.all;

  use std.textio.ALL;
  use work.Replay_Pack.all;

entity a_Pacman_ArtyS7_Tb is
end;

architecture rtl of a_Pacman_ArtyS7_Tb is

  constant clk_a_period : time := 1 us / 100; -- MHz

  signal clk_a       : bit1;
  signal por_l       : bit1;
  signal button      : word( 2 downto 0);
  signal pmod_button : word( 3 downto 0);
  signal sw          : word( 3 downto 0);

  signal hsync       : bit1;
  signal vsync       : bit1;
  signal video_r     : word( 3 downto 0);
  signal video_g     : word( 3 downto 0);
  signal video_b     : word( 3 downto 0);
  signal audio       : bit1;

  signal video_data  : word(23 downto 0);
  signal video_clk   : bit1;
  signal video_de    : bit1;

begin
  p_clk_gen_a : process
  begin
    clk_a <= '1';
    wait for clk_a_period/2;
    clk_a <= '0';
    wait for clk_a_period - (clk_a_period/2 );
  end process;

  p_rst                  : process
  begin
    por_l <= '0';
    wait for 500.0 ns;
    por_l <= '1';
    wait;
  end process;

  button      <= (others => '0');
  pmod_button <= (others => '0');
  sw          <= (others => '0');

  u_top : entity work.ArtyS7_Replay_Top
  port map (
    i_button       => button,
    i_pmod_button  => pmod_button,
    i_sw           => sw,
    o_led          => open,

    o_hysnc        => hsync,
    o_vsync        => vsync,
    o_video_r      => video_r,
    o_video_g      => video_g,
    o_video_b      => video_b,

    o_video_de     => video_de,
    o_video_clk    => video_clk,

    o_audio        => audio,

    i_reset_l      => por_l,
    i_clk_ref      => clk_a
  );

  video_data(23 downto 20) <= video_r;
  video_data(19 downto 16) <= "0000";
  video_data(15 downto 12) <= video_g;
  video_data(11 downto  8) <= "0000";
  video_data( 7 downto  4) <= video_b;
  video_data( 3 downto  0) <= "0000";

  vga_bmp : entity work.vga_bmp_sink
  generic map ( FILENAME => "vga.bmp" )
  port map (
    clk_i           => video_clk,
    dat_i           => video_data,
    active_vid_i    => video_de,
    h_sync_i        => hsync,
    v_sync_i        => vsync
  );

end;