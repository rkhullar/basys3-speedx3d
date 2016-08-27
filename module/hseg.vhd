----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity hseg is port
(
    x,y:  in  std_logic_vector(9 downto 0);
    k:    in  std_logic_vector(9 downto 0);
    minx: in  std_logic_vector(9 downto 0);
    maxx: in  std_logic_vector(9 downto 0);    
    draw: out std_logic
);
end hseg;

architecture rtl of hseg is
    signal a, b: std_logic;
begin
    a <= '1' when x >= minx and x <= maxx else '0';
    b <= '1' when y = k else '0';
    draw <= a and b;
end rtl;
