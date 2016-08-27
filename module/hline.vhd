----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity hline is port
(
    y: in std_logic_vector(9 downto 0);
    k: in std_logic_vector(9 downto 0);
    draw : out std_logic
);
end hline;

architecture rtl of hline is
begin
    draw <= '1' when y = k else '0';
end rtl;
