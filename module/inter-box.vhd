----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/17/16
-- @updated :  05/17/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity inter_box is port
(
    l1, l2 : in std_logic_vector(9 downto 0);
    r1, r2 : in std_logic_vector(9 downto 0);
    t1, t2 : in std_logic_vector(9 downto 0);
    b1, b2 : in std_logic_vector(9 downto 0);
    inter  : out std_logic
);
end inter_box;

architecture rtl of inter_box is
    signal l, r, a, b : std_logic;
begin
    l <= '1' when r1 < l2 else '0'; -- 1 is left of 2
    r <= '1' when l1 > r2 else '0'; -- 1 is right of 2
    a <= '1' when b1 < t2 else '0'; -- 1 is above 2
    b <= '1' when t1 > b2 else '0'; -- 1 is below 2
    
    inter <= not (l or r or a or b);
end rtl;
