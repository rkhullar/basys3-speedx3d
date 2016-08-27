----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/13/16
-- @updated :  05/13/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is port
(
    rst : in  std_logic;
    pls : in  std_logic;
    clk : out std_logic
);
end clk_gen;

architecture rtl of clk_gen is
  signal s : std_logic;
begin
  process(rst, pls)
  begin
    if rst = '0' then
        s <= '0';
    elsif rising_edge(pls) then
        s <= not s;
    end if;
  end process;
  clk <= s;
end rtl;