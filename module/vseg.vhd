----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vseg is port
(
    x,y:  in  std_logic_vector(9 downto 0);
    h:    in  std_logic_vector(9 downto 0);
    miny: in  std_logic_vector(9 downto 0);
    maxy: in  std_logic_vector(9 downto 0);    
    draw: out std_logic
);
end vseg;

architecture rtl of vseg is
    signal a, b: std_logic;
begin
    a <= '1' when y >= miny and y <= maxy else '0';
    b <= '1' when x = h else '0';
    draw <= a and b;
end rtl;
