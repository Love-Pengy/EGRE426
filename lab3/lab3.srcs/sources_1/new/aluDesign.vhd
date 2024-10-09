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
use ieee.numeric_std.ALL;
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

    signal addOutput, twoOutput, shiftOutput, subOutput, bitOutput, shiftIndex: std_logic_vector(31 downto 0);
    signal addCout, addOverflow, twoCout, twoOverflow, subCout, subOverflow: std_logic := '0';
    COMPONENT nBitAdder
        PORT (
            A, B: in std_logic_vector(31 downto 0);
            Cin: in std_logic;
            Cout, Overflow: out std_logic;
            C: out std_logic_vector(31 downto 0));
    END COMPONENT;
    
    
    begin
    
    adder: nBitAdder
      PORT MAP(A => A, B => B, Cin => '0', C => addOutput, Overflow => addOverflow, Cout => addCout);
      
    subtractor: nBitAdder
      PORT MAP(A => A, B => twoOutput, Cin => '0', C => subOutput, Overflow => subOverflow, Cout => subCout);
      
    -- open (https://stackoverflow.com/questions/19412165/how-to-ignore-output-ports-with-port-maps)
    twoCompliment: nBitAdder
      PORT MAP(A => X"00000001", B => (NOT B), Cin => '0', C => twoOutput, Overflow => open, Cout => open);
    
    shiftCalc: nBitAdder
      PORT MAP(A => X"0000001F", B => twoOutput, Cin => '0', C => shiftIndex, Overflow => open, Cout => open);
      
    process(A, B, Mode,addOverflow,addOutput,subOverflow,subCout,subOutput, bitOutput)
        variable sTmp, curHold: std_logic := '0';
        begin
        case Mode is
            when "000" =>
              C <= addOutput;
              if(addOutput = B"0000_0000_0000_0000_0000_0000_0000_0000") then
                Zero <= '1';
              else 
                Zero <= '0';
              end if;
              Cout <= addCout;
              Overflow <= addOverflow;
            when "001" => 
              C <= subOutput;
              if(subOutput = B"0000_0000_0000_0000_0000_0000_0000_0000") then
                Zero <= '1';
              else 
                Zero <= '0';
              end if;
              Cout <= subCout;
              Overflow <= subOverflow;
            when "010" => 
                bitOutput <= A AND B;
                if(bitOutput = B"0000_0000_0000_0000_0000_0000_0000_0000") then 
                    Zero <= '1';
                else 
                    Zero <= '0';
                end if;
                C <= bitOutput;
                Overflow <= '0';
                Cout <= '0';
            when "011" =>
                bitOutput <= A OR B;
                if(bitOutput = B"0000_0000_0000_0000_0000_0000_0000_0000") then 
                    Zero <= '1';
                else 
                    Zero <= '0';
                end if;
                C <= bitOutput;
                Overflow <= '0';
                Cout <= '0';
            when "100" =>
              shiftOutput <= A;
              for i in 0 to to_integer(unsigned(B)) LOOP
                curHold := '0';
                sTmp := '0';
                for j in 0 to 31 LOOP
                    if(j >= i) then
                        curHold := A(j);
                        shiftOutput(j) <= sTmp;
                        sTmp := curHold XOR '0';
                    end if;
                end LOOP;
              end LOOP;
              C <= shiftOutput;
              if(shiftOutput = B"0000_0000_0000_0000_0000_0000_0000_0000") then 
                Zero <= '1';
              else 
                Zero <= '0';
              end if;
              Cout <= '0';
              Overflow <= '0';
              
              
            when others => 
                
        end case; 
    
    end process;
    



end Behavioral;
