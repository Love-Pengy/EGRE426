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
    -- add Rd, Rs, Rt
    port(Rd, Rt, Rs: in std_logic_vector(0 to 4);
         -- value that specifies if ALU is ready for writing
         RegWr: in bit;
         -- clock
         clk: in bit;
         -- result from ALU
         busW: in std_logic_vector(31 downto 0);
         -- out 1
         busA: out std_logic_vector(31 downto 0);
         -- out 2
         busB: out std_logic_vector(31 downto 0);
         -- Register 
         registers: std_logic_vector(31 downto 0);
        
         ALUctr: in std_logic_vector(2 downto 0);
        Zero: out std_logic;
        Overflow: out std_logic;
        Carryout: out std_logic;
        Result: out std_logic_vector(31 downto 0));
end ALU;

architecture Behavioral of ALU is
begin
    fullAdder : for i in 31 downto 0 generate
        addArray : entity work.adder(simple)
            port map (s1(i), s2(i), s3(i));
    end generate fulladder;
    
-- 000 Addition 
-- 001 Subtraction
-- 010 Bitwise AND
-- 011 Bitwise OR
-- 100 Logical left shift
-- 101 Logical right shift
-- 110 arithmetic left shift
-- 111 arithmetic right shift


process(RegWr, Rd, Rs, Rt, Clk, ALUctr, busW)
variable overflowCheck : std_logic_vector(32 downto 0);
variable carry : std_logic_vector;
begin
if(ALUctr = B"000") then
    
end

end process;



end Behavioral;
