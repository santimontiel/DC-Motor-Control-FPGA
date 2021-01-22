library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------

entity M3_Visualiza_tb is

end entity M3_Visualiza_tb;

-----------------------------------------------------------

architecture testbench of M3_Visualiza_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk        : std_logic := '0';
	signal rst        : std_logic;
	signal PWM_vector : std_logic_vector (15 downto 0);
	signal sw_Dir     : std_logic;
	signal sw_sel_dir : std_logic;
	signal velocidad  : std_logic_vector (11 downto 0);
	signal seg7_code  : std_logic_vector (7 downto 0);
	signal sel_disp   : std_logic_vector (7 downto 0);

	-- Other constants
	constant TCLK : time := 10ns;

begin

	DUT : entity work.M3_Visualiza
		port map (
			clk        => clk,
			rst        => rst,
			PWM_vector => PWM_vector,
			sw_Dir     => sw_Dir,
			sw_sel_dir => sw_sel_dir,
			velocidad  => velocidad,
			seg7_code  => seg7_code,
			sel_disp   => sel_disp
		);
		
	clk <= not(clk) after TCLK/2;
	
	process
	begin
	   
	   rst <= '0';
	   sw_Dir <= '0';
	   sw_sel_dir <= '0';
	   PWM_vector <= "0000000000111100";
	   velocidad  <= "000001010000";
	   wait for 100 ns;
	   
	   rst <= '1';
	   wait for 2000ms;
	   
	   sw_sel_dir <= '1';
	   wait for 2000ms;
	   
	   sw_sel_dir <= '0';
	   sw_Dir <= '1';
	   wait for 1000ms;
	
	   wait;
	
	end process;

end architecture testbench;