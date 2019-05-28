Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_HOLA is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tx_full : in  STD_LOGIC;
           wr : out  STD_LOGIC;
           w_data : out  STD_LOGIC_VECTOR (7 downto 0));
end FSM_HOLA;

architecture Behavioral of FSM_HOLA is
type hola is (H,O,L,A);
signal state_next,state_reg : hola;
signal wr_reg,wr_next : std_logic;
signal data_reg, data_next : std_logic_vector(7 downto 0);
begin
	-----------------REGISTER-----------------------
	process(clk,reset)
	begin
		if (reset = '0') then
			state_reg <= h;
			wr_reg <= '0';
			data_reg <= (others=>'0');
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
			wr_reg <= wr_next;
			data_reg <= data_next;
		end if;
	end process;
	-----------------NEXT STATE LOGIC---------------
	process(state_reg,wr_reg,data_reg,tx_full)
	begin
		state_next <= state_reg;
		wr_next <= wr_reg;
		data_next <= data_reg;
		wr_next <= '0';
		case state_reg is
			when h =>
				wr_next <= '1';
				if (tx_full = '0') then
					--wr_next <= '0';
					data_next <= "01001000";
					state_next <= o;
				end if;
			when o =>
				wr_next <= '1';
				if (tx_full = '0') then
					--wr_next <= '0';
					data_next <= "01001111";
					state_next <= l;
				end if;
			when l =>
				wr_next <= '1';
				if (tx_full = '0') then
					--wr_next <= '0';
					data_next <= "01001100";
					state_next <= a;
				end if;
			when a =>
				wr_next <= '1';
				if (tx_full = '0') then
					--wr_next <= '0';
					data_next <= "01000001";
					state_next <= h;
				end if;
		end case;
	end process;
	wr <= wr_reg;
	w_data <= data_reg;
end Behavioral;

