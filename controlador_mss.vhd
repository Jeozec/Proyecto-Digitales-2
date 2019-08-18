library ieee;
use ieee.std_logic_1164.all;

entity controlador_mss is
	port(	clock,reset,start,termostato,anemometro,sensor_lluvia,sensor_ventana,ok_delay_15m,ok_delay_3s:	in std_logic;
			replegar_toldo,desplegar_toldo,toldo_desplegado,encender_ventilador,
			en_delay_3s,en_delay_15m,reset_delay_3s,reset_delay_15m: 													out std_logic;
			estado: 																														out std_logic_vector(3 downto 0));
end controlador_mss;

architecture solucion of controlador_mss is
type estados is (Ta,Tb,Tc,Td,Te,Tf,Tg,Th,Ti,Tj,Tk,Tl,Tm,Tn,Tp);
signal y: estados;
begin
process(clock,reset)
	begin
	if reset <= '0' then y <= Ta;
	elsif clock'event and clock = '1' then
	case y is
		when Ta => if	start				='1' 									then y <= Tb; else y <= Ta; end if;
		when Tb => if	start 			='0' 									then y <= Tc; else y <= Tb; end if;
		when Tc => if	sensor_lluvia 	='0'	and sensor_ventana = '1'	then y <= Td; else y <= Tf; end if;
		when Td => if	ok_delay_3s 	='1' 									then y <= Te; else y <= Td; end if;
		when Te => if	sensor_lluvia	='1' 									then y <= Tc; else y <= Te; end if;
		when Tf => if	termostato		='1'	then y <= Tg; 
					  elsif	termostato = '0'	and sensor_lluvia = '1' and sensor_ventana = '1' then y <= Tk;
					  else	y <= Tn;	end if;
		when Tg => if	ok_delay_3s 	='1' 									then y <= Th; else y <= Tg; end if;
		when Th => if 	ok_delay_15m 	='1'	and termostato =	'1'	then y <= Tm; 
					  elsif ok_delay_15m	='0'	then y <= Th;	else y <= Ti; end if;	
		when Ti => if 	ok_delay_3s 	='1'									then y <= Tj; else y <= Ti; end if;
		when Tj => if	(termostato or sensor_lluvia)	='1'				then y <= Tc; else y <= Tj; end if;
		when TK => if 	ok_delay_3s 	='1' 									then y <= Tl; else y <= Tk; end if;
		when Tl => if	(termostato	or	not(sensor_lluvia) or not(sensor_ventana)) = '1'  then y <= Tc; else y <= Tl; end if;
		when Tm => if	termostato		='0'									then y <= Ti; else y <= Tm; end if;
		when Tn => if	ok_delay_3s		='1'									then y <= Tp; else y <= Tn; end if;
		when Tp => if	termostato  	= '1'									then y <= Tc; else y <= Tp; end if;
	end case;
	end if;
end process;

process(y)
	begin
	replegar_toldo 		<= '0';	desplegar_toldo		<= '0';	toldo_desplegado 	<= '0';
	encender_ventilador 	<= '0';	en_delay_3s 			<= '0';	en_delay_15m		<= '0';	reset_delay_3s 	<= '0';	reset_delay_15m 	<= '0';
	case y is
		when 	Ta => estado <= "0000";	reset_delay_3s 	<= '1'; reset_delay_15m 		<= '1';
		when 	Tb => estado <= "0001";
		when 	Tc => estado <= "0010"; reset_delay_15m	<= '1';	reset_delay_3s			<= '1';
		when 	Td => estado <= "0011";	desplegar_toldo 	<= '1';	en_delay_3s 			<= '1';
		when 	Te => estado <= "0100";	toldo_desplegado	<= '1';
		when 	Tf => estado <= "0101";
		when 	Tg => estado <= "0110";	desplegar_toldo 	<= '1';	en_delay_3S 			<= '1';
		when 	Th => estado <= "0111";	toldo_desplegado 	<= '1';	reset_delay_3s 		<= '1';	en_delay_15m		<= '1'; 
		when 	Ti => estado <= "1000";	replegar_toldo 	<= '1';	en_delay_3s 			<= '1';
		when 	Tj => estado <= "1001";
		when	Tk => estado <= "1010"; desplegar_toldo 	<= '1';	en_delay_3S 			<= '1';
		when	Tl => estado <= "1011";	toldo_desplegado 	<= '1';	reset_delay_3s 		<= '1';
		when	Tm => estado <= "1100"; toldo_desplegado 	<= '1';	encender_ventilador	<= '1';
		when	Tn => estado <= "1101"; replegar_toldo 	<= '1';	en_delay_3s 			<= '1';
		when	Tp => estado <= "1110";
	end case;
end process;
end solucion; 
		
		