----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineer: Arabella Cryer, Amber Waymouth, William Thorpe
-- 
-- Create Date: 07.03.2023 16:25:46
-- Design Name: 
-- Module Name: fsm - Behavioral
-- Project Name: Fast Calculator
-- Target Devices: Nexys Artix 7
-- Description: The finite state machine has four main states that it cycles through based
-- on a clock edge and button presses. This allows the calculator to input different operands
-- then output a result.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port ( button_c: in std_logic;   -- Load button
           button_u: in std_logic;   -- Change state on fsm
           reset: in std_logic;
           switches: in std_logic_vector(15 downto 0);
           operand_a_val: out std_logic_vector(11 downto 0);
           operand_b_val: out std_logic_vector(11 downto 0);
           code: out std_logic_vector(3 downto 0);
           sel: out std_logic;
           led_outpux_mux: out std_logic_vector(1 downto 0);
           clock: in std_logic);
end fsm;

architecture Behavioral of fsm is
    type state is (OPERAND_A, OPERAND_B, CHOOSE_FUNC, DISPLAY_RESULT); 
    
    signal current_state, next_state : state := OPERAND_A; 
    signal is_pressed : std_logic := '0';

    begin
    
    process (button_c, clock, button_u)
    begin
    
    if rising_edge(clock) then -- States only change when there is a rising clock edge.
        if (reset = '1') then -- Allows easy reset to the initial state if a user makes a mistake
            current_state <= OPERAND_A; -- The first state is always initialised to the first operand input
        elsif button_c = '1' and is_pressed = '0' then -- States only change when the button is pressed.
                current_state <= next_state; 
                is_pressed <= '1'; -- Is_pressed boolean prevents the fsm from jumping to the next state
            end if;
        end if;
        
        if is_pressed = '1' and button_c = '0' and button_u = '1' then 
            is_pressed <= '0'; -- the combination of the boolean and switching prevents states from changing too quickly
        end if;
       end process;

    process 
        variable op_a, op_b: std_logic_vector(11 downto 0):= "000000000000"; -- Variables allow local changes to registers in the process.
        variable code_val: std_logic_vector(3 downto 0):="0000";
        begin
        
            case current_state is 
                when OPERAND_A => 
                    sel <= '0'; -- Ensures that the values of the switches are displayed rather than the uncalculated result output.
                    op_a := switches(11 downto 0); -- The values of the switches determine the values of the registers
                    led_outpux_mux <="00"; -- Nothing is stored in registers yet, thus the mux does not display an output to the LEDs
                    next_state <= OPERAND_B; -- Update the next state to input the next operand
                            
               when OPERAND_B => 
                    sel <= '0';
                    led_outpux_mux <= "01"; -- This mux allows the LEDs to display the contents of the first operand register
                    op_b := switches(11 downto 0);
                    next_state <= CHOOSE_FUNC;  
                         
                when CHOOSE_FUNC => 
                    sel <= '0';
                    led_outpux_mux <= "10";
                    code_val := switches(15 downto 12); -- The code is inputted with the remaining unused switches in postfix notation.
                    next_state <= DISPLAY_RESULT; 
                    
              when DISPLAY_RESULT => 
                    sel <= '1'; -- Updates display to show the updated, calculated result output.
                    led_outpux_mux <= "11";
                    next_state <= OPERAND_A;
                    
                when others => 
                    sel <= '0'; -- Ensures that the calculator is reset if unusual state changes occur
                    led_outpux_mux <= "00";
                    next_state <= OPERAND_A; 
                    end case;
                operand_a_val <= op_a; -- Assigns the intermediate variables to the predefined registers.
                operand_b_val <= op_b;
                code <= code_val;
            end process;    

end Behavioral;
