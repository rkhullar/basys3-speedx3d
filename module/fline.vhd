----------------------------------------------------------------------------------
-- @author  :  Rajan Khullar
-- @created :  05/16/16
-- @updated :  05/17/16
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fline is port
(
    x, y  : in  std_logic_vector(9 downto 0);
    delta : in  std_logic_vector(9 downto 0);
    mode  : in  std_logic; -- left or right
    draw  : out std_logic
);
end fline;

architecture rtl of fline is
    constant screen_w: std_logic_vector(9 downto 0) := "10" & x"80"; -- 640
    constant screen_h: std_logic_vector(9 downto 0) := "01" & x"e0"; -- 480
    constant middle_w: std_logic_vector(9 downto 0) := "01" & x"40"; -- 320
    constant focal_h : std_logic_vector(9 downto 0) := "01" & x"e0"; -- 480
    --constant focal_h : std_logic_vector(9 downto 0) := "01" & x"a4"; -- 420
    --constant focal_h : std_logic_vector(9 downto 0) := "10" & x"d0"; -- 720    
    constant thresh: std_logic_vector(19 downto 0) := x"00010"; -- 16
    
    signal lx, rx, xpl, xpr : std_logic_vector( 9 downto 0);
    signal lhs, rhs, rhsl, rhsr, d1, d2 : std_logic_vector(19 downto 0);
    signal t0, t1, t2 : std_logic;
begin
    lx   <= middle_w - delta;
    rx   <= middle_w + delta;
    xpl  <= middle_w - x;
    xpr  <= x - middle_w;
    lhs  <= y * delta;
    rhsl <= focal_h * xpl;
    rhsr <= focal_h * xpr;
    with mode select rhs <=
        rhsl            when '0',
        rhsr            when '1',
        (others => '0') when others;
    d1 <= lhs - rhs;
    d2 <= rhs - lhs;
    t0 <= '1' when lhs = rhs else '0';
    t1 <= '1' when lhs > rhs and thresh > d1 else '0';
    t2 <= '1' when lhs < rhs and thresh > d2 else '0';    
    draw <= t0 or t1 or t2;
end rtl;
