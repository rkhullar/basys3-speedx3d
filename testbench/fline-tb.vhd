----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/17/16
-- @updated :  05/17/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity fline_tb is
end fline_tb;

architecture tb of fline_tb is
component fline port
  (
    x, y  : in  std_logic_vector(9 downto 0);
    delta : in  std_logic_vector(9 downto 0);
    mode  : in  std_logic; -- left or right
    draw  : out std_logic
  );
end component;
  signal x, y: std_logic_vector(9 downto 0);
  signal draw: std_logic;
  
  constant zero  : std_logic_vector(9 downto 0) := (others => '0');
  constant forty : std_logic_vector(9 downto 0) := "00" & x"28";
begin
dut:    fline
    port map (x=>x, y=>y, draw=>draw, delta=>forty, mode=>'0');
test:   process
  begin
    for i in 0 to 479 loop
        y <= std_logic_vector(to_unsigned(i, y'length));
        for j in 0 to 639 loop
            x <= std_logic_vector(to_unsigned(j, x'length));
            wait for 1 ns;
        end loop;
    end loop;
  end process;
end tb;
