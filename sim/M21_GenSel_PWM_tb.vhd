library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------

entity M21_GenSel_PWM_tb is

end entity M21_GenSel_PWM_tb;

-----------------------------------------------------------

architecture testbench of M21_GenSel_PWM_tb is

	-- Testbench DUT ports
	signal clk      : std_logic := '1';
	signal rst      : std_logic;
	signal sw_Dir   : std_logic;
	signal btn_up   : std_logic;
	signal btn_down : std_logic;
	signal pinDir   : std_logic;
	signal pinEn    : std_logic;

	-- Other constants
	constant TCLK : time := 10ns;

begin
	
	DUT : entity work.M21_GenSel_PWM
		port map (
			clk      => clk,
			rst      => rst,
			sw_Dir   => sw_Dir,
			btn_up   => btn_up,
			btn_down => btn_down,
			pinDir   => pinDir,
			pinEn    => pinEn
		);

    clk <= not(clk) after TCLK/2;

	process
	begin

		rst        <= '0';
		sw_Dir     <= '0';
		btn_up	   <= '0';
		btn_down   <= '0';
		wait for 100 ns;

		rst <= '1';
		wait for 100 ns;

		wait for 30 ms;

		btn_up <= '1';
		wait for 80 ms;

		btn_up <= '0';
		wait for 30 ms;

		btn_up <= '1';
		wait for 80 ms;

		btn_up <= '0';
		wait for 30 ms;

		btn_up <= '1';
		wait for 80 ms;

		btn_up <= '0';
		wait for 30 ms;

		btn_up <= '1';
		wait for 80 ms;

		btn_up <= '0';
		wait for 30 ms;

		btn_up <= '1';
		wait for 80 ms;

		btn_up <= '0';
		wait for 30 ms;

		btn_up <= '1';
		wait for 80 ms;

		btn_up <= '0';
		wait for 30 ms;

		sw_Dir <= '1';
		wait for 40 ms;
		
		sw_Dir <= '0';
		wait for 40ms;

		wait;

	end process;

end architecture testbench;