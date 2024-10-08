library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nBitAdderTB is
end entity;

architecture behavior of nBitAdderTB is
  constant TIME_DELAY : time := 20 ns;
  constant NUM_VALS : integer := 8;



  type A_array is array(0 to (NUM_VALS - 1)) of std_logic_vector(31 downto 0);
  type B_array is array(0 to (NUM_VALS - 1)) of std_logic_vector(31 downto 0);
  type C_array is array(0 to (NUM_VALS - 1)) of std_logic_vector(31 downto 0);
  type Overflow_array is array(0 to (NUM_VALS - 1)) of std_logic;
  type Cin_array is array(0 to (NUM_VALS - 1)) of std_logic;
  type Cout_array is array(0 to (NUM_VALS - 1)) of std_logic;
  
  -- Expected input and output data.
  -- You need to correct and add more values here based on your design
  -- TODO: test the following cases (make 10 test cases total): 
  -- Full Zeros
  -- a negative and a positive 
  -- a negative and a negative
  -- a positive and negative that sums to zero 
  -- overflows and carry 
  -- a positive and a positive 
  -- overflow only 
  -- carry only 
  
  constant A_vals : A_array := (B"0000_0000_0000_0000_0000_0000_0000_0000", 
                                B"1111_1111_1111_1111_1000_1000_0000_0000", 
                                B"1111_1111_1111_1111_1111_0000_0000_0000", 
                                B"1111_1111_1111_1111_1111_1111_1111_1111", 
                                B"1000_0000_0000_0000_0000_0000_0000_0000", 
                                B"0000_0000_0000_0000_0000_0000_0000_1000", 
                                B"0111_1111_1111_1111_1111_1111_1111_1111", 
                                B"1111_0000_0000_0000_0000_0000_0000_0000");  
                                
  constant B_vals : B_array := (B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0001_0001_0000", 
                                B"1111_1111_1111_1111_1000_0101_0000_0000", 
                                B"0000_0000_0000_0000_0000_0000_0000_0001", 
                                B"1000_0000_0000_0000_0000_0000_0000_0001",
                                B"0000_0000_0000_0000_0000_0000_0000_0010",
                                B"0000_0000_0000_0000_0000_0000_0000_0001", 
                                B"1111_0000_0000_0000_0000_0000_0000_0000");
  
  constant C_vals : C_array := (B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"1111_1111_1111_1111_1000_1001_0001_0000", 
                                B"1111_1111_1111_1111_0111_0101_0000_0000", 
                                B"0000_0000_0000_0000_0000_0000_0000_0000",
                                B"0000_0000_0000_0000_0000_0000_0000_0001", 
                                B"0000_0000_0000_0000_0000_0000_0000_1010", 
                                B"1000_0000_0000_0000_0000_0000_0000_0000", 
                                B"1110_0000_0000_0000_0000_0000_0000_0000");
                              
  constant Overflow_vals : Overflow_array := ('0', '0', '0', '0', '1', '0', '1', '0');
  
  constant Cout_vals : Cout_array := ('0','0','1', '1', '1', '0', '0', '1');
  
  constant Cin_vals : Cout_array := ('0','0','0', '0', '0', '0', '0', '0');
                        

  signal A_sig : std_logic_vector(31 downto 0);
  signal B_sig : std_logic_vector(31 downto 0);
  signal C_sig : std_logic_vector(31 downto 0);
  signal Overflow_sig : std_logic;
  signal Cout_sig : std_logic;
  signal Cin_sig : std_logic;
  
begin

  DUT : entity work.nBitAdder(behavioral)
    port map(A => A_sig,
             B => B_sig,
             C => C_sig,
             Overflow => Overflow_sig, 
             Cin => Cin_sig,
             Cout => Cout_sig);    

  stimulus : process
  begin
    for i in 0 to (NUM_VALS - 1) loop
      A_sig <= A_vals(i);
      B_sig <= B_vals(i);
      Cin_sig <= Cin_vals(i);
      wait for TIME_DELAY;
    end loop;
    wait;
  end process stimulus;

  monitor : process
    variable i : integer := 0;
  begin
    wait for TIME_DELAY/4;
    while (i < NUM_VALS) loop
      assert C_sig = C_vals(i)
        report "C value is incorrect."
        severity error;

      assert Overflow_sig = Overflow_vals(i)
        report "Overflow value is incorrect"
        severity error;

      wait for TIME_DELAY/2;

      assert Cout_sig = Cout_vals(i)
        report "Cout value is incorrect."
        severity error;

      i := i + 1;
      wait for TIME_DELAY/2;
    end loop;
    wait;
  end process monitor;

end behavior;
