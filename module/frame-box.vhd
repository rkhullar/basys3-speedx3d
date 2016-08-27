----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/13/16
-- @updated :  05/14/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity frame_box is port
(
    rst      : in  std_logic;
    frame    : in  std_logic;
    clk_1f   : out std_logic;
    clk_2f   : out std_logic;
    clk_60f  : out std_logic;
    clk_300f : out std_logic
);
end frame_box;

architecture rtl of frame_box is
component clk_gen
  port
  (
    rst : in  std_logic;
    pls : in  std_logic;
    clk : out std_logic
  );
end component;
component pulse_divider
  generic (N : integer);                        -- # bits for division
  port
  (
    clki: in  std_logic;                        -- input clock
    rst:  in  std_logic;                        -- reset signal
    lim:  in  std_logic_vector(N-1 downto 0);   -- division factor
    clko: out std_logic;                        -- output clock
    Q: out std_logic_vector(N-1 downto 0)
  );
end component;
 signal c : std_logic; -- normalized frame clock
begin
  clk_1f <= frame; -- not true clock because of duty cycle
  clk_2f <= c;
  cg1:  clk_gen
    port map(rst=>rst, pls=>frame, clk=>c);
  pd1:  pulse_divider
    generic map(N => 4)
    port map(clki=>c, rst=>rst, lim=>x"f", clko=>clk_60f);
  pd2:  pulse_divider
    generic map(N => 7)
    port map(clki=>c, rst=>rst, lim=>"100"&x"b", clko=>clk_300f);
end rtl;