----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/10/16
-- @updated :  05/10/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pulse_divider_4 is port
(
    clki : in  std_logic;
    rst  : in  std_logic;
    clko : out std_logic
);
end pulse_divider_4;

architecture rtl of pulse_divider_4 is
  signal ps1, ps2 : std_logic;
begin
  process(clki, rst)
  begin
    if rst = '0' then
        ps1 <= '0';
        ps2 <= '0';
    elsif rising_edge(clki) then
        ps1 <= not ps1;
        if ps1 = '0' then
            ps2 <= not ps2;
        end if;
    end if;
  end process;
  clko <= ps2;
end rtl;
