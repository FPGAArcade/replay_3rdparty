-- WWW.FPGAArcade.COM
-- REPLAY 1.0
-- Retro Gaming Platform
-- No Emulation No Compromise
--
-- All rights reserved
-- Mike Johnson
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- You are responsible for any legal issues arising from your use of this code.
--
-- The latest version of this file can be found at: www.FPGAArcade.com
--
-- Email support@fpgaarcade.com

-- Note, this is not used any more - DRAM is used as Pengo has 32K of ROM.
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;
  use work.Replay_CoreIO_Pack.all;

entity Pacman_Program_ROM is
  port (
    -- ARM interface
    i_cfgio_to_core             : in  r_cfgio_to_core := z_cfgio_to_core;
    --
    i_cfgio_fm_core             : in  r_cfgio_fm_core := z_cfgio_fm_core; -- cascade input. Must be z_cfgio_fm_core on first memory
    o_cfgio_fm_core             : out r_cfgio_fm_core; -- output back to LIB, or cascade into i_cfgio_fm_core on next memory
    --
    i_clk_sys                   : in  bit1 := '0';
    i_ena_sys                   : in  bit1 := '0';
    -- Core interface
    i_addr                      : in  word(13 downto 0);
    o_data                      : out word( 7 downto 0);
    --
    i_clk                       : in  bit1;
    i_ena                       : in  bit1
    );
end;

architecture RTL of Pacman_Program_ROM is

  signal cfgio_ram_0            : r_cfgio_fm_core;
  signal cfgio_ram_1            : r_cfgio_fm_core;
  signal cfgio_ram_2            : r_cfgio_fm_core;
  signal cfgio_ram_3            : r_cfgio_fm_core;
  --
  signal rom_data_0             : word(7 downto 0);
  signal rom_data_1             : word(7 downto 0);
  signal rom_data_2             : word(7 downto 0);
  signal rom_data_3             : word(7 downto 0);
  signal rom_data               : word(7 downto 0);


begin
  -- note, the config space address does not need to match the core address space

  u_rom_6E : entity work.Cfg_RAM_W8
  generic map (
    g_depth => 12,
    g_addr  => x"00000000",
    g_mask  => x"0000F000", -- compare bits
    g_use_init           => true,
    g_hex_init_filename => "pacrom_6e.hex"
    )
  port map (
    -- ARM interface
    i_cfgio_to_core             => i_cfgio_to_core, -- wired in parallel to all memories

    i_cfgio_fm_core             => i_cfgio_fm_core, -- cascade input
    o_cfgio_fm_core             => cfgio_ram_0,
    i_clk_sys                   => i_clk_sys,
    i_ena_sys                   => i_ena_sys,
    --
    i_addr                      => i_addr(11 downto 0),
    i_data                      => x"00",
    i_ena                       => i_ena,
    i_wen                       => '0',
    o_data                      => rom_data_0,
    --
    i_clk                       => i_clk
    );

  u_rom_6F : entity work.Cfg_RAM_W8
  generic map (
    g_depth => 12,
    g_addr  => x"00001000",
    g_mask  => x"0000F000", -- compare bits
    g_use_init           => true,
    g_hex_init_filename => "pacrom_6f.hex"
    )
  port map (
    -- ARM interface
    i_cfgio_to_core             => i_cfgio_to_core, -- wired in parallel to all memories

    i_cfgio_fm_core             => cfgio_ram_0, -- cascade input
    o_cfgio_fm_core             => cfgio_ram_1,
    i_clk_sys                   => i_clk_sys,
    i_ena_sys                   => i_ena_sys,
    --
    i_addr                      => i_addr(11 downto 0),
    i_data                      => x"00",
    i_ena                       => i_ena,
    i_wen                       => '0',
    o_data                      => rom_data_1,
    --
    i_clk                       => i_clk
    );

  u_rom_6H : entity work.Cfg_RAM_W8
  generic map (
    g_depth => 12,
    g_addr  => x"00002000",
    g_mask  => x"0000F000", -- compare bits
    g_use_init           => true,
    g_hex_init_filename => "pacrom_6h.hex"
    )
  port map (
    -- ARM interface
    i_cfgio_to_core             => i_cfgio_to_core, -- wired in parallel to all memories

    i_cfgio_fm_core             => cfgio_ram_1, -- cascade input
    o_cfgio_fm_core             => cfgio_ram_2,
    i_clk_sys                   => i_clk_sys,
    i_ena_sys                   => i_ena_sys,
    --
    i_addr                      => i_addr(11 downto 0),
    i_data                      => x"00",
    i_ena                       => i_ena,
    i_wen                       => '0',
    o_data                      => rom_data_2,
    --
    i_clk                       => i_clk
    );

  u_rom_6J : entity work.Cfg_RAM_W8
  generic map (
    g_depth => 12,
    g_addr  => x"00003000",
    g_mask  => x"0000F000", -- compare bits
    g_use_init           => true,
    g_hex_init_filename => "pacrom_6j.hex"
    )
  port map (
    -- ARM interface
    i_cfgio_to_core             => i_cfgio_to_core, -- wired in parallel to all memories

    i_cfgio_fm_core             => cfgio_ram_2, -- cascade input
    o_cfgio_fm_core             => cfgio_ram_3,
    i_clk_sys                   => i_clk_sys,
    i_ena_sys                   => i_ena_sys,
    --
    i_addr                      => i_addr(11 downto 0),
    i_data                      => x"00",
    i_ena                       => i_ena,
    i_wen                       => '0',
    o_data                      => rom_data_3,
    --
    i_clk                       => i_clk
    );

  o_cfgio_fm_core <= cfgio_ram_3;

  p_rom_data : process(i_addr, rom_data_0, rom_data_1, rom_data_2, rom_data_3)
  begin
    o_data <= rom_data_0;
    case i_addr(13 downto 12) is
      when "00" => o_data <= rom_data_0;
      when "01" => o_data <= rom_data_1;
      when "10" => o_data <= rom_data_2;
      when "11" => o_data <= rom_data_3;
      when others => null;
    end case;
  end process;

end RTL;