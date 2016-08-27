----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  04/29/16
-- @updated :  04/29/16
----------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity display is port
(
    clk  : in  std_logic;
    rst  : in  std_logic;
    data : in  std_logic_vector(15 downto 0);
    an   : out std_logic_vector( 3 downto 0);
    seg  : out std_logic_vector( 6 downto 0);
    dp   : out std_logic;
    cur  : out std_logic_vector(3 downto 0)
);
end display;

architecture rtl of display is
  signal shifter : std_logic_vector(3 downto 0);
  signal digit   : std_logic_vector(3 downto 0);
begin
  process(clk, rst)
  begin
    if rst = '0' then
        shifter <= "0111";
    elsif rising_edge(clk) then
        shifter <= shifter(0) & shifter(3 downto 1);
    end if;
  end process;
  
  an <= shifter;
  with shifter select
    digit <= data( 3 downto  0) when "1110",
             data( 7 downto  4) when "1101",
             data(11 downto  8) when "1011",
             data(15 downto 12) when "0111",
                           x"0" when others;
  cur <= digit;
  
  with digit select
         -- GFEDCBA
    seg <= "1000000" when x"0",
           "1111001" when x"1",
           "0100100" when x"2",
           "0110000" when x"3",
           "0011001" when x"4",
           "0010010" when x"5",
           "0000010" when x"6",
           "1111000" when x"7",
           "0000000" when x"8",
           "0010000" when x"9",
           "0001000" when x"a",
           "0000000" when x"b",
           "1000110" when x"c",
           "1000000" when x"d",
           "0000110" when x"e",
           "0001110" when x"f",
           "1111111" when others;
  with digit select
    dp <= '1' when x"0",
          '1' when x"1",
          '1' when x"2",
          '1' when x"3",
          '1' when x"4",
          '1' when x"5",
          '1' when x"6",
          '1' when x"7",
          '1' when x"8",
          '1' when x"9",
          '0' when x"a",
          '0' when x"b",
          '0' when x"c",
          '0' when x"d",
          '0' when x"e",
          '0' when x"f",
          '0' when others;    
end rtl;