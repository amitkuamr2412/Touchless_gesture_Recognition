library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm is port (
      clk, reset: in std_logic;
      l1,l2,r1,r2: in std_logic;         
      left1_sig, right1_sig, up_sig, down_sig,a,b,c,d : out std_logic;   
		lcd_rw : out std_logic;                         --read & write control
      lcd_e : out std_logic;                         --enable control
      lcd_rs : out std_logic;                         --data or command control
      data  : out std_logic_vector(7 downto 0)
		);     --data line
end fsm;


architecture a1 of fsm is

component slowclk is
	port (inclk : in std_logic;
			outclk : out std_logic);
end component;

component lcd is

port ( clk ,lt,rt,up,down   : in std_logic;                          --clock i/p

       lcd_rw : out std_logic;                         --read & write control

       lcd_e : out std_logic;                         --enable control

       lcd_rs : out std_logic;                         --data or command control

       data  : out std_logic_vector(7 downto 0));     --data line

end component;

type stateType is (phi, left1,mid_left1,mid_right1,right1,mid_up,up,down,mid_down);
signal state: stateType;
signal countReg: std_logic_vector(14 downto 0);  	 
signal sclk,l,r,u,dn: std_logic ;
begin
    s1 : slowclk port map (inclk=>clk, outclk=>sclk);
      process(sclk) begin
       if rising_edge(sclk) then
        if reset = '1' then
           state <= phi;
        end if;
-- ---------------------------Initial states-----------------------------------------------
      case state is
       when phi =>
		 countReg <= (others => '0');
         if (r1 and r2) = '1' then
         state <= mid_left1 ;
			elsif (l1 and l2) = '1' then
         state <= mid_right1 ;
			elsif (l1 and r1) = '1' then
         state <= mid_down ;
			elsif (l2 and r2) = '1' then
         state <= mid_up ;
         end if;
-------------------------------Intermediate states--------------------------------------				
      when mid_left1 =>
       if (l1 and l2) = '1' then
       countReg <= (others => '0');
         state <= left1;
          end if;

     when mid_right1 =>
       if (r1 and r2) = '1' then
       countReg <= (others => '0');
         state <= right1;
          end if;

     when mid_up =>
       if (l1 and r1) = '1' then
       countReg <= (others => '0');
         state <= up;
          end if;

     when mid_down =>
       if (l2 and r2) = '1' then
       countReg <= (others => '0');
         state <= down;
          end if;
 -----------------------------Wait states for 3000 ms and return to phi states for next gesture-------------------------------------------                    

      when left1 =>
          if countReg /= 3000 then 
           countReg <= countReg + 1;
         elsif countReg = 3000 then
             state <= phi;
         end if;

      when right1 =>
          if countReg /= 3000 then 
           countReg <= countReg + 1;
         elsif countReg = 3000 then
             state <= phi;
         end if;

      when up =>
          if countReg /= 3000 then 
           countReg <= countReg + 1;
         elsif countReg = 3000 then
             state <= phi;
         end if;

      when down =>
          if countReg /= 3000 then 
           countReg <= countReg + 1;
         elsif countReg = 3000 then
             state <= phi;
         end if;


          end case;
          end if;
 end process;

 l <= '1' when state = left1 else '0';
 r<= '1' when state = right1 else '0';
 u <= '1' when state = up else '0';
 dn <= '1' when state = down else '0'; 
a <= l1 ;
b <= l2 ;
c <= r1 ;
d <= r2 ;
left1_sig <= l;
right1_sig <= r ;
up_sig <= u  ;
down_sig <= dn ;

lcd_type : lcd port map (clk => clk,lt=>l,rt=>r,up=>u,down=>dn,lcd_rw =>lcd_rw ,lcd_e => lcd_e, lcd_rs=> lcd_rs, data => data ) ;
end a1; 
