----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @author  :  Jeffrey Silva
-- @created :  05/19/16
-- @updated :  05/20/16
----------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rom_circle_pos is port
(
    clk  : in  std_logic;
    addr : in  std_logic_vector( 3 downto 0); -- address length is ld number of coordinates 
    data : out std_logic_vector(19 downto 0) -- X & Y, each coordinate is 10 bits
);
end rom_circle_pos;

architecture rtl of rom_circle_pos is
  type rom_type is array(0 to 8) of std_logic_vector(19 downto 0);
  signal ROM : rom_type :=
  (                        -- R =H/12= 40 | W=640, H=480
  "00"&x"00" & "00"&x"f0", -- (  0, 240)
  "00"&x"50" & "00"&x"a0", -- ( 80, 160)
  "00"&x"a0" & "00"&x"78", -- (160, 120)
  "00"&x"f0" & "00"&x"5a", -- (240,  90)
  "01"&x"40" & "00"&x"50", -- (320,  80)
  "01"&x"90" & "00"&x"5a", -- (400,  90)
  "01"&x"e0" & "00"&x"78", -- (480, 120)
  "10"&x"30" & "00"&x"a0", -- (560, 160)
  "10"&x"80" & "00"&x"f0"  -- (640, 240)
  );

begin
  process(clk)
  begin
    if rising_edge(clk) then
        data <= ROM(conv_integer(addr)); --number of array is addr 0 counts
    end if;
  end process;
end rtl;