----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vline is port
(
    x: in std_logic_vector(9 downto 0);
    h: in std_logic_vector(9 downto 0);
    draw : out std_logic
);
end vline;

architecture rtl of vline is
begin
    draw <= '1' when x = h else '0';
end rtl;
