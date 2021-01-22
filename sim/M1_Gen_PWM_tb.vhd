library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------

entity M1_Gen_PWM_tb is

end entity M1_Gen_PWM_tb;

-----------------------------------------------------------

architecture testbench of M1_Gen_PWM_tb is

	-- Testbench DUT ports
	signal CLK        : std_logic := '1';
	signal rst        : std_logic;
	signal sw_Dir     : std_logic;
	signal PWM_vector : std_logic_vector(7 downto 0);
	signal pinDir     : std_logic;
	signal pinEn      : std_logic;

	-- Other constants
	constant TCLK : time := 10ns;

begin

	DUT : entity work.M1_Gen_PWM
		port map (
			CLK        => CLK,
			rst        => rst,
			sw_Dir     => sw_Dir,
			PWM_vector => PWM_vector,
			pinDir     => pinDir,
			pinEn      => pinEn
		);

	CLK <= not CLK after TCLK/2;

	process
	begin

		rst        <= '0';
		sw_Dir     <= '0';
		PWM_vector <= "00111100";
		wait for 100 ns;

		rst <= '1';
		wait for 10 ms;
		
		PWM_vector <= "01010000";
		wait for 40 ms;
		
		sw_Dir <= '1';
		wait for 40 ms;
		
		sw_Dir <= '0';
		wait for 40ms;
		
		wait;

	end process;

end architecture testbench;