----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-----------------------------------------------------------

entity M4_Calc_Velocidad_tb is

end entity M4_Calc_Velocidad_tb;

-----------------------------------------------------------

architecture testbench of M4_Calc_Velocidad_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk       : std_logic := '1';
	signal rst       : std_logic;
	signal pinSA     : std_logic := '0';
	signal pinSB     : std_logic;
	signal velocidad : std_logic_vector (7 downto 0);

	-- Other constants
	constant TCLK : time := 10ns;
	constant TPSA : time := 100ms;

begin
	
	DUT : entity work.M4_Calc_Velocidad
		port map (
			clk       => clk,
			rst       => rst,
			pinSA     => pinSA,
			pinSB     => pinSB,
			velocidad => velocidad
		);
		
    clk <= not(clk) after TCLK/2;
    pinSA <= not(pinSA) after TPSA/2;
    
    process
    begin
    
    rst <= '0';
    pinSB <= '0';
    wait for 100 ns;
    
    rst <= '1';
    wait for 1000 ms;
    
    wait;
    
    
    end process;


end architecture testbench;