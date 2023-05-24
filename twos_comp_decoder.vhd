----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.03.2023 16:25:46
-- Design Name: 
-- Module Name: twos_comp_decoder - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Description: This decodes numbers if they are negative, thus inputted in two's complement
-- This allows negative outputs to be displayed on the 7 segment display.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity twos_comp_decoder is
  Port (input_value: in std_logic_vector(23 downto 0);
        output: out std_logic_vector(23 downto 0); 
        negative: out std_logic;
        sel: in std_logic);
end twos_comp_decoder;

architecture Behavioral of twos_comp_decoder is
signal operand_input: signed(11 downto 0);
signal magnitude_val: std_logic_vector(10 downto 0);
signal negative_out: std_logic := '0'; 
signal temp : std_logic_vector(12 downto 0) := "0000000000000";
begin

    process (input_value)
    begin
        if sel = '0' then                 -- Checks if the input is an operand or a result from the ALU
            if input_value(11) = '1' then
                operand_input <= (not signed(input_value(11 downto 0))) + 1;    -- Inverts the operand if it is a negative number with two's complemenet
                magnitude_val <= std_logic_vector(operand_input(10 downto 0));  -- Adjusts the vector size to remove overflow
                output <= temp & magnitude_val;                                 -- Concatenates the vector to match the output vector size, since it is a 12 bit operand
                negative_out <= '1';      -- sets a sign bit to turn the negative sign on for the display

            else
                output <= input_value;
                negative_out <= '0';
            end if;
        else
            if (input_value(23) = '1') then   -- Checks if the result from the alu is negative
                output <= std_logic_vector((not signed(input_value)) + 1); -- Inverts if the number is negative
                negative_out <= '1';
            else
                output <= input_value;
                negative_out <= '0';
            end if;
        end if;
        negative <= negative_out; 
    end process;

end Behavioral;
