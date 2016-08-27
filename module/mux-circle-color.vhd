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

entity mux_circle_color is port
(
    sky_color    : in  std_logic_vector(11 downto 0);
    circle_color : out std_logic_vector(11 downto 0)
);
end mux_circle_color;

architecture rtl of mux_circle_color is
begin
    with sky_color select circle_color <=
        x"ff0" when x"00D",
        x"ff0" when x"00C",
        x"ff0" when x"00B",
        x"ff0" when x"00A",
        x"ff0" when x"009",
        x"ff0" when x"008",
        x"ff0" when x"007",
        x"ddd" when x"006",
        x"ddd" when x"005",
        x"ddd" when x"004",
        x"eee" when x"003",
        x"fff" when x"002",
        x"fff" when x"001",
        x"fff" when x"000",
        x"fff" when x"110",
        x"fff" when x"220",
        x"ff0" when x"330",
        x"ff0" when x"430",
        x"ff0" when x"530",
        x"ff0" when x"630",
        x"ff0" when x"730",
        x"ff0" when x"830",
        x"ff0" when x"930",
        x"ff0" when x"A30",
        x"ff0" when x"B30",
        x"ff0" when x"C30",
        x"ff0" when x"D30",
        x"ff0" when x"D40",
        x"ff0" when x"D50",
        x"ff0" when x"D60",
        x"ff0" when x"E60",
        x"ff0" when x"F70",
        x"000" when others;
end rtl;