----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/13/16
-- @updated :  05/13/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen_tb is
end clk_gen_tb;

architecture tb of clk_gen_tb is
component clk_gen
  port
  (
    rst : in  std_logic;
    pls : in  std_logic;
    clk : out std_logic
  );
end component;
  signal r, p, c : std_logic;
begin
dut:  clk_gen
    port map(rst=>r, pls=>p, clk=>c);
test: process
  begin
    p <= '0'; r <= '0'; wait for 1 ns; r <= '1';
    for i in 1 to 10 loop
        p <= '1'; wait for 1 ns;
        p <= '0'; wait for 9 ns;
    end loop;
  end process;
end tb;
