----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  -
-- @updated :  05/15/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dot_tb is
end dot_tb;

architecture tb of dot_tb is
component dot port
  (
    x, y : in std_logic_vector(9 downto 0);
    h, k : in std_logic_vector(9 downto 0);
    draw : out std_logic
  );
end component;
  signal x, y, h, k : std_logic_vector(9 downto 0);
  signal draw : std_logic;
begin
dut:    dot
    port map (x=>x, y=>y, h=>h, k=>k, draw=>draw);
test:   process
  begin
    h <= "11" & x"ff"; k <= "11" & x"ff";
    x <= "11" & x"f0"; y <= "11" & x"ff";
    for i in 1 to 32 loop
        wait for 1 ns;
        x <= x + '1';
    end loop;
  end process;
end tb;
