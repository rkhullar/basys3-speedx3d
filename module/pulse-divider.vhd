----------------------------------------------------------------------------------
-- author   :  Rajan Khullar
-- created  :  04/12/16
-- updated  :  04/16/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pulse_divider is
generic (N : integer);                           -- # bits for division
port
(
    clki: in std_logic;                          -- input clock
    rst:  in std_logic;                          -- reset signal
    lim:  in std_logic_vector(N-1 downto 0);     -- division factor
    clko: out std_logic;                         -- output clock
    Q: out std_logic_vector(N-1 downto 0)
);
end pulse_divider;

architecture rtl of pulse_divider is
  signal count: std_logic_vector(N-1 downto 0);
  signal clks: std_logic;
begin

update: process(clki, rst)
  begin
    if rst = '0' then
        count <= (others => '0');
        clks <= '0';
    elsif rising_edge(clki) then
        if count = lim - '1' then
            count <= (others => '0');
            clks <= not clks;
        else
            count <= count + '1';
        end if;
    end if;
  end process;
  clko <= clks;
  Q <= count;
end rtl;
