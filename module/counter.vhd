----------------------------------------------------------------------------------
-- author   :  Rajan Khullar
-- created  :  04/12/16
-- updated  :  04/12/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
generic (N : integer);
port
(
    clk, rst, mode: in std_logic;
    Q : out std_logic_vector(N-1 downto 0)
);
end counter;

architecture rtl of counter is
signal count: std_logic_vector(N-1 downto 0);
begin
process(clk,rst) 
  begin
    if(rst='0') then
        count <= (others => '0');
    elsif(rising_edge(clk)) then
        if(mode='1') then
            count <= count + 1;
        else
            count <= count - 1;
        end if;
    end if;
  end process;
  Q <= count;
end rtl;