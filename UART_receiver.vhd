
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_receiver is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           s_tick : in  STD_LOGIC;
           rx_done : out  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end UART_receiver;

architecture Behavioral of UART_receiver is
signal s_reg, s_next : unsigned(3 downto 0); -- Contador para muestrear la se�ar entrante
signal n_reg, n_next : unsigned(2 downto 0); -- Registro de los datos leidos
signal b_reg, b_next : std_logic_vector(7 downto 0);
type estados is (idle,start,data,stop);
signal state_next, state_reg : estados;
begin
-----------------------Register----------------------
	process(clk,reset)
	begin
		if reset = '0' then
			state_reg <= idle;
			s_reg <= (others => '0');
			n_reg <= (others => '0');
			b_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
		end if;
	end process;
----------------Next State Logic---------------------
	process(state_reg,s_reg,n_reg,b_reg,s_tick,rx)
	begin
		state_next <= state_reg;
		s_next <= s_reg; 
		n_next <= n_reg;
		b_next <= b_reg;
		rx_done <= '0';
		case state_reg is
			when idle =>
				if rx = '0' then
					s_next <= (others => '0');
					state_next <= start;
				end if;
			when start =>
				if s_tick = '1' then
					if s_reg = 7 then
						s_next <= (others => '0');
						n_next <= (others => '0');
						state_next <= data;
					else
						s_next <= s_reg + 1;
					end if;
				end if;
			when data =>
				if s_tick = '1' then
					if s_reg = 15 then
						s_next <= (others => '0');
						b_next <= rx & b_reg(7 downto 1);
						if n_reg = 7 then
							state_next <= stop;
						else
							n_next <= n_reg + 1;
						end if;
					else
						s_next <= s_reg + 1;
					end if;
				end if;
			when stop =>
				if s_tick = '1' then
					if s_reg = 15 then
						rx_done <= '1';
						state_next <= idle;
					else
						s_next <= s_reg + 1;
					end if;
				end if;
		end case;
	end process;
	dout <= b_reg;
end Behavioral;

