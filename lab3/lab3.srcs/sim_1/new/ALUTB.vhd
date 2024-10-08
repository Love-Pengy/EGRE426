library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUTB is
end entity;

architecture behavior of ALUTB is
  constant TIME_DELAY : time := 20 ns;
  constant NUM_VALS : integer := 22;



  type A_array is array(0 to (NUM_VALS - 1)) of std_logic_vector(31 downto 0);
  type B_array is array(0 to (NUM_VALS - 1)) of std_logic_vector(31 downto 0);
  type C_array is array(0 to (NUM_VALS - 1)) of std_logic_vector(31 downto 0);
  type Overflow_array is array(0 to (NUM_VALS - 1)) of std_logic;
  --type Cin_array is array(0 to (NUM_VALS - 1)) of std_logic;
  type Cout_array is array(0 to (NUM_VALS - 1)) of std_logic;
  type Mode_array is array(0 to (NUM_VALS - 1)) of std_logic_vector(2 downto 0);
  type Zero_array is array(0 to (NUM_VALS - 1)) of std_logic;
  
  ------------------ ADDER -------------------
  -- Full Zeros
  -- a negative and a positive 
  -- a negative and a negative
  -- a positive and negative that sums to zero 
  -- overflows and carry 
  -- a positive and a positive 
  -- overflow only 
  -- carry only 
  --------------------------------------------
  
  ---------------- SUBTRACTOR ----------------
  -- Full Zeros
  -- a negative and a positive 
  -- a negative and a negative
  -- a positive and negative in which the difference is zero  
  -- a positive and a positive 
  -- overflow only
  -- carry only 
  --------------------------------------------
  
  --------------- Bit AND --------------------
  -- Full Zeros
  -- results in zero 
  -- normal
  --------------------------------------------
  --------------- Bit OR --------------------
  -- Full Zeros 
  -- normal
  --------------------------------------------
  --------------- Bit OR --------------------
  -- Full Zeros 
  -- normal
  -- result is 0
  --------------------------------------------
  
  constant A_vals : A_array := (
                                ------------------adder--------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000", 
                                B"1111_1111_1111_1111_1000_1000_0000_0000", 
                                B"1111_1111_1111_1111_1111_0000_0000_0000", 
                                B"1111_1111_1111_1111_1111_1111_1111_1111", 
                                B"1000_0000_0000_0000_0000_0000_0000_0000", 
                                B"0000_0000_0000_0000_0000_0000_0000_1000", 
                                B"0111_1111_1111_1111_1111_1111_1111_1111", 
                                B"1111_0000_0000_0000_0000_0000_0000_0000",
                                ------------------------------------------
                                ----------------subtractor----------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000", 
                                B"1111_1111_1111_1111_1000_1000_0000_0000", 
                                B"1111_1111_1111_1111_1111_0000_0000_0000",
                                B"1111_1111_1111_1111_1111_1111_1111_1111", 
                                B"0000_0000_0000_0000_0000_0000_0000_1000",
                                B"0111_1111_1111_1111_1111_1111_1111_1111",
                                ------------------------------------------
                                ---------------bit and--------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1111_1111_1111_1111",
                                B"0000_0000_0000_0000_1111_1111_1111_1111",
                                ------------------------------------------
                                ---------------bit or---------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1111_1111_1111_1111",
                                ----------------sll-----------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1111_1111_1111_1111",
                                B"1000_0000_0000_0000_0000_0000_0000_0000"
                                ------------------------------------------
                                );  
                                
  constant B_vals : B_array := (
                                ------------------adder--------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0001_0001_0000", 
                                B"1111_1111_1111_1111_1000_0101_0000_0000", 
                                B"0000_0000_0000_0000_0000_0000_0000_0001", 
                                B"1000_0000_0000_0000_0000_0000_0000_0001",
                                B"0000_0000_0000_0000_0000_0000_0000_0010",
                                B"0000_0000_0000_0000_0000_0000_0000_0001", 
                                B"1111_0000_0000_0000_0000_0000_0000_0000",
                                -------------------------------------------
                                ----------------subtractor----------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0001_0001_0000",
                                B"0000_0000_0000_0000_1000_0101_0000_0000",
                                B"1111_1111_1111_1111_1111_1111_1111_1111",
                                B"1111_1111_1111_1111_1111_1111_1111_0110",
                                B"1111_1111_1111_1111_1111_1111_1111_1111",
                                ------------------------------------------
                                ----------------bit and-------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1111_0000_0000_0000",
                                ------------------------------------------
                                ----------------bit or--------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0101_0101_0101_0101_0101_0101_0101_0101",
                                -----------------sll----------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0000_0000_0100",
                                B"0000_0000_0000_0000_0000_0000_0000_1000"
                                ------------------------------------------
                                );
  
  constant C_vals : C_array := (
                                ------------------adder--------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1000_1001_0001_0000", 
                                B"1111_1111_1111_1111_0111_0101_0000_0000", 
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0000_0000_0001", 
                                B"0000_0000_0000_0000_0000_0000_0000_1010", 
                                B"1000_0000_0000_0000_0000_0000_0000_0000", 
                                B"1110_0000_0000_0000_0000_0000_0000_0000",
                                ------------------------------------------
                                ----------------subtractor----------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1000_0110_1111_0000",
                                B"1111_1111_1111_1111_0110_1011_0000_0000",
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0000_0001_0010",
                                B"1000_0000_0000_0000_0000_0000_0000_0000",
                                ---------------bit and--------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_1111_0000_0000_0000",
                                ---------------bit or--------------------- 
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1111_1111_1111_1111",
                                -----------------sll----------------------
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1111_1111_1111_0000",
                                B"0000_0000_0000_0000_0000_0000_0000_0000"
                                );
  
  constant Zero_vals : Zero_array := (
                                     --adder--
                                       '1', 
                                       '0',
                                       '0',
                                       '1',
                                       '0',
                                       '0',
                                       '0',
                                       '0',
                                     --------
                                  --subtractor--
                                       '1',
                                       '0',
                                       '0',
                                       '1',
                                       '0',
                                       '0',
                                   -----------
                                   --bit and--
                                       '1',
                                       '1',
                                       '0',
                                   --bit or--
                                       '1',
                                       '0',
                                   ----------
                                   ----sll---
                                       '1',
                                       '0',
                                       '1'
                                      );
  constant Overflow_vals : Overflow_array := (
                                              --adder--
                                                '0', 
                                                '0', 
                                                '0', 
                                                '0', 
                                                '1', 
                                                '0', 
                                                '1', 
                                                '0',
                                              -------
                                           --subtractor--
                                                '0', 
                                                '0', 
                                                '0',
                                                '0',
                                                '0',
                                                '1',
                                            -----------
                                            --bit and--
                                                '0',
                                                '0',
                                                '0',
                                            --bit or--
                                                '0',
                                                '0',
                                            ----------
                                            ----sll---
                                                '0',
                                                '0',
                                                '0' 
                                             );
  
  constant Cout_vals : Cout_array := (
                                       --adder--
                                         '0',
                                         '0',
                                         '1', 
                                         '1', 
                                         '1', 
                                         '0', 
                                         '0', 
                                         '1',
                                       -------
                                    --subtractor--
                                         '0', 
                                         '1',
                                         '1',
                                         '1',
                                         '0',
                                         '0',
                                    --------------
                                     --bit and--
                                        '0',
                                        '0',
                                        '0',
                                     --bit or--
                                        '0',
                                        '0',
                                     ----------
                                     ---sll---
                                        '0',
                                        '0',
                                        '0'
                                       );
                        

  constant Mode_vals : Mode_array := (
                                        --adder--
                                           "000", 
                                           "000", 
                                           "000",
                                           "000",
                                           "000",
                                           "000",
                                           "000", 
                                           "000",
                                           -----
                                         --subtractor--
                                            "001", 
                                            "001", 
                                            "001", 
                                            "001", 
                                            "001", 
                                            "001",
                                            ------
                                          --bit and--
                                            "010",
                                            "010",
                                            "010",
                                          --bit or--
                                            "011",
                                            "011",
                                           -------
                                           ---sll---
                                            "100",
                                            "100",
                                            "100"
                                           );
                                            
  signal Zero_sig : std_logic;           
  signal A_sig : std_logic_vector(31 downto 0);
  signal B_sig : std_logic_vector(31 downto 0);
  signal C_sig : std_logic_vector(31 downto 0);
  signal Overflow_sig : std_logic;
  signal Cout_sig : std_logic;
  --signal Cin_sig : std_logic;
  signal Mode_sig : std_logic_vector(2 downto 0);
  signal twoOutput_sig : std_logic_vector(31 downto 0);
begin

  DUT : entity work.ALU(behavioral)
    port map(A => A_sig,
             B => B_sig,
             C => C_sig,
             Mode => Mode_sig,
             Overflow => Overflow_sig, 
             --Cin => Cin_sig
             Zero => Zero_sig,
             Cout => Cout_sig);    

  stimulus : process
  begin
    for i in 0 to (NUM_VALS - 1) loop
      A_sig <= A_vals(i);
      B_sig <= B_vals(i);
      --Cin_sig <= Cin_vals(i);
      Mode_sig <= Mode_vals(i);
      wait for TIME_DELAY;
    end loop;
    wait;
  end process stimulus;

  monitor : process
    variable i : integer := 0;
  begin
    wait for TIME_DELAY/4;
    while (i < NUM_VALS) loop
      wait for TIME_DELAY/2;
      assert C_sig = C_vals(i)
        report "C value is incorrect." 
        severity error;

      assert Overflow_sig = Overflow_vals(i)
        report "Overflow value is incorrect"
        severity error;

      assert Cout_sig = Cout_vals(i)
        report "Cout value is incorrect."
        severity error;
      
      assert Zero_sig = Zero_vals(i)
        report "Zero value is incorrect."
        severity error;
        
      i := i + 1;
      wait for TIME_DELAY/2;
    end loop;
    wait;
  end process monitor;

end behavior;
