----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/13/16
-- @updated :  05/13/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clock_box is port
(
    rst     : in  std_logic;
    clk_sys : in  std_logic;    -- 100MHz
    clk_dis : out std_logic;    -- 1ms to 16ms
    clk_vga : out std_logic;    -- 25MHz
    clk_1Hz, clk_10Hz, clk_40Hz, clk_160Hz : out std_logic
);
end clock_box;

architecture rtl of clock_box is
component pulse_divider
  generic (N : integer);                        -- # bits for division
  port
  (
    clki: in std_logic;                         -- input clock
    rst:  in std_logic;                         -- reset signal
    lim:  in std_logic_vector(N-1 downto 0);    -- division factor
    clko: out std_logic;                        -- output clock
    Q: out std_logic_vector(N-1 downto 0)
  );
end component;
component pulse_divider_4
  port
  (
    clki : in  std_logic;
    rst  : in  std_logic;
    clko : out std_logic
  );
end component;
begin
  pd1:  pulse_divider
    generic map(N => 20)
    port map(clki=>clk_sys, rst=>rst, lim=>x"30D40", clko=>clk_dis);
  pd2: pulse_divider_4
    port map(clki=>clk_sys, rst=>rst, clko=>clk_vga);
  pd3:  pulse_divider
    generic map(N => 28)
    port map(clki=>clk_sys, rst=>rst, lim=>x"2FAF080", clko=>clk_1Hz);
  pd4:  pulse_divider
    generic map(N => 24)
    port map(clki=>clk_sys, rst=>rst, lim=>x"4C4B40", clko=>clk_10Hz);
  pd5:  pulse_divider
    generic map(N => 24)
    port map(clki=>clk_sys, rst=>rst, lim=>x"1312D0", clko=>clk_40Hz);
  pd6:  pulse_divider
    generic map(N => 20)
    port map(clki=>clk_sys, rst=>rst, lim=>x"4C4B4", clko=>clk_160Hz);
end rtl;