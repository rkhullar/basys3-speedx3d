----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/05/16
-- @updated :  05/10/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- clk should be 25 MHz
-- screen high when visible pixel displayed
-- frame high whenend of frame

entity vga_sync is port
(
    clk, rst : in std_logic;
    hsync, vsync : out std_logic;
    screen, frame : out std_logic;
    x, y : out std_logic_vector(9 downto 0)
);
end vga_sync;

architecture rtl of vga_sync is
  signal hscan, vscan : std_logic_vector(9 downto 0);
  signal screen_int: std_logic;
  
  -- Display Range
  constant HBEGIN:   std_logic_vector(9 downto 0):= "00" & x"90"; -- 144 
  constant HEND:     std_logic_vector(9 downto 0):= "11" & x"0F"; -- 783
  constant VBEGIN:   std_logic_vector(9 downto 0):= "00" & x"23"; --  35 
  constant VEND:     std_logic_vector(9 downto 0):= "10" & x"03"; -- 515
  -- HEND - HBEGIN + 1 = 640
  -- VEND - VBEGIN + 1 = 480

  -- End of Scans
  constant HSCANEND: std_logic_vector(9 downto 0):= "11" & x"20"; -- 800 
  constant VSCANEND: std_logic_vector(9 downto 0):= "10" & x"0D"; -- 525
  
  -- Sync Pulse Limit
  constant HSYNCEND: std_logic_vector(9 downto 0):= "00" & x"60"; --  96 
  constant VSYNCEND: std_logic_vector(9 downto 0):= "0000000010"; --   2
begin
    x <= hscan - HBEGIN when screen_int = '1' else (others=>'0');
    y <= vscan - VBEGIN when screen_int = '1' else (others=>'0');
    screen <= screen_int;
    screen_int <= '1' when hscan > HBEGIN and hscan < HEND and vscan > VBEGIN and vscan < VEND else '0';
    frame <= '1' when hscan = HEND + "10" and vscan = VEND + "10" else '0';
    hsync <= '0' when hscan < HSYNCEND else '1';
    vsync <= '0' when vscan < VSYNCEND else '1'; 
  
  process(clk, rst)
  begin
    if rst = '0' then
        hscan <= (others => '0');
        vscan <= (others => '0');
    elsif rising_edge(clk) then
        if hscan = HSCANEND then
            hscan <= (others => '0');
            if vscan = VSCANEND then
                vscan <= (others => '0');
            else
                vscan <= vscan + '1';
            end if;
        else
            hscan <= hscan + '1';
        end if;
    end if;
  end process;
end rtl;
