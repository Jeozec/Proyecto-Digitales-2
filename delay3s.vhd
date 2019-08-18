LIBRARY IEEE;
     USE IEEE.STD_LOGIC_1164.all;
     USE IEEE.NUMERIC_STD.all;

     ENTITY delay3s IS
	    GENERIC (width:POSITIVE:=2);
       PORT (clk   : IN std_logic; 
             reset : IN std_logic; 
             enable: IN std_logic;
				 ok_3S : OUT std_logic);
     END delay3s;

     ARCHITECTURE arch1 OF delay3s IS
       SIGNAL cnt : UNSIGNED(width-1 DOWNTO 0);
		 SIGNAL count : std_logic_vector(width-1 DOWNTO 0);


     BEGIN

       pSeq : PROCESS (clk, reset) IS 
       BEGIN
         IF reset = '1' THEN
           cnt <= (others => '0');
         ELSIF clk'event AND clk='1' THEN
           IF enable='1' THEN
             cnt <= cnt + 1;
           END IF;
         END IF;
       END PROCESS;

       count <= std_logic_vector(cnt);
		 ok_3s <= '1' when count = "10" else '0';
		 

     END arch1;