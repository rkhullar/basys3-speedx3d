----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/05/16
-- @updated :  05/18/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity project is port
(
    clk : in  std_logic;
    btnU, btnD, btnL, btnR, btnC: in std_logic;
    led : out std_logic_vector (15 downto 0);
    seg : out std_logic_vector (6 downto 0);
    dp  : out std_logic;
    an  : out std_logic_vector (3 downto 0);
    sw  : in  std_logic_vector (15 downto 0);
    red, grn, blu : out std_logic_vector(3 downto 0);
    hsync, vsync  : out  std_logic
);
end project;

architecture rtl of project is
  -- clk_dis = 16ms; clk_vga = 25MHz
  signal rst, clk_dis, clk_vga : std_logic;
  signal clk_1Hz, clk_10Hz, clk_40Hz, clk_160Hz : std_logic;
  signal clk_1f, clk_60f, clk_300f : std_logic;
  signal score : std_logic_vector(15 downto 0);
  signal screen, frame : std_logic;
  signal x, y : std_logic_vector(9 downto 0);
  signal color : std_logic_vector(11 downto 0);
  signal left, right : std_logic;
  signal pause : std_logic;

component   clock_box
  port
  (
    rst     : in  std_logic;
    clk_sys : in  std_logic;    -- 100MHz
    clk_dis : out std_logic;    -- 1ms to 16ms
    clk_vga : out std_logic;    -- 25MHz
    clk_1Hz, clk_10Hz, clk_40Hz, clk_160Hz : out std_logic
  );
end component;
component   display
  port
  (
    clk  : in  std_logic;
    rst  : in  std_logic;
    data : in  std_logic_vector(15 downto 0);
    an   : out std_logic_vector( 3 downto 0);
    seg  : out std_logic_vector( 6 downto 0);
    dp   : out std_logic;
    cur  : out std_logic_vector( 3 downto 0)
  );
end component;
component   counter
  generic (N : integer);
  port
  (
    clk, rst, mode: in std_logic;
    Q : out std_logic_vector(N-1 downto 0)
  );
end component;
component   vga_sync
  port
  (
    clk, rst : in std_logic;
    hsync, vsync : out std_logic;
    screen, frame : out std_logic;
    x, y : out std_logic_vector(9 downto 0)
  );
end component;
component   frame_box
  port
  (
    rst      : in  std_logic;
    frame    : in  std_logic;
    clk_1f   : out std_logic;
    clk_2f   : out std_logic;
    clk_60f  : out std_logic;
    clk_300f : out std_logic
  );
end component;
component   core
  port
  (
    rst     : in  std_logic;
    pause   : in  std_logic;
    left    : in  std_logic;
    right   : in  std_logic;
    screen  : in  std_logic;
    x, y    : in  std_logic_vector(9 downto 0);
    color   : out std_logic_vector(11 downto 0);
    score   : out std_logic_vector(15 downto 0);
    clk     : in  std_logic;
    clk_1Hz : in  std_logic;
    clk_1f  : in  std_logic;
    clk_60f : in  std_logic
  );
end component;
begin

  led   <= sw;
  rst   <= not sw(15);
  left  <= btnL;
  right <= btnR;
  pause <= sw(0);
  
cbox:   clock_box
    port map(rst=>rst, clk_sys=>clk, clk_dis=>clk_dis, clk_vga=>clk_vga,
             clk_1Hz=>clk_1Hz, clk_10Hz=>clk_10Hz,
             clk_40Hz=>clk_40Hz, clk_160Hz=>clk_160Hz);

fbox:   frame_box
    port map(rst=>rst, frame=>frame, clk_1f=>clk_1f, clk_60f=>clk_60f, clk_300f=>clk_300f);

dis:    display
    port map(clk=>clk_dis, rst=>rst, data=>score, an=>an, seg=>seg, dp=>dp);
    
sync:   vga_sync
    port map(clk=>clk_vga, rst=>rst, hsync=>hsync, vsync=>vsync, screen=>screen, frame=>frame, x=>x, y=>y);
    red <= color(11 downto 8);
    grn <= color( 7 downto 4);
    blu <= color( 3 downto 0);
  
cpu:    core
    port map(rst=>rst, pause=>pause,
             left=>left, right=>right,
             screen=>screen, color=>color,
             score=>score, x=>x, y=>y,
             clk=>clk, clk_1Hz=>clk_1Hz,
             clk_1f=>clk_1f, clk_60f=>clk_60f);

end rtl;