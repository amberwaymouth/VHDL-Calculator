----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.03.2023 16:25:46
-- Design Name: 
-- Module Name: multiplex_output - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Description: This multiplexer changes the outputs to each segment of the display
-- at a high frequency to allow a range of different numbers to display.
-- The frequency is fast enough for the human eye to not notice the multiplexing.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplex_output is
    Port (Clk_in : in std_logic;
        ones_in : in std_logic_vector (3 downto 0); -- BCD signal split up into 4 bit signals, corresponding to each 4 bit BCD number
        tens_in : in std_logic_vector (3 downto 0);
        third_in : in std_logic_vector (3 downto 0);
        fourth_in : in std_logic_vector (3 downto 0);
        fifth_in : in std_logic_vector (3 downto 0);
        sixth_in : in std_logic_vector (3 downto 0);
        seventh_in : in std_logic_vector (3 downto 0);
        sign: in std_logic; -- sign bit corresonding to the negative sign on the display
        an_display : out std_logic_vector (7 downto 0); -- Anodes corresponding to the display segment that is on
        bcd_out : out std_logic_vector (3 downto 0));   -- BCD signal corresponding to the correct number on the display
end multiplex_output;

architecture Behavioral of multiplex_output is

signal temp_bcd : std_logic_vector (3 downto 0);
signal an_output : std_logic_vector (7 downto 0);
signal sel: std_logic_vector(2 downto 0):="000";

begin
    clock: process (Clk_in)
		begin
		if Clk_in = '1' and Clk_in'Event then
		  if (sel = "000") then                -- process cycles through counting up to 8, displaying each number 
				    temp_bcd <= ones_in;       -- individually on the display at a high frequency to appear like one number
				    an_output <= "11111110"; 
				    sel <= "001";	 
		  elsif (sel = "001")  then 
				    temp_bcd <= tens_in;
                    an_output <= "11111101"; 	 
                    sel <= "010";	 
		  elsif (sel = "010")	then 
				    temp_bcd <= third_in;
				    an_output <= "11111011"; 
				    sel <= "011";
		  elsif (sel = "011")	then
				    temp_bcd <= fourth_in;
				    an_output <= "11110111"; 
				    sel <= "100";
		  elsif (sel = "100")	then 
				    temp_bcd <= fifth_in;
				    an_output <= "11101111"; 
				    sel <= "101";
	       elsif (sel = "101") then 
				    temp_bcd <= sixth_in;
				    an_output <= "11011111"; 
				    sel <= "110";
		   elsif (sel = "110") then
				    temp_bcd <= seventh_in;
				    an_output <= "10111111"; 
				    sel <= "111";
		   elsif (sel = "111") then
		             temp_bcd <= "111" & not(sign); -- invert sign bit to give a better bcd to 7seg code, rather than 1111, which corresponds to 0 in BCD_TO_7SEG file
		             an_output <= "01111111";
		             sel <= "000";
		             end if;
		     end if;

	end process clock;
    an_display <= an_output; -- Assign outputs to ports 
	bcd_out <= temp_bcd;

end Behavioral;
