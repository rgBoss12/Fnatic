----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:12:16 01/23/2018 
-- Design Name: 
-- Module Name:    encrypter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encrypter is
    Port ( clock : in  STD_LOGIC;
           K : in  STD_LOGIC_VECTOR (31 downto 0);
           P : in  STD_LOGIC_VECTOR (31 downto 0);
           C : out  STD_LOGIC_VECTOR (31 downto 0);
           reset : in  STD_LOGIC;
           done: out STD_LOGIC;
           enable : in  STD_LOGIC);
end encrypter;

architecture Behavioral of encrypter is
	signal T: std_logic_vector(3 downto 0); 
	-- i denotes the # of times the loop is running (32)
	signal i: unsigned(5 downto 0);
	-- j is used to differentiate the first steps from the loop body (0 means first step, otherwise the loop body)
	signal j: std_logic;
	-- cyphered_text_helper used to avoid using inout type, temporary loop variable
	signal cyphered_text_helper: std_logic_vector(31 downto 0);
begin
	process(clock, reset, enable)
	 begin
		if (reset = '1') then
			-- initialisation
			i<="000000";
			j <= '0';
			done<='0';
			cyphered_text_helper <= "00000000000000000000000000000000";	
		elsif (clock'event and clock = '1' and enable = '1') then
			-- loop body
			if((to_integer(unsigned(i)))=0 and j='0') then
				-- initial steps
				T(3) <= K(31)XOR K(27)XOR K(23)XOR K(19)XOR K(15)XOR K(11)XOR K(7)XOR K(3);
				T(2) <= K(30)XOR K(26)XOR K(22)XOR K(18)XOR K(14)XOR K(10)XOR K(6)XOR K(2);
				T(1) <= K(29)XOR K(25)XOR K(21)XOR K(17)XOR K(13)XOR K(9)XOR K(5)XOR K(1);
				T(0) <= K(28)XOR K(24)XOR K(20)XOR K(16)XOR K(12)XOR K(8)XOR K(4)XOR K(0);
				cyphered_text_helper <= P; 
				j <= '1';
			elsif(j='1' and to_integer(unsigned(i))<32) then
					if(K(to_integer(unsigned(i)))='1') then
						cyphered_text_helper <= cyphered_text_helper XOR (T&T&T&T&T&T&T&T);
						T <= T+1; 
					end if;			
				i <= i+1;
			elsif (to_integer(unsigned(i))>=32) then
				-- final step : eliminating the temporary variable.
				C <= cyphered_text_helper;
				done<= '1';
				i<="000000";
				j <= '0';
			   cyphered_text_helper <= "00000000000000000000000000000000";
			end if;
		end if;		
	 end process;

end Behavioral;