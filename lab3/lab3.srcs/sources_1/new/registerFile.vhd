----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/10/2024 07:44:35 PM
-- Design Name: 
-- Module Name: registerFile - Behavioral
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
use ieee.numeric_std.ALL;

entity registerFile is
  Port (Rw, Ra, Rb: in std_logic_vector(4 downto 0);
        RegWr,Clk: in std_logic;
        busW: in std_logic_vector(31 downto 0);
        busA, busB: out std_logic_vector(31 downto 0)
        );
end registerFile;

architecture Behavioral of registerFile is
type register_array is array (0 to 31) of std_logic_vector(31 downto 0);
signal registerVals : register_array := (others => (others => '0'));
begin
    process(clk)
    begin
        busA <= X"000000000";
        busB <= X"000000000";
        if(rising_edge(clk)) then 
            case RegWr is
                when '0' => 
                    busA <= registerVals(to_integer(unsigned(Ra))); 
                    busB <= registerVals(to_integer(unsigned(Rb)));
                when '1' => 
                    registerVals(to_integer(unsigned(Rw))) <= busW;
            end case;
        end if;
    end process;
end Behavioral;
