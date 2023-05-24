----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.03.2023 16:25:46
-- Design Name: 
-- Module Name: display_mux - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Description: Mux takes switch inputs, corresponding to operands, and result inputs,
-- from the alu. The mux determines whether the result has been processed, thus can be displayed
-- or if it should display the current operands.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_mux is
  Port (operand: in std_logic_vector(11 downto 0); -- Switch inputs
        result: in std_logic_vector(23 downto 0); -- Result registers from alu
        sel: in std_logic;                         -- Mux selects for display
        display: out std_logic_vector(23 downto 0)); -- Output to the display module
end display_mux;

architecture Behavioral of display_mux is

begin
    process (sel, operand, result)
    begin 
        case (sel) is
            when '0' => display <= ("000000000000000000000000" + operand); -- Display operand from the switches
            when '1' => display <= result; -- Display the result from the alu
            when others => display <= "000000000000000000000000"; -- Display nothing if another state is entered accidentally
        end case;
    end process;
end Behavioral;
