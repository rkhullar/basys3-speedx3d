----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @author  :  Jeffrey Silva
-- @created :  04/29/16
-- @updated :  05/14/16
----------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rom_sky is port
(
    clk  : in  std_logic;
    addr : in  std_logic_vector( 5 downto 0); --address length is ld number of colors
    data : out std_logic_vector(11 downto 0)
);
end rom_sky;

architecture rtl of rom_sky is
  type rom_type is array(0 to 62) of std_logic_vector(11 downto 0);
  signal ROM : rom_type :=
  (
  x"00D", x"00C", x"00B", x"00A", x"009", x"008", x"007", x"006",
  x"005", x"004", x"003", x"002", x"001", x"000", x"110", x"220",
  x"330", x"430", x"530", x"630", x"730", x"830", x"930", x"A30",
  x"B30", x"C30", x"D30", x"D40", x"D50", x"D60", x"E60", x"F70",
  x"E60", x"D60", x"D50", x"D40", x"D30", x"C30", x"B30", x"A30",
  x"930", x"830", x"730", x"630", x"530", x"430", x"330", x"220",
  x"110", x"000", x"001", x"002", x"003", x"004", x"005", x"006",
  x"007", x"008", x"009", x"00A", x"00B", x"00C", x"00D"
  );

begin
  process(clk)
  begin
    if rising_edge(clk) then
        data <= ROM(conv_integer(addr)); --number of array is addr 0 counts
    end if;
  end process;
end rtl;