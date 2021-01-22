library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------

entity M321_VisualizaGenSel_PWM_tb is

end entity M321_VisualizaGenSel_PWM_tb;

-----------------------------------------------------------

architecture testbench of M321_VisualizaGenSel_PWM_tb is

	-- Testbench DUT ports
	signal clk        : std_logic :='0';
	signal rst        : std_logic;
	signal sw_Dir     : std_logic;
	signal btn_up     : std_logic;
	signal btn_down   : std_logic;
	signal sw_sel_dir : std_logic;
	signal velocidad  : std_logic_vector (11 downto 0);
	signal pinDir     : std_logic;
	signal pinEn      : std_logic;
	signal seg7_code  : std_logic_vector (7 downto 0);
	signal sel_disp   : std_logic_vector (7 downto 0);

	-- Other constants
	constant TCLK : time := 10ns;

begin

	DUT : entity work.M321_VisualizaGenSel_PWM
		port map (
			clk        => clk,
			rst        => rst,
			sw_Dir     => sw_Dir,
			btn_up     => btn_up,
			btn_down   => btn_down,
			sw_sel_dir => sw_sel_dir,
			velocidad  => velocidad,
			pinDir     => pinDir,
			pinEn      => pinEn,
			seg7_code  => seg7_code,
			sel_disp   => sel_disp
		);

	clk <= not(clk) after TCLK/2;

	process
	begin
		
		rst        <= '0';
		sw_Dir     <= '0';
		btn_up	   <= '0';
		btn_down   <= '0';
		sw_sel_dir <= '0';
		velocidad  <= "000000000000";
		wait for 100 ns;

		rst <= '1';
		wait for 100 ns;

		wait for 30 ms;

--		btn_up <= '1';
--		wait for 80 ms;

--		btn_up <= '0';
--		wait for 30 ms;

--		btn_up <= '1';
--		wait for 30 ms;

--		btn_up <= '0';
--		wait for 30 ms;

--		sw_Dir <= '1';
--		wait for 40 ms;
		
--		sw_Dir <= '0';
--		wait for 40ms;

--		velocidad <= "000000110010"; --50
--		wait for 30ms;

--		sw_sel_dir <= '1';  --selecciona velocidad
--		wait for 30ms;

--		sw_sel_dir <= '0';  --selecciona PWM_vector
--		wait for 30ms;

--		velocidad <= "000000011001";  --25
--		wait for 30ms;		

--		sw_sel_dir <= '1';  --selecciona velocidad
--		wait for 30ms;
		
		velocidad  <= "000000110011";
		
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