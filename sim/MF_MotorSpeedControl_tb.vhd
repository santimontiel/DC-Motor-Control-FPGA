library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-----------------------------------------------------------

entity MF_MotorSpeedControl_tb is

end entity MF_MotorSpeedControl_tb;

-----------------------------------------------------------

architecture testbench of MF_MotorSpeedControl_tb is

	-- Testbench DUT ports
	signal clk        : std_logic := '0';
	signal rst        : std_logic;
	signal sw_Dir     : std_logic;
	signal btn_up     : std_logic;
	signal btn_down   : std_logic;
	signal sw_sel_dir : std_logic;
	signal pinSA      : std_logic :='0';
	signal pinSB      : std_logic;
	signal pinDir     : std_logic;
	signal pinEn      : std_logic;
	signal seg7_code  : std_logic_vector (7 downto 0);
	signal sel_disp   : std_logic_vector (7 downto 0);

	constant TCLK : time := 10ns;
	constant TPSA : time := 100ms;

begin

	DUT : entity work.MF_MotorSpeedControl
		port map (
			clk        => clk,
			rst        => rst,
			sw_Dir     => sw_Dir,
			btn_up     => btn_up,
			btn_down   => btn_down,
			sw_sel_dir => sw_sel_dir,
			pinSA      => pinSA,
			pinSB      => pinSB,
			pinDir     => pinDir,
			pinEn      => pinEn,
			seg7_code  => seg7_code,
			sel_disp   => sel_disp
		);

	clk   <= not(clk) after TCLK/2;
	pinSA <= not(pinSA) after TPSA/2;

	process
	begin
		rst        <= '0';
		sw_Dir     <= '0';
		btn_up     <= '0';
		btn_down   <= '0';
		sw_sel_dir <= '0';
		pinSB      <= '0';
		wait for 100 ns;

		rst <= '1';
		wait for 100 ns;

		btn_up <= '1';
        wait for 40 ms;
        
        btn_up <= '0';
        wait for 40 ms;
        
        btn_up <= '1';
        wait for 40 ms;
        
        btn_up <= '0';
        wait for 40 ms;
        
        btn_up <= '1';
        wait for 40 ms;
        
        btn_up <= '0';
        wait for 40 ms;
        
        btn_up <= '1';
        wait for 40 ms;
        
        btn_up <= '0';
        wait for 40 ms;
        
        btn_up <= '1';
        wait for 40 ms;
        
        btn_up <= '0';
        wait for 40 ms;
        
        btn_up <= '1';
        wait for 40 ms;
        
        btn_up <= '0';
        wait for 60 ms;
        
        wait for 250ms;
        
        sw_sel_dir <='1';
        wait for 500ms;

		wait;

	end process;
end architecture testbench;