----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Brandon Frazier
-- 
-- Create Date: 10/07/2024 01:19:46 PM
-- Design Name: 
-- Module Name: nBitAdder - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;


entity nBitAdder is
  generic(N : integer := 32);
  PORT(
    A, B: in std_logic_vector(N-1 downto 0);
    C: out std_logic_vector(N-1 downto 0);
    Cout, Overflow: out std_logic;
    Cin : in std_logic
  );
end nBitAdder;

architecture Behavioral of nBitAdder is

  COMPONENT oneBitAdder           
    PORT (                        
      A, B, Cin: in std_logic;    
      Cout, C: out std_logic);    
  end COMPONENT;   
  signal carry,cAns : std_logic_vector(N-1 downto 0) := (others => '0');        
  
begin
  zeroBitAdder: oneBitAdder
    -- Cin to 1 for 2's 
    PORT MAP( A => A(0), B => B(0), Cin => Cin, Cout => carry(0), C => cAns(0));
    
 GEN1: for i in 1 to N-1 generate
   iAdder: oneBitAdder
     PORT MAP(A => A(i), B => B(i), Cin => carry(i-1), Cout => carry(i), C => cAns(i));
 end generate GEN1;
 Cout <= carry(N-1);
 
 process(A, B, Cin, cAns)
 begin
  if(((A(31) AND B(31)) AND (NOT cAns(31))) = '1') then 
    Overflow <= '1';
  elsif(((NOT A(31) AND (NOT B(31))) AND cAns(31)) = '1') then 
    Overflow <= '1'; 
  else
    Overflow <= '0';
  end if;
  C <= cAns;
 end process;
 
end Behavioral;
