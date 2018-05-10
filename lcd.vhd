------------------# To control the LCD module display #-------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lcd is
port ( clk ,lt,rt,up,down : in std_logic;                          --clock i/p
       lcd_rw : out std_logic;                         --read & write control
       lcd_e : out std_logic;                         --enable control
       lcd_rs : out std_logic;                         --data or command control
       data  : out std_logic_vector(7 downto 0));     --data line
end lcd;

architecture Behavioral of lcd is

constant N: integer :=10;

type arr is array (1 to N) of std_logic_vector(7 downto 0);

constant dataL : arr :=    (X"38",X"0c",X"06",X"01",X"C0",X"4C",x"45",x"46",x"54",x"20"); --command and data to display LEFT                                         
constant dataR : arr :=    (X"38",X"0c",X"06",X"01",X"C0",X"52",x"49",x"47",x"48",x"54"); --command and data to display RIGHT
constant dataU : arr :=    (X"38",X"0c",X"06",X"01",X"C0",X"55",x"50",x"20",x"20",x"20"); --command and data to display UP
constant dataD : arr :=    (X"38",X"0c",X"06",X"01",X"C0",X"44",x"4F",x"57",x"4E",x"20"); --command and data to display DOWN
constant dataN : arr :=    (X"38",X"0c",X"06",X"01",X"C0",x"57",x"41",x"49",x"54",x"20"); --command and data to display WAIT in intial state when waiting for gesture

begin

lcd_rw <= '0';  --lcd write

process(clk)
variable i : integer := 0;
variable j : integer := 1;

begin
if clk'event and clk = '1' then

if i <= 1000000 then
i := i + 1;
lcd_e <= '1';

if (lt = '0' and rt = '0' and up = '0' and down = '0') then  
data <= dataN(j)(7 downto 0);
end if;

if lt = '1' then
data <= dataL(j)(7 downto 0);
end if ;
 
if rt = '1' then
data <= dataR(j)(7 downto 0);
end if; 

if up = '1' then
data <= dataU(j)(7 downto 0);
end if ;
 
if down = '1' then
data <= dataD(j)(7 downto 0);
end if ;

elsif i > 1000000 and i < 2000000 then
i := i + 1;
lcd_e <= '0';
 
elsif i = 2000000 then
j := j + 1;
i := 0;
end if;

if j <= 5  then
lcd_rs <= '0';    --command signal
elsif j > 5   then
lcd_rs <= '1';   --data signal
end if;

if j = 11 then  --repeated display of data
j := 5;
end if;
end if;

end process;

end Behavioral;
