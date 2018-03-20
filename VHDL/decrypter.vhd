--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:19:03 01/23/2018 
-- Design Name: 
-- Module Name:    decrypter - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decrypter is
	 Port ( clock : in  STD_LOGIC;
			  K : in  STD_LOGIC_VECTOR (31 downto 0);
			  C : in  STD_LOGIC_VECTOR (31 downto 0);
			  P : out  STD_LOGIC_VECTOR (31 downto 0);
			  done : out STD_LOGIC;
			  reset : in  STD_LOGIC;
			  enable : in  STD_LOGIC);
end decrypter;

architecture Behavioral of decrypter is
	signal n_0 : STD_LOGIC_VECTOR (5 downto 0) := "000000";
	-- steps used as loop's check
	signal steps : STD_LOGIC_VECTOR (5 downto 0) := "000000";
	signal T : STD_LOGIC_VECTOR (3 downto 0):= "0000";
	-- plain_text_helper used to avoid using inout signal.
	signal Plain_text_helper : STD_LOGIC_VECTOR (31 downto 0);
	signal j : std_logic;
--	signal K : std_logic_vector (31 downto 0);
begin
	
	process(clock, reset, enable) 
	 begin
		if (reset = '1') then
--			K <= rey;
			done<='0';
			Plain_text_helper <= "00000000000000000000000000000000";
			-- T(x) denotes the xth from right bit of T
			steps <= "000000";
			j<='0';
		elsif (clock'event and clock = '1' and enable = '1' ) then
			if (j <= '0') then 
			T(3) <= K(31) xor K(27) xor K(23) xor K(19) xor K(15) xor K(11) xor K(7) xor K(3);
			T(2) <= K(30) xor K(26) xor K(22) xor K(18) xor K(14) xor K(10) xor K(6) xor K(2);
			T(1) <= K(29) xor K(25) xor K(21) xor K(17) xor K(13) xor K(9) xor K(5) xor K(1);
			T(0) <= K(28) xor K(24) xor K(20) xor K(16) xor K(12) xor K(8) xor K(4) xor K(0);
			-- n_0 denotes the number of zeroes in the K.
			n_0 <= "100000" - (("00000" & K(0))+("00000" & K(1))+("00000" & K(2))+("00000" & K(3))+
					 ("00000" & K(4))+("00000" & K(5))+("00000" & K(6))+("00000" & K(7))+("00000" & K(8))
					 +("00000" & K(9))+("00000" & K(10))+("00000" & K(11))+("00000" & K(12))+("00000" & K(13))
					 +("00000" & K(14))+("00000" & K(15))+("00000" & K(16))+("00000" & K(17))+("00000" & K(18))
					 +("00000" & K(19))+("00000" & K(20))+("00000" & K(21))+("00000" & K(22))+("00000" & K(23))
					 +("00000" & K(24))+("00000" & K(25))+("00000" & K(26))+("00000" & K(27))+("00000" & K(28))
					 +("00000" & K(29))+("00000" & K(30))+("00000" & K(31)));	
			j <= '1';
			elsif (steps <= n_0) then
				if(steps = "000000") then
					-- initialisation and first steps
					Plain_text_helper <= C;
					T <= T + "1111";
					steps <= steps + "000001";
				else
					-- body of the loop to be executed
					Plain_text_helper <= Plain_text_helper xor (T & T & T & T & T & T & T & T);
					T <= T + "1111";
					steps <= steps + "000001";
				end if;	
			-- final step
			elsif (steps>n_0) then 
				P <= Plain_text_helper;
				done <='1';
				Plain_text_helper <= "00000000000000000000000000000000";
			-- T(x) denotes the xth from right bit of T
				steps <= "000000";
				j<='0';
			end if;
		end if;	
		
	end process;
	
end Behavioral;