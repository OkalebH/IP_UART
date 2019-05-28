library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Transmitter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           s_tick : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR(7 downto 0);
           tx_start : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           tx_done : out  STD_LOGIC);
end Transmitter;

architecture Behavioral of Transmitter is
type state_type is (idle,start,data,stop);
signal state_next, state_reg : state_type;
signal s_next, s_reg : unsigned(3 downto 0);
signal n_next, n_reg : unsigned(2 downto 0);
signal b_next, b_reg : std_logic_vector(7 downto 0);
signal tx_next, tx_reg : std_logic;
begin
------Registro----------------------------------------
	process(clk,reset)
	begin
		if reset = '0' then
			state_reg <= idle;
			s_reg <= (others => '0');
			n_reg <= (others => '0');
			b_reg <= (others => '0');
			tx_reg <= '1';
		elsif (clk'event and clk = '1')then
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
			tx_reg <= tx_next;
		end if;
	end process;
----------------L�gica del estado siguiente-----------
	process(state_reg,s_reg,n_reg,b_reg,tx_reg,din,s_tick,tx_start)
	begin
		state_next <= state_reg;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		tx_next <= tx_reg;
		tx_done <= '0';
		case state_reg is
			when idle =>
				tx_next <= '1';
				if tx_start = '1' then
					state_next <= start;
					s_next <= (others => '0');
					b_next <= din;
				end if;
			when start =>
				tx_next <= '0';
				if (s_tick = '1') then
					if s_reg = 15 then
						state_next <= data;
						s_next <= (others => '0');
						n_next <= (others => '0');
					else
						s_next <= s_reg + 1;
					end if;
				end if;
			when data =>
				tx_next <= b_reg(0);
				if (s_tick = '1') then
					if s_reg = 15 then
						s_next <= (others => '0');
						b_next <= '0' & b_reg(7 downto 1);
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
				tx_next <= '1';
				if(s_tick = '1') then
					if s_reg = 15 then
						state_next <= idle;
						tx_done <= '1';
					else
						s_next <= s_reg + 1;
					end if;
				end if;
		end case;
	end process;
	tx <= tx_reg;
end Behavioral;

