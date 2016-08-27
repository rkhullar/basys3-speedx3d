----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/05/16
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dot is port
(
    x, y : in std_logic_vector(9 downto 0);
    h, k : in std_logic_vector(9 downto 0);
    draw : out std_logic
);
end dot;

architecture rtl of dot is
begin
    draw <= '1' when x = h and y = k else '0';
end rtl;
