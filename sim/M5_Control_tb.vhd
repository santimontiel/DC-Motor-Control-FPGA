library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------

entity M5_Control_tb is

end entity M5_Control_tb;

-----------------------------------------------------------

architecture testbench of M5_Control_tb is

	-- Testbench DUT ports
	signal PWM_vector_in : std_logic_vector (7 downto 0);
	signal PWM_vector_out : std_logic_vector (7 downto 0);
	signal clk        : std_logic := '1';
	signal rst        : std_logic;
	signal velocidad  : std_logic_vector (7 downto 0);

	-- Other constants
	constant TCLK : time := 10ns;

begin

	DUT : entity work.M5_Control
		port map (
			PWM_vector_in => PWM_vector_in,
			PWM_vector_out => PWM_vector_out,
			clk        => clk,
			rst        => rst,
			velocidad  => velocidad
		);


	clk <= not(clk) after TCLK/2;

	process
	begin

		rst <= '0';
		PWM_vector_in <= "00000000";
		velocidad <= "00000000";
		wait for 100 ns;

		rst <= '1';
		PWM_vector_in <= "00111100";
		velocidad <= "00110010";
		wait for 300 ms;

		wait;

	end process;

end architecture testbench;