----------------------------------------------------------------------------------
-- author   :  Rajan Khullar
-- created  :  04/11/16
-- updated  :  04/11/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

entity DFF is
generic (N : integer);
port
(
    clk, rst: in std_logic;
    D: in  std_logic_vector(N-1 downto 0);
    Q: out std_logic_vector(N-1 downto 0)
);
end DFF;

architecture rtl of DFF is
begin
process(clk,rst) 
  begin
    if(rst='0') then
        Q <= (others => '0');
    elsif(rising_edge(clk)) then
        Q <= D;
    end if;
  end process;
end rtl;