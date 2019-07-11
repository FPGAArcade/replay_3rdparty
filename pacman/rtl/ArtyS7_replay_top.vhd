
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;


  use work.Replay_Pack.all;
  use work.Replay_CoreIO_Pack.all;

entity ArtyS7_Replay_Top is
  port (
    i_button       : in  word(2 downto 0); -- active high, pull downs on board
    i_pmod_button  : in  word(3 downto 0); -- active high
    i_sw           : in  word(3 downto 0);
    o_led          : out word(3 downto 0);

    o_hysnc        : out bit1;
    o_vsync        : out bit1;

    o_video_r      : out word(3 downto 0);
    o_video_g      : out word(3 downto 0);
    o_video_b      : out word(3 downto 0);

    -- quick sim bodge
    o_video_de     : out bit1;
    o_video_clk    : out bit1;

    o_audio        : out bit1;

    i_reset_l      : in  bit1;
    i_clk_ref      : in  bit1
    );
end;
-- use V4 target

architecture RTL of ArtyS7_Replay_Top is

  signal pll_reset              : bit1;
  signal pll_locked             : bit1;
  signal sys_cnt                : word(1 downto 0) := (others => '0');
  --
  signal clk_sys                : bit1;
  signal ena_sys                : bit1;
  signal rst_sys                : bit1;

  signal cfg_static             : word(31 downto 0);
  signal cfg_dynamic            : word(31 downto 0);
  --
  signal button                 : word( 2 downto 0);
  signal joy_a                  : word( 5 downto 0);
  signal joy_b                  : word( 5 downto 0);

  -- ROM interface
  signal rom_read               : bit1;
  signal rom_addr               : word(15 downto 0);
  signal rom_data               : word( 7 downto 0);
  -- AV from core
  signal audio                  : word(15 downto 0);
  signal hsync_l                : bit1;
  signal vsync_l                : bit1;
  signal csync_l                : bit1;
  signal blank                  : bit1;
  signal video_rgb              : word(23 downto 0);

  -- scan doubler
  signal dbl_hsync_l            : bit1;
  signal dbl_vsync_l            : bit1;
  signal dbl_csync_l            : bit1;
  signal dbl_blank              : bit1;
  signal dbl_rgb                : word(23 downto 0);

  -- output
  signal vid_rgb_c              : word(23 downto 0);
  signal pcm                    : word(19 downto 0);

  -- leds
  signal tick_pre1              : bit1;
  signal tick                   : bit1;
  signal led_cnt                : word( 2 downto 0);
  signal led                    : bit1;

  component clk_wiz_0_clk_wiz
    port (
      clk_out1 : out std_logic;
      reset    : in  std_logic;
      locked   : out std_logic;
      clk_in1  : in  std_logic
      );
  end component;

  component hifi_1bit_dac port (
    reset    : in  bit1;
    clk      : in  bit1;
    clk_ena  : in  bit1;
    pcm_in   : in  word(19 downto 0);
    dac_out  : out bit1
  );
  end component;

begin
  --
  -- clocks / reset
  --
  pll_reset <= not i_reset_l;

  u_clock : clk_wiz_0_clk_wiz
  port map (
    clk_out1 => clk_sys,
    reset    => pll_reset,
    locked   => pll_locked,
    clk_in1  => i_clk_ref
  );

  p_sys_rst : process(clk_sys, pll_reset)
  begin
    if (pll_reset = '1') then
      rst_sys <= '1';
    elsif rising_edge(clk_sys) then
      if (pll_locked = '1') then
        rst_sys <= '0';
      end if;
    end if;
  end process;

  p_sys_cnt : process
  begin
    wait until rising_edge(clk_sys);
    sys_cnt <= sys_cnt + "1";

    ena_sys <= '0';
    if (sys_cnt = "10" ) then
      ena_sys <= '1';
    end if;
  end process;

  --24.576 (x4)
  --xc7s50csga324-1 (active)

  cfg_static(31 downto 1) <= (others => '0');
  cfg_static(0) <= '0'; -- pacman/pengo

  cfg_dynamic(31 downto 24) <= "00000000"; -- dipsw2
  cfg_dynamic(23 downto 12) <= (others => '0');
  cfg_dynamic(11) <= '0'; -- service
  cfg_dynamic(10) <= '0'; -- dip_test
  cfg_dynamic( 9) <= '0'; -- table
  cfg_dynamic( 8) <= '0'; -- test
  cfg_dynamic( 7 downto  0) <= "00110111"; -- dipsw1

  -- active high
  --i_joy_a(1);   -- p1 down
  --i_joy_a(3);   -- p1 right
  --i_joy_a(2);   -- p1 left
  --i_joy_a(0);   -- p1 up
  --i_button(2);  -- coin1
  --i_button(1);  -- start 2
  --i_button(0);  -- start 1
  joy_a <= "00" & i_pmod_button;
  joy_b <= (others => '0');
  --
  -- The Core
  --
  u_Core : entity work.Pacman_Top
  generic map (
    g_use_init            => true
    )
  port map (
    --
    i_clk_sys             => clk_sys,
    i_ena_sys             => ena_sys,
    i_rst_sys             => rst_sys,
    --
    i_cfg_static          => cfg_static,
    i_cfg_dynamic         => cfg_dynamic,

    i_halt                => '0',
    --
    i_joy_a               => joy_a,
    i_joy_b               => joy_b,
    --
    i_button              => i_button(2 downto 0),
    --
    o_rom_read            => rom_read,
    o_rom_addr            => rom_addr,
    i_rom_data            => rom_data,
    --
    i_cfgio_to_core       => z_Cfgio_to_core,
    o_cfgio_fm_core       => open,

    --
    o_video_rgb           => video_rgb,
    o_hsync_l             => hsync_l,
    o_vsync_l             => vsync_l,
    o_csync_l             => csync_l,
    o_blank               => blank,
    --
    o_audio               => audio
    );

    -- ROMs
  u_Program_ROM : entity work.Pacman_Program_ROM
  port map (
      -- ARM interface
      i_cfgio_to_core             => z_cfgio_to_core,
      --
      i_cfgio_fm_core             => z_cfgio_fm_core,
      o_cfgio_fm_core             => open,
      --
      i_clk_sys                   => clk_sys,
      i_ena_sys                   => ena_sys,
      -- Core interface
      i_addr                      => rom_addr(13 downto 0),
      o_data                      => rom_data,
      --
      i_clk                       => clk_sys,
      i_ena                       => ena_sys
      );

  -- scan doubler
  u_DblScan : entity work.Replay_DblScan
  port map (
    -- clocks
    i_clk                 => clk_sys,
    i_ena                 => ena_sys, -- not used
    i_rst                 => rst_sys,
    --
    i_bypass              => '0',
    i_dblscan             => '1',
    --
    i_hsync_l             => hsync_l,
    i_vsync_l             => vsync_l,
    i_csync_l             => csync_l,
    i_blank               => blank,
    i_vid_rgb             => video_rgb,
    --
    o_hsync_l             => dbl_hsync_l,
    o_vsync_l             => dbl_vsync_l,
    o_csync_l             => dbl_csync_l,
    o_blank               => dbl_blank,
    o_vid_rgb             => dbl_rgb
    );

  p_clamp : process(dbl_blank, dbl_rgb)
  begin
    vid_rgb_c <= dbl_rgb;
    if (dbl_blank = '1') then
      vid_rgb_c <= (others => '0');
    end if;
  end process;

  o_hysnc    <= dbl_hsync_l;
  o_vsync    <= dbl_vsync_l;

  o_video_r  <= vid_rgb_c(23 downto 20);
  o_video_g  <= vid_rgb_c(15 downto 12);
  o_video_b  <= vid_rgb_c( 7 downto  4);

  p_video_debug : process(dbl_blank, clk_sys)
  begin
    o_video_de  <= 'Z';
    --o_video_clk <= 'Z';
    -- synopsys translate_off
    o_video_de  <= not dbl_blank;
    --o_video_clk <= clk_sys;
    -- synopsys translate_on
  end process;

  o_video_clk <= clk_sys;

  pcm <= audio & "0000";

  u_dac_l : hifi_1bit_dac
  port map (
    reset    => rst_sys,
    clk      => clk_sys,
    clk_ena  => '1',
    pcm_in   => pcm,
    dac_out  => o_audio
  );

  b_tick : block
    signal precounter1 : word(15 downto 0);
    signal precounter2 : word(11 downto 0);
  begin
    p_count : process
    begin
      wait until rising_edge(clk_sys);
      if (ena_sys = '1') then
        precounter1 <= precounter1 - "1";

        tick_pre1 <= '0';
        if (precounter1 = x"0000") then
          tick_pre1 <= '1';
        end if;
        -- synopsys translate_off
        tick_pre1 <= '1';
        -- synopsys translate_on

        -- 375 hz pre1 /4 with ena
        tick <= '0';
        if (tick_pre1 = '1') then
          if (precounter2 = x"000") then
            precounter2 <= x"0BB";
            tick <= '1';
          else
            precounter2 <= precounter2 - "1";
          end if;
        end if;
      end if;
    end process;
  end block;

  p_leds : process
  begin
    wait until rising_edge(clk_sys);
    if (ena_sys = '1') then
      if (tick = '1') then
        led     <= not led;
        led_cnt <= led_cnt + "1";
      end if;
    end if;
  end process;

  o_led(3 downto 1) <= "000";
  o_led(0) <= led;

end RTL;