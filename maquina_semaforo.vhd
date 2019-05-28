library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity maquina_semaforo is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  ready : in STD_LOGIC;--Ready es 1 cuando los tiempos de control display est�n codificados
           tvp : in  STD_LOGIC_VECTOR (7 downto 0);--tiempo_verde personas
           tva : in  STD_LOGIC_VECTOR (7 downto 0);--tiempo_verde autos
			  tx_full : in  STD_LOGIC;
           wr : out  STD_LOGIC;
           w_data : out  STD_LOGIC_VECTOR (7 downto 0);
           bt : in  STD_LOGIC; --boton para dar preferencia al peat�n
           sp : out  STD_LOGIC_VECTOR (1 downto 0); --Sem�foro Personas
           sa : out  STD_LOGIC_VECTOR (2 downto 0));--Sem�foro Autos
end maquina_semaforo;

architecture Behavioral of maquina_semaforo is
	type estados is (idle,s1,s2,s3);
	signal state_reg, state_next : estados;
	signal wr_reg,wr_next : std_logic;
	signal data_reg, data_next : std_logic_vector(7 downto 0);
	signal tick_next, tick_reg : unsigned(25 downto 0);
	signal tva_reg, tva_next : unsigned(7 downto 0);--Tiempo verde autos
	signal tvp_reg, tvp_next : unsigned(7 downto 0);--Tiempo verde personas
	signal sp_reg, sp_next : std_logic_vector(1 downto 0);--sem�foro personas
	signal sa_reg, sa_next : std_logic_vector(2 downto 0);--semaforo autos
	signal bt_reg, bt_next : std_logic; ----Habilitador del boton
begin
---------Register-------------------
process(clk,reset)
begin
	if(reset = '0') then
		state_reg <= idle;
		tva_reg <= (others => '0');
		tvp_reg <= (others => '0');
		sp_reg <= (others => '1');
		sa_reg <= (others => '1');
		tick_reg <= (others => '0');
		wr_reg <= '0';
		data_reg <= (others=>'0');
		bt_reg <= '0';
	elsif(clk'event and clk = '1') then
		state_reg <= state_next;
		tva_reg <= tva_next;
		tvp_reg <= tvp_next;
		sp_reg <= sp_next;
		sa_reg <= sa_next;
		bt_reg <= bt_next;
		tick_reg <= tick_next;
		wr_reg <= wr_next;
		data_reg <= data_next;		
	end if;
end process;
--------Next State Logic-------------
process(state_reg,tva_reg,tvp_reg,sp_reg,sa_reg,bt_reg,tvp,tva,bt,ready,tick_reg,tx_full,wr_reg,data_reg)
begin
	state_next <= state_reg;
	tva_next <= tva_reg;
	tvp_next <= tvp_reg;
	sp_next <= sp_reg;
	sa_next <= sa_reg;
	bt_next <= bt_reg;
	tick_next <= tick_reg;
	data_next <= data_reg;
	wr_next <= '0';
	case state_reg is
		when idle =>
			if(ready = '1')then
				state_next <= s1;
				tvp_next <= unsigned(tvp);
				tva_next <= unsigned(tva);
				bt_next <= '0';
			end if;
		when s1 =>	
			sp_next <= "10"; --------verde para personas
			sa_next <= "001";--------rojo para autos
			if(tvp_reg = 0) then
				state_next <= s2;
				bt_next <= '0';
			else
				if(tick_reg = 50000000) then
					tvp_next <= tvp_reg - 1;
					tick_next <= (others => '0');
				else
					tick_next <= tick_reg + 1;
					if(bt = '1' and bt_reg = '0') then	
						bt_next <= '1';
						tvp_next <= tvp_reg + 5;
						wr_next <= '1';
						if (tx_full = '0') then
							--wr_next <= '0';
							data_next <= "00110101";--5
						end if;
					end if;
				end if;
			end if;
				
				
			
		when s2 =>
			sp_next <= "01"; --------rojo para personas
			sa_next <= "100";--------verde para autos
			if(tva_reg = 4) then
				state_next <= s3;
			else
				if(tick_reg = 50000000) then
					tva_next <= tva_reg - 1;
					tick_next <= (others => '0');
				else
					tick_next <= tick_reg + 1;
					if(bt = '1' and bt_reg = '0' and tva_reg > 10) then	
						bt_next <= '1';
						tvp_next <= tvp_reg - 5;
						wr_next <= '1';
						if (tx_full = '0') then
							--wr_next <= '0';
							data_next <= "00110101";--5
						end if;
					end if;
				end if;
			end if;
		when s3 =>
			sp_next <= "01"; --------rojo para personas
			sa_next <= "010";--------rojo para autos
			
			if(tva_reg = 0) then
				state_next <= idle;
				bt_next <= '0';
			else
				if(tick_reg = 50000000) then
					tva_next <= tva_reg - 1;
					tick_next <= (others => '0');
				else
					tick_next <= tick_reg + 1;
				end if;	
			end if;
			
	end case;
end process;
wr <= wr_reg;
sa <= sa_reg;
sp <= sp_reg;
w_data <= data_reg;
end Behavioral;