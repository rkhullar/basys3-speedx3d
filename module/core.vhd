----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/20/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity core is port
(
    rst     : in  std_logic;
    left    : in  std_logic;
    right   : in  std_logic;
    pause   : in  std_logic;
    screen  : in  std_logic;
    x, y    : in  std_logic_vector(9 downto 0);
    color   : out std_logic_vector(11 downto 0);
    score   : out std_logic_vector(15 downto 0);
    clk     : in  std_logic;
    clk_1Hz : in  std_logic;
    clk_1f  : in  std_logic;
    clk_60f : in  std_logic
);
end core;

architecture rtl of core is
  -- Limits
  constant minX  : std_logic_vector(9 downto 0) := "00" & x"00"; --   0
  constant maxX  : std_logic_vector(9 downto 0) := "10" & x"7f"; -- 639
  constant minY  : std_logic_vector(9 downto 0) := "00" & x"00"; --   0
  constant maxY  : std_logic_vector(9 downto 0) := "01" & x"df"; -- 479
  constant midX  : std_logic_vector(9 downto 0) := "01" & x"40"; -- 320
  constant midY  : std_logic_vector(9 downto 0) := "00" & x"f0"; -- 240
  
  -- Movement
  constant distH   : std_logic_vector(9 downto 0) := "00" & x"3c"; --  60
  signal   deltaH  : std_logic_vector(9 downto 0);
  constant limitMS : std_logic_vector(9 downto 0) := "00" & x"05"; --   5
  signal   countMS : std_logic_vector(9 downto 0);
  constant dPX     : std_logic_vector(9 downto 0) := "00" & x"04"; --   4
    
  -- Player Initial Values
  constant playerX0   : std_logic_vector(9 downto 0) := "01" & x"40"; -- 320
  constant playerY0   : std_logic_vector(9 downto 0) := "01" & x"a4"; -- 420
  constant playerS    : std_logic_vector(9 downto 0) := "00" & x"04"; --   8
  
  -- Monsters Initial Values
  constant monster1X0 : std_logic_vector(9 downto 0) := "00" & x"a0"; -- 160
  constant monster2X0 : std_logic_vector(9 downto 0) := "01" & x"e0"; -- 480
  constant monster1Y0 : std_logic_vector(9 downto 0) := "00" & x"ea"; -- 234
  constant monster2Y0 : std_logic_vector(9 downto 0) := "00" & x"ea"; -- 234
  constant monster1S0 : std_logic_vector(9 downto 0) := "00" & x"04"; --   8
  constant monster2S0 : std_logic_vector(9 downto 0) := "00" & x"04"; --   8
  
  -- Sky Signals
  signal sky_color       : std_logic_vector(11 downto 0);
  signal sky_addr        : std_logic_vector( 5 downto 0);
  signal circle_pos      : std_logic_vector(19 downto 0);
  signal circle_pos_addr : std_logic_vector( 3 downto 0);
  signal circle_color    : std_logic_vector(11 downto 0);
  
  -- Sprite Properties
  signal playerX , playerY   : std_logic_vector(9 downto 0);
  signal player_l, player_r  : std_logic_vector(9 downto 0);
  signal player_t, player_b  : std_logic_vector(9 downto 0);
  
  signal monster1X , monster2X : std_logic_vector(9 downto 0);
  signal monster1Y , monster2Y : std_logic_vector(9 downto 0);
  signal monster1S , monster2S : std_logic_vector(9 downto 0);
  signal monster_1l, monster_1r: std_logic_vector(9 downto 0);
  signal monster_1t, monster_1b: std_logic_vector(9 downto 0);
  signal monster_2l, monster_2r: std_logic_vector(9 downto 0);
  signal monster_2t, monster_2b: std_logic_vector(9 downto 0);
  
  signal circleX, circleY: std_logic_vector(9 downto 0);

  -- Score
  signal score_int : std_logic_vector(15 downto 0);
  
  -- Timer Signals
  constant delay_lim : std_logic_vector(9 downto 0) := "00" & x"05"; -- 60 frames * 5
  signal delay_int   : std_logic_vector(9 downto 0);
  
  -- Canvas Color Output
  signal color_out : std_logic_vector(11 downto 0);
  
  -- Single Hits
  signal hit1, hit2 : std_logic;
  
  -- Flags
  signal off, stop, hit, enable : std_logic;
  
component canvas
  port
  (
    x, y    : in  std_logic_vector( 9 downto 0);
    stop    : in  std_logic;
    deltaH  : in  std_logic_vector( 9 downto 0);
    playerX : in  std_logic_vector( 9 downto 0);
    playerY : in  std_logic_vector( 9 downto 0);
    monster1X, monster2X :in  std_logic_vector( 9 downto 0);
    monster1Y, monster2Y: in  std_logic_vector( 9 downto 0);
    monster1S, monster2S: in  std_logic_vector( 9 downto 0);
    circleX, circleY: in  std_logic_vector(9 downto 0); 
    colorS, colorC : in  std_logic_vector(11 downto 0);
    color   : out std_logic_vector(11 downto 0)
  );
end component;

component inter_box port
  (
    l1, l2 : in std_logic_vector(9 downto 0);
    r1, r2 : in std_logic_vector(9 downto 0);
    t1, t2 : in std_logic_vector(9 downto 0);
    b1, b2 : in std_logic_vector(9 downto 0);
    inter  : out std_logic
  );
end component;

component rom_sky port
  (
    clk  : in  std_logic;
    addr : in  std_logic_vector( 5 downto 0);
    data : out std_logic_vector(11 downto 0)
  );
end component;

component rom_circle_pos port
  (
    clk  : in  std_logic;
    addr : in  std_logic_vector( 3 downto 0);
    data : out std_logic_vector(19 downto 0)
  );
end component;

component mux_circle_color port
  (
    sky_color    : in  std_logic_vector(11 downto 0);
    circle_color : out std_logic_vector(11 downto 0)
  );
end component;

begin

enable <= not off and not pause and not stop;
score <= score_int;

-- Player Properties
player_l <= playerX - playerS;
player_r <= playerX + playerS;
player_t <= playerY - playerS;
player_b <= playerY + playerS;

-- Monster Properties
monster_1l <= monster1X - monster1S;
monster_1r <= monster1X + monster1S;
monster_1t <= monster1Y - monster1S;
monster_1b <= monster1Y + monster1S;

monster_2l <= monster2X - monster2S;
monster_2r <= monster2X + monster2S;
monster_2t <= monster2Y - monster2S;
monster_2b <= monster2Y + monster2S;

gpu:    canvas
    port map(x=>x, y=>y, deltaH=>deltaH,
            stop=>stop,
            playerX=>playerX, playerY=>playerY,
            monster1X=>monster1X, monster1Y=>monster1Y, monster1S=>monster1S,
            monster2X=>monster2X, monster2Y=>monster2Y, monster2S=>monster2S,
            colorS=>sky_color, colorC=>circle_color,
            circleX=>circleX, circleY=>circleY,
            color=>color_out);

hit <= hit1 or hit2;

ib1:    inter_box
    port map(l1=>player_l  , r1=>player_r  , t1=>player_t  , b1=>player_b ,
             l2=>monster_1l, r2=>monster_1r, t2=>monster_1t, b2=>monster_1b,
             inter=>hit1);

ib2:    inter_box
    port map(l1=>player_l  , r1=>player_r  , t1=>player_t  , b1=>player_b ,
             l2=>monster_2l, r2=>monster_2r, t2=>monster_2t, b2=>monster_2b,
             inter=>hit2);

sky:    rom_sky
    port map(clk=>clk, addr=>sky_addr, data=>sky_color);

cp1:    rom_circle_pos
    port map(clk=>clk, addr=>circle_pos_addr, data=>circle_pos);
    circleX <= circle_pos(19 downto 10);
    circleY <= circle_pos( 9 downto 0);

mcc:    mux_circle_color
    port map(sky_color=>sky_color, circle_color=>circle_color);

-- Choose Color for VGA
process(screen)
begin
  if screen = '1' then
    color <= color_out;
  else
    color <= x"000";
  end if;
end process;

-- Update Horizontal Lines
process(rst, clk_1f)
begin
  if rst = '0' then
    deltaH <= (others => '0'); 
  elsif rising_edge(clk_1f) then
    if deltaH = distH then
        deltaH <= (others => '0');
    else
        deltaH <= deltaH + '1';
    end if;
  end if;
end process;

-- Update Player
process(rst, clk_1f)
begin
  if rst = '0' then
    playerX <= playerX0;
    playerY <= playerY0;
  elsif rising_edge(clk_1f) and enable = '1' then
    if left = '1' and right = '0' then
        if player_l <= minX + dPX then
            playerX <= maxX;
        else
            playerX <= playerX - dPX;
        end if;
    end if;
    if right = '1' and left = '0' then
        if player_r >= maxX - dpX then
            playerX <= minX;
        else
            playerX <= playerX + dPX;
        end if;
    end if;
  end if;
end process;

-- Update Monsters
process(rst, clk_1f)
begin
  if rst = '0' then
    monster1X <= monster1X0; monster2X <= monster2X0;
    monster1Y <= monster1Y0; monster2Y <= monster2Y0;
    monster1S <= monster1S0; monster2S <= monster2S0;
    
  elsif rising_edge(clk_1f) and enable = '1' then
    -- Respawn Monsters
    if monster_1b >= maxY or monster_2b >= maxY then
        monster1X <= playerX;    monster2X <= midX;
        monster1Y <= monster1Y0; monster2Y <= monster2Y0;
        monster1S <= monster1S0; monster2S <= monster2S0;
        
        countMS   <= (others => '0');
        
    else
        -- Move Monsters Down
        monster1Y <= monster1Y + '1';
        monster2Y <= monster2Y + '1';

        -- Move Monster 1 Towards Player        
        if monster1Y < playerY then
            if monster1X > playerX and monster_1l > minX then
                monster1X <= monster1X - '1';
            end if;
            if monster1X < playerX and monster_1r < maxX then
                monster1X <= monster1X + '1';
            end if;
        end if;

        -- Move Monster 2 Towards Player        
        if monster2Y < playerY then
            if monster2X > playerX and monster_2l > minX then
                monster2X <= monster2X - '1';
            end if;
            if monster2X < playerX and monster_2r < maxX then
                monster2X <= monster2X + '1';
            end if;
        end if;
        
        -- Make Monsters Bigger
        countMS <= countMS + '1';
        if countMS >= limitMS then
            countMS  <= (others => '0');
            monster1S <= monster1S + '1';
            monster2S <= monster2S + '1';
        end if;
    end if;
    
  end if;
end process;

-- Hit Detection
process(rst, clk_1f)
begin
  if rst = '0' then
    stop <= '0';
  elsif rising_edge(clk_1f) and stop = '0' then
    if hit = '1' then
        stop <= '1';
    end if;
  end if;
end process;

-- Update Sky
process(rst, clk_60f)
begin
  if rst = '0' then
    sky_addr <= (others => '0');
  
  elsif rising_edge(clk_60f) then
    if sky_addr = x"3e" then
        sky_addr <= (others => '0');
    else
        sky_addr <= sky_addr + '1';
    end if;
  end if;
end process;

-- Update Circle Position
process(rst, clk_60f)
begin
  if rst = '0' then
    circle_pos_addr <= (others => '0');
  
  elsif rising_edge(clk_60f) then
    if circle_pos_addr = x"8" then
        circle_pos_addr <= (others => '0');
    else
        circle_pos_addr <= circle_pos_addr + '1';
    end if;
  end if;
end process;

-- Timer Start
process(rst, clk_60f)
begin
  if rst = '0' then
    delay_int <= (others => '0');
    off <= '1';
  elsif rising_edge(clk_60f) then
    if off = '1' then
        if delay_int = delay_lim then
            off <= '0';
        else
            delay_int <= delay_int + '1';
        end if;
    end if;
  end if;
end process;

-- Score Update
process(rst, clk_1Hz)
begin
  if rst = '0' then
    score_int <= (others => '0');
  elsif rising_edge(clk_1Hz) and enable = '1' then
    score_int <= score_int + '1';
  end if;
end process;

end rtl;
