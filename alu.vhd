-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.03.2023 16:25:46
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Description: Completes addition, subtraction, multiplication and modulo of two operands  
--! Takes two operand inputs and a code to determining the operation, to produce a result output
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Implements numeric functions on signed and unsigned vectors

-- Port definitions for the Arithmetic logic unit
entity alu is
  Port (
    a: in std_logic_vector(11 downto 0);
    b: in std_logic_vector(11 downto 0);
    code: in std_logic_vector(3 downto 0);
    result: out std_logic_vector(23 downto 0)
  ); 
end alu;

architecture Behavioral of alu is
-- Variables to convert to a signed vector for operations
    shared variable a_val, b_val, result_val: signed(23 downto 0) := "000000000000000000000000";
begin
  process (a, b, code) 
  begin
	-- Resize to fit result output vector
    a_val := resize(signed(a),24);
    b_val := resize(signed(b),24);
    case code is
      when "0001" =>
        result_val := (a_val + b_val);
      when "0010" => 
        result_val := (a_val - b_val);
      when "0100" =>
	      result_val := resize((a_val * b_val),24); -- Removes overflow from multiplying 24 bit variables
      when "1000" =>
        result_val := (a_val mod b_val);
      when others =>
        result <= (others => 'X'); 	-- Covering any accidental other states
    end case;
    result <= std_logic_vector(result_val);
  end process; 
end Behavioral;
