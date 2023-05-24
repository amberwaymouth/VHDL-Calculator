----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.03.2023 16:25:46
-- Design Name: 
-- Module Name: led_mux - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Description: This mux controls which registers are displayed on the LEDs, based on 
-- which register has been loaded in the previous state.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_mux is
 Port (op_a: in std_logic_vector(11 downto 0); -- Operand A from the register
       ob_b: in std_logic_vector(11 downto 0); -- Operand B from the register
       code: in std_logic_vector(3 downto 0);  -- Code from the register
       sel: in std_logic_vector(1 downto 0);   -- Selecting which input to display
       display: out std_logic_vector(11 downto 0));  -- Display connected to LEDs
end led_mux;

architecture Behavioral of led_mux is
begin
process (sel, op_a, ob_b, code) 
    begin
    case (sel) is 
        when "00" => display <= "000000000000"; -- Display nothing before any vectors are stored
        when "01" => display <= op_a;
        when "10" => display <= ob_b; 
        when "11" => display <= ("00000000" & code); -- Concatenates code with zeroes to fit the 12 bit output
        when others => display <= "000000000000"; 
    end case; 
end process; 
end Behavioral;
