----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @author  :  Jeffrey Silva
-- @created :  05/19/16
-- @updated :  05/19/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity circle is port
(
    x, y: in  std_logic_vector(9 downto 0);
    h, k: in  std_logic_vector(9 downto 0);
    r:    in  std_logic_vector(9 downto 0);    
    draw: out std_logic
);
end circle;

architecture rtl of circle is
    signal dx, dy: std_logic_vector(9 downto 0);
    signal lhs, rhs: std_logic_vector(19 downto 0);
    
begin
    dx <= (others => '0') when x = h else
          x - h when x > h else
          h - x when x < h else
          (others => '0');
    dy <= (others => '0') when y = k else
                y - k when y > k else
                k - y when y < k else
                (others => '0');
    lhs <= dx*dx + dy*dy;
    rhs <= r*r;
    draw <= '1' when lhs <= rhs else '0';
end rtl;
