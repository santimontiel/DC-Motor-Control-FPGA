library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------

entity M2_Sel_PWM_tb is

end entity M2_Sel_PWM_tb;

-----------------------------------------------------------

architecture testbench of M2_Sel_PWM_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk      : std_logic := '0';
	signal rst      : std_logic;
	signal btn_up   : std_logic;
	signal btn_down : std_logic;
	signal vec_PWM  : std_logic_vector (7 downto 0);

	-- Other constants
	constant TCLK : time := 10ns;

begin

	DUT : entity work.M2_Sel_PWM
		port map (
			clk      => clk,
			rst      => rst,
			btn_up   => btn_up,
			btn_down => btn_down,
			vec_PWM  => vec_PWM
		);

	clk <= not(clk) after TCLK/2;

	process
	begin

		rst <= '0';
		btn_up <= '0';
		btn_down <= '0';
		wait for 100 ns;

		rst <= '1';
		wait for 100 ns;

		btn_up <= '1';
		wait for 120 ms;

		btn_up <= '0';
		wait for 50 ms;
		
		btn_up <= '1';
        wait for 120 ms;
        
        btn_up <= '0';
        wait for 50 ms;
        
        btn_up <= '1';
        wait for 120 ms;
                
        btn_up <= '0';
        wait for 50 ms;

		btn_down <= '1';
		wait for 120 ms;

		btn_down <= '1';
		wait for 50 ms;
		wait;

	end process;

end architecture testbench;