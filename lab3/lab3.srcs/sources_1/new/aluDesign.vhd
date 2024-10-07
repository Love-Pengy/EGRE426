----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Brandon Frazier
-- 
-- Create Date: 09/17/2024 03:05:11 PM
-- Design Name: 
-- Module Name: aluDesign - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.std_logic_1164.ALL;

entity ALU is

    generic(N : integer := 32);
    port(
         -- in 1
         A: in std_logic_vector(31 downto 0);
         -- in 2
         B: in std_logic_vector(31 downto 0);
         -- result
         C: out std_logic_vector(31 downto 0);
         -- 000 Addition 
         -- 001 Subtraction
         -- 010 Bitwise AND
         -- 011 Bitwise OR
         -- 100 Logical left shift
         -- 101 Logical right shift
         -- 110 arithmetic left shift
         -- 111 arithmetic right shift
         -- mode
        Mode: in std_logic_vector(2 downto 0);
        
        -- Output Flags
        Zero: out std_logic;
        Overflow: out std_logic;
        Cout: out std_logic);
end ALU;

architecture Behavioral of ALU is
    signal carry : std_logic_vector(N-1 downto 0);
    
    
    begin
       
    process(A, B, Mode)
        begin
        case Mode is
            when "000" =>
                 
                  C <= std_logic_vector(adderC(31 downto 0));
                  if(adderC = B"0000_0000_0000_0000_0000_0000_0000_0000") then 
                    Zero <= '1'; 
                  else 
                    Zero <= '0';
                  end if;
                  Cout <= adderC(32);
                  if((A(31) AND B(31) AND (NOT adderC(31))) = '1')then 
                    overflow <= '1';
                  elsif(((NOT A(31)) AND (NOT B(31)) AND adderC(31)) = '1') then
                    overflow <= '1';
                  else 
                    overflow <= '0';
                  end if;
              
             when others => 
                
        end case; 
    
    end process;
    



end Behavioral;
