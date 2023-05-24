-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.03.2023 16:25:46
-- Design Name: 
-- Module Name: Calculator - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Description: Takes two operand and code inputs from switches and buttons as binary, to calculate an
--  output which is displayed on the 7 segment decoder. Contents of registers are displayed on LEDs.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Defining the inputs to the Calculator FPGA based on the constraints file, including buttons, switches, display and LEDs
entity Calculator is
    Port (  BTNL: in std_logic;
            BTNR: in std_logic;
            BTNC: in std_logic;
            BTNU: in std_logic;
           CLK100MHZ : in std_logic;
           C: out std_logic_vector(1 to 7);
           SW: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           AN: out std_logic_vector(7 downto 0);
            LED: out std_logic_vector (11 downto 0)); 
           
end Calculator;

-- Component definitions for the structural architecture of the Calculator

architecture behavioral of Calculator is

component multiplex_counter
     port(Clock : in  std_logic;
            Q : out std_logic_vector(2 downto 0));
     end component;

component bin_to_bcd
    port (
        reset : in std_logic;                                --! Asynchronous reset
        clock : in std_logic;                                --! System clock
        start : in std_logic;                                --! Assert to start conversion
        bin   : in std_logic_vector(23 downto 0);  --! Binary input
        bcd   : out std_logic_vector(27 downto 0); --! Binary coded decimal output
        ready : out std_logic);
    end component;

component BCD_TO_7SEG 
    Port ( bcd_in: in std_logic_vector (3 downto 0);
           leds_out: out	std_logic_vector (1 to 7));
        end component;   

component twos_comp_decoder is
  Port (input_value: in std_logic_vector(23 downto 0);
        output: out std_logic_vector(23 downto 0); 
        negative: out std_logic;
        sel: in std_logic);
end component;

component led_mux is
 Port (op_a: in std_logic_vector(11 downto 0);
       ob_b: in std_logic_vector(11 downto 0);
       code: in std_logic_vector(3 downto 0);
       sel: in std_logic_vector(1 downto 0); 
       display: out std_logic_vector(11 downto 0));  
end component;

component multiplex_output is
    Port (Clk_in : in std_logic;
        ones_in : in std_logic_vector (3 downto 0);
        tens_in : in std_logic_vector (3 downto 0);
        third_in : in std_logic_vector (3 downto 0);
        fourth_in : in std_logic_vector (3 downto 0);
        fifth_in : in std_logic_vector (3 downto 0);
        sixth_in : in std_logic_vector (3 downto 0);
        seventh_in : in std_logic_vector (3 downto 0);
        an_display : out std_logic_vector (7 downto 0);
        sign : in std_logic;
        bcd_out : out std_logic_vector (3 downto 0));
    end component;
    
component counter_400hz
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
   end component;
   
component fsm is
    Port ( button_c: in std_logic;
           button_u: in std_logic;
           reset: in std_logic;
           switches: in std_logic_vector(15 downto 0);
           operand_a_val: out std_logic_vector(11 downto 0);
           operand_b_val: out std_logic_vector(11 downto 0);
           code: out std_logic_vector(3 downto 0);
           sel: out std_logic;
           led_outpux_mux: out std_logic_vector(1 downto 0);
           clock: in std_logic);
end component;
    
component display_mux is
  Port (operand: in std_logic_vector(11 downto 0);
        result: in std_logic_vector(23 downto 0);
        sel: in std_logic;
        display: out std_logic_vector(23 downto 0)); 
end component;
    
component alu is
  Port (a: in std_logic_vector(11 downto 0);
        b: in std_logic_vector(11 downto 0);
        code: in std_logic_vector(3 downto 0);
        result: out std_logic_vector(23 downto 0)); 
end component;

-- Signals to connect components via port mapping

signal clock_400_signal, ready_signal, operand_result_select : std_logic; 
signal bcd_signal: std_logic_vector (27 downto 0); 
signal led_outpux_mux: std_logic_vector(1 downto 0); 
signal bcd_val_to_decode, code: std_logic_vector(3 downto 0);
signal result_out: std_logic_vector(23 downto 0);
signal operand_a_val, operand_b_val: std_logic_vector(11 downto 0);
signal num_to_decode: std_logic_vector(23 downto 0);
signal negative_val: std_logic; 
signal decoded: std_logic_vector(23 downto 0); 

-- Port mapping components for structural vhdl

begin
bcd_calc: bin_to_bcd port map(reset => BTNL ,clock => clock_400_signal, start => BTNR, bin => decoded, 
        bcd => bcd_signal, ready => ready_signal);
decoder: BCD_TO_7SEG port map (bcd_in => bcd_val_to_decode, leds_out => C); 
clock_400: counter_400hz port map (Clk_in => CLK100MHZ, Clk_out => clock_400_signal);
multiplex_display: multiplex_output port map (
            Clk_in => clock_400_signal,
            ones_in => bcd_signal (3 downto 0),
            tens_in => bcd_signal (7 downto 4),
            third_in => bcd_signal (11 downto 8),
            fourth_in =>bcd_signal (15 downto 12),
            fifth_in => bcd_signal (19 downto 16),
            sixth_in => bcd_signal (23 downto 20),
            seventh_in => bcd_signal (27 downto 24),
            an_display => AN,
            sign => negative_val,
            bcd_out => bcd_val_to_decode);
            
arithmetic: alu port map (a => operand_a_val,
        b => operand_b_val,
        code => code,
        result => result_out);
        
leds: led_mux port map (op_a => operand_a_val,
       ob_b => operand_b_val,
       code => code,
       sel => led_outpux_mux, 
       display => LED(11 DOWNTO 0));  
   
mux_out: display_mux port map (operand => SW(11 DOWNTO 0),
        result => result_out,
        sel => operand_result_select,
        display => num_to_decode);

twos_comp: twos_comp_decoder port map (input_value => num_to_decode,
        output => decoded,
        negative => negative_val,
        sel => operand_result_select);
 
calculator_states: fsm port map ( button_c => BTNC,
           button_u =>BTNU,
           reset => BTNL,
           switches => SW(15 DOWNTO 0),
           operand_a_val => operand_a_val,
           operand_b_val => operand_b_val,
           code => code,
           sel => operand_result_select,
           led_outpux_mux => led_outpux_mux,
           clock => clock_400_signal);
end Behavioral;
