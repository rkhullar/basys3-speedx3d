----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/15/16
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity square_tb is
end square_tb;

architecture tb of square_tb is
component square port
  (
    x, y : in  std_logic_vector(9 downto 0);    -- test cordinates
    h, k : in  std_logic_vector(9 downto 0);    -- center of square
    size : in  std_logic_vector(9 downto 0);    -- half true size
    draw : out std_logic                        -- test result
  );
end component;
  signal x, y, h, k, s: std_logic_vector(9 downto 0);
  signal draw: std_logic;
begin
dut:    square
    port map (x=>x, y=>y, h=>h, k=>k, size=>s, draw=>draw);
test:   process
  begin
    h <= "00" & x"3c"; -- 60
    k <= "00" & x"28"; -- 40
    s <= "00" & x"02"; --  2
    x <= "00" & x"32"; -- 50
    y <= "00" & x"1e"; -- 30
    for i in 1 to 10 loop
        wait for 1 ns;
        x <= x + '1';
        y <= y + '1';
    end loop;
  end process;
end tb;
