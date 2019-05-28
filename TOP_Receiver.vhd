library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_Receiver is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           rd_uart : in  STD_LOGIC;
           r_data : out  STD_LOGIC_VECTOR (7 downto 0);
           rx_empty : out  STD_LOGIC);
end TOP_Receiver;

architecture Behavioral of TOP_Receiver is
-----------Component----------------------

-----------Signal-------------------------
begin
-------------------Instantiation----------

end Behavioral;

