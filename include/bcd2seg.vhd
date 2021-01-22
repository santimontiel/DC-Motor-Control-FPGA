library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- funcionamiento combinacional, sin señal de reloj
entity bcd2seg is
  port (
    bcd     : in  std_logic_vector(3 downto 0);   -- input data
    display : out std_logic_vector(7 downto 0));  -- formato 7seg
end bcd2seg;

architecture rtl of bcd2seg is

begin
  with BCD select
    display <=
    "11000000" when "0000",             --0
    "11111001" when "0001",             --1
    "10100100" when "0010",             --2
    "10110000" when "0011",             --3
    "10011001" when "0100",             --4
    "10010010" when "0101",             --5
    "10000010" when "0110",             --6
    "11111000" when "0111",             --7
    "10000000" when "1000",             --8
    "10011000" when "1001",             --9
    "10111111" when "1111",             -- signo menos
    "11111111" when others;             -- nada para signo mas
end rtl;
