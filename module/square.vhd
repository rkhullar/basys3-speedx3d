----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity square is port
(
    x, y : in  std_logic_vector(9 downto 0);    -- test cordinates
    h, k : in  std_logic_vector(9 downto 0);    -- center of square
    size : in  std_logic_vector(9 downto 0);    -- half true size
    draw : out std_logic                        -- test result
);
end square;

architecture rtl of square is
    signal minx, maxx: std_logic_vector(9 downto 0);
    signal miny, maxy: std_logic_vector(9 downto 0);
    signal a, b: std_logic;
begin
    minx <= h - size;   maxx <= h + size;
    miny <= k - size;   maxy <= k + size;
    a <= '1' when x >= minx and x <= maxx else '0';
    b <= '1' when y >= miny and y <= maxy else '0';
    draw <= a and b;
end rtl;
