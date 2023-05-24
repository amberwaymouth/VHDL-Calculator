----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.05.2023 17:13:45
-- Design Name: 
-- Module Name: alu_tb - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Tool Versions: 
-- Description: Tests various negative and positive inputs with simulation vectors.
-- The output waveforms determine if the alu is functioning correctly.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_tb is
-- No port definition since it is a test bench
end alu_tb;

architecture Behavioral of alu_tb is

-- Testing the alu component

component alu is
  Port (
    a: in std_logic_vector(11 downto 0);
    b: in std_logic_vector(11 downto 0);
    code: in std_logic_vector(3 downto 0);
    result: out std_logic_vector(23 downto 0)
  ); 
end component;

-- Signals are mapped to the input and output ports
signal a, b: std_logic_vector(11 downto 0);
signal code: std_logic_vector(3 downto 0);
signal result: std_logic_vector(23 downto 0);
    
begin

uut: alu port map(a=>a, b=>b,code=>code,result=>result); -- Map ports as a unit under test

 io_process : process
  begin  
 a <= "000010001000"; -- Two positive inputs
 b <= "010011001100";
 code <= "0001";      -- Addition code
 wait for 25 ns;      -- Allow time to display the waveforms on the testbench simulation software
 
 a <= "000010001000"; -- Positive operand A, negative operand B
 b <= "110011001100";
 code <= "0001";
 wait for 25 ns;
 
 a <= "100010001000"; -- Negative operand A, positive operand B
 b <= "010011001100";
 code <= "0001";
 wait for 25 ns;
 
 a <= "100010001000"; -- Two negative operands
 b <= "110011001100";
 code <= "0001";
 wait for 25 ns;
 
 a <= "000010001000";
 b <= "010011001100";
 code <= "0010";      -- Subtraction code
 wait for 25 ns;
 
 a <= "000010001000";
 b <= "110011001100";
 code <= "0010";
 wait for 25 ns;
 
 a <= "100010001000";
 b <= "010011001100";
 code <= "0010";
 wait for 25 ns;
 
 a <= "100010001000";
 b <= "110011001100";
 code <= "0010";      
 wait for 25 ns;
 
  a <= "000010001000";
 b <= "010011001100";
 code <= "0100";      -- Multiplication code
 wait for 25 ns;
 
 a <= "000010001000";
 b <= "110011001100";
 code <= "0100";
 wait for 25 ns;
 
 a <= "100010001000";
 b <= "010011001100";
 code <= "0100";
 wait for 25 ns;
 
 a <= "100010001000";
 b <= "110011001100";
 code <= "0100";
 wait for 25 ns;
 
  a <= "000010001000";
 b <= "010011001100";
 code <= "1000";      -- Modulo code
 wait for 25 ns;
 
 a <= "000010001000";
 b <= "110011001100";
 code <= "1000";
 wait for 25 ns;
 
 a <= "100010001000";
 b <= "010011001100";
 code <= "1000";
 wait for 25 ns;
 
 a <= "100010001000";
 b <= "110011001100";
 code <= "1000";
 wait for 25 ns;

  end process io_process; 

end Behavioral;
