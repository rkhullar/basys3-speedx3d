----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/19/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity canvas is port
(
    x, y    : in  std_logic_vector(9 downto 0);
    stop    : in  std_logic;
    deltaH  : in  std_logic_vector(9 downto 0);
    playerX : in  std_logic_vector(9 downto 0);
    playerY : in  std_logic_vector(9 downto 0);
    monster1X, monster2X :in  std_logic_vector(9 downto 0);
    monster1Y, monster2Y: in  std_logic_vector(9 downto 0);
    monster1S, monster2S: in  std_logic_vector(9 downto 0);
    colorS, colorC  : in  std_logic_vector(11 downto 0);
    circleX, circleY: in  std_logic_vector(9 downto 0);
    color   : out std_logic_vector(11 downto 0)
);
end canvas;

architecture rtl of canvas is
  -- Bit Flags
  constant left:  std_logic := '0';
  constant right: std_logic := '1';

  -- Color Table
  constant white:    std_logic_vector(11 downto 0) := x"fff";
  constant black:    std_logic_vector(11 downto 0) := x"000";
  constant red:      std_logic_vector(11 downto 0) := x"f00";
  constant green:    std_logic_vector(11 downto 0) := x"0f0";
  constant blue:     std_logic_vector(11 downto 0) := x"00f";
  constant yellow:   std_logic_vector(11 downto 0) := x"ff0";
  constant orange:   std_logic_vector(11 downto 0) := x"f70";
  constant purple:   std_logic_vector(11 downto 0) := x"508";
  constant carmine:  std_logic_vector(11 downto 0) := x"d02";

  -- Limits
  constant minX  : std_logic_vector(9 downto 0) := "00" & x"00"; --   0
  constant maxX  : std_logic_vector(9 downto 0) := "10" & x"7f"; -- 639
  constant minY  : std_logic_vector(9 downto 0) := "00" & x"00"; --   0
  constant maxY  : std_logic_vector(9 downto 0) := "01" & x"df"; -- 479
  constant midX  : std_logic_vector(9 downto 0) := "01" & x"40"; -- 320
  constant midY  : std_logic_vector(9 downto 0) := "00" & x"f0"; -- 240

  -- Border Coordinates
  constant border_t: std_logic_vector(9 downto 0) := "00" & x"ef"; -- 239
  constant border_b: std_logic_vector(9 downto 0) := "01" & x"df"; -- 479
  constant border_l: std_logic_vector(9 downto 0) := "00" & x"01"; --   1
  constant border_r: std_logic_vector(9 downto 0) := "10" & x"7e"; -- 638
  
  -- Horizontal Lines Initial Ys
  constant hline1:   std_logic_vector(9 downto 0) := "00" & x"f0"; -- 240
  constant hline2:   std_logic_vector(9 downto 0) := "01" & x"2c"; -- 300
  constant hline3:   std_logic_vector(9 downto 0) := "01" & x"68"; -- 360
  constant hline4:   std_logic_vector(9 downto 0) := "01" & x"a4"; -- 420
  
  -- Focal Lines Delta Values
  constant fdelta1:  std_logic_vector(9 downto 0) := "00" & x"28"; -- 40 * 1
  constant fdelta2:  std_logic_vector(9 downto 0) := "00" & x"78"; -- 40 * 3
  constant fdelta3:  std_logic_vector(9 downto 0) := "00" & x"c8"; -- 40 * 5
  constant fdelta4:  std_logic_vector(9 downto 0) := "01" & x"18"; -- 40 * 7
  constant fdelta5:  std_logic_vector(9 downto 0) := "01" & x"68"; -- 40 * 9
  constant fdelta6:  std_logic_vector(9 downto 0) := "01" & x"b8"; -- 40 * 11
  
  -- Player Size
  constant playerS:  std_logic_vector(9 downto 0) := "00" & x"04"; --   8
  
  -- Sky Constants
  constant sky_y:    std_logic_vector(9 downto 0) := "00" & x"ef"; -- 239
  constant circleR:  std_logic_vector(9 downto 0) := "00"&x"28";   --  40
  
  -- Master Draw Flags
  signal d, t, v: std_logic_vector(0 to 9);
  signal draw_t, draw_e, draw_b, draw_p, draw_m, draw_h, draw_f, draw_g, draw_c, draw_s: std_logic;
  --     test,   end,    border, player, monster,hlines, flines, ground, circle, sky
  
  signal draw_bt , draw_bb , draw_bl , draw_br  : std_logic;
  signal draw_h1 , draw_h2 , draw_h3 , draw_h4  : std_logic;
  signal draw_fl1, draw_fl2, draw_fl3, draw_fl4, draw_fl5, draw_fl6 : std_logic;
  signal draw_fr1, draw_fr2, draw_fr3, draw_fr4, draw_fr5, draw_fr6 : std_logic;
  signal draw_fl , draw_fr : std_logic;
  
  signal draw_m1, draw_m2 : std_logic;
  signal draw_t1, draw_t2 : std_logic;

component hline port
  (
    y: in std_logic_vector(9 downto 0);
    k: in std_logic_vector(9 downto 0);
    draw : out std_logic
  );
end component;

component vseg port
  (
    x,y:  in  std_logic_vector(9 downto 0);
    h:    in  std_logic_vector(9 downto 0);
    miny: in  std_logic_vector(9 downto 0);
    maxy: in  std_logic_vector(9 downto 0);    
    draw: out std_logic
  );
end component;

component fline port
  (
    x, y  : in  std_logic_vector(9 downto 0);
    delta : in  std_logic_vector(9 downto 0);
    mode  : in  std_logic; -- left or right
    draw  : out std_logic
  );
end component;

component square port
  (
    x, y : in  std_logic_vector(9 downto 0);    -- test cordinates
    h, k : in  std_logic_vector(9 downto 0);    -- center of square
    size : in  std_logic_vector(9 downto 0);    -- half true size
    draw : out std_logic                        -- test result
  );
end component;

component circle port
  (
    x, y: in  std_logic_vector(9 downto 0);
    h, k: in  std_logic_vector(9 downto 0);
    r:    in  std_logic_vector(9 downto 0);    
    draw: out std_logic
  );
end component;

begin
-- Borders
bt:     hline
    port map(y=>y, k=>border_t, draw=>draw_bt);
bb:     hline
    port map(y=>y, k=>border_b, draw=>draw_bb);
bl:     vseg
    port map(x=>x, y=>y, h=>border_l, miny=>border_t, maxy=>border_b, draw=>draw_bl);
br:     vseg
    port map(x=>x, y=>y, h=>border_r, miny=>border_t, maxy=>border_b, draw=>draw_br);

-- Horizontal Lines
h1:     hline
    port map(y=>y, k=>hline1+deltaH, draw=>draw_h1);
h2:     hline
    port map(y=>y, k=>hline2+deltaH, draw=>draw_h2);
h3:     hline
    port map(y=>y, k=>hline3+deltaH, draw=>draw_h3);
h4:     hline
    port map(y=>y, k=>hline4+deltaH, draw=>draw_h4);

-- Focal Diagonal Left Lines
fl1:    fline
    port map(x=>x, y=>y, draw=>draw_fl1, delta=>fdelta1, mode=>left);
fl2:    fline
    port map(x=>x, y=>y, draw=>draw_fl2, delta=>fdelta2, mode=>left);
fl3:    fline
    port map(x=>x, y=>y, draw=>draw_fl3, delta=>fdelta3, mode=>left);
fl4:    fline
    port map(x=>x, y=>y, draw=>draw_fl4, delta=>fdelta4, mode=>left);
fl5:    fline
    port map(x=>x, y=>y, draw=>draw_fl5, delta=>fdelta5, mode=>left);
fl6:    fline
    port map(x=>x, y=>y, draw=>draw_fl6, delta=>fdelta6, mode=>left);

-- Focal Diagonal Right Lines
fr1:    fline
    port map(x=>x, y=>y, draw=>draw_fr1, delta=>fdelta1, mode=>right);
fr2:    fline
    port map(x=>x, y=>y, draw=>draw_fr2, delta=>fdelta2, mode=>right);
fr3:    fline
    port map(x=>x, y=>y, draw=>draw_fr3, delta=>fdelta3, mode=>right);
fr4:    fline
    port map(x=>x, y=>y, draw=>draw_fr4, delta=>fdelta4, mode=>right);
fr5:    fline
    port map(x=>x, y=>y, draw=>draw_fr5, delta=>fdelta5, mode=>right);
fr6:    fline
    port map(x=>x, y=>y, draw=>draw_fr6, delta=>fdelta6, mode=>right);

-- Sprites
player:  square
    port map(x=>x, y=>y, h=>playerX, k=>playerY, size=>playerS, draw=>draw_p);

monster1: square
    port map(x=>x, y=>y, h=>monster1X, k=>monster1Y, size=>monster1S, draw=>draw_m1);

monster2: square
    port map(x=>x, y=>y, h=>monster2X, k=>monster2Y, size=>monster2S, draw=>draw_m2);

circle1:  circle
    port map(x=>x, y=>y, h=>circleX, k=>circleY, r=>circleR, draw=>draw_c);

-- Master Draw Signals
draw_e <= stop;
draw_b <= draw_bt;
    --draw_b <= draw_bt or draw_bb or draw_bl or draw_br;
draw_m <= draw_m1 or draw_m2;
draw_h <= draw_h1 or draw_h2 or draw_h3 or draw_h4;
draw_f <= (draw_fl or draw_fr) and not draw_s;
draw_g <= '1' when y > sky_y else '0';
draw_s <= '1' when y < sky_y else '0';

draw_fl <= draw_fl1 or draw_fl2 or draw_fl3 or draw_fl4;
draw_fr <= draw_fr1 or draw_fr2 or draw_fr3 or draw_fr4;

-- Test Draw Signal
draw_t <= '0';
--draw_t  <= draw_t1 or draw_t2;
--draw_t1 <= '1' when x >= y and x - y < 1 else '0';
--draw_t2 <= '1' when x <= y and y - x < 1 else '0';

d <= draw_t & draw_e & draw_b & draw_p & draw_m & draw_h & draw_f & draw_g & draw_c & draw_s;

    t(0) <= not d(0);
g1: for i in 1 to 9 generate
        t(i) <= t(i-1) and not d(i);
    end generate g1;
    
    v(0) <= d(0);
g2: for i in 1 to 9 generate
        v(i) <= t(i-1) and d(i);
    end generate g2;

with v select color <=
    white   when "1000000000", -- test
    purple  when "0100000000", -- end
    white   when "0010000000", -- borders
    white   when "0001000000", -- player
    red     when "0000100000", -- monster
    blue    when "0000010000", -- hlines
    orange  when "0000001000", -- flines
    black   when "0000000100", -- ground
    colorC  when "0000000010", -- cicle
    colorS  when "0000000001", -- sky
    black   when others;

end rtl;
