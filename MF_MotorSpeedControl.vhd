library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------

entity MF_MotorSpeedControl is

	port (

		-- Inputs
		clk        : in std_logic;
		rst        : in std_logic;
		sw_Dir     : in std_logic;
		btn_up     : in std_logic;
		btn_down   : in std_logic;
		sw_sel_dir : in std_logic;
		pinSA      : in std_logic;
		pinSB      : in std_logic;

		-- Outputs
		pinDir    : out std_logic;
		pinEn     : out std_logic;
		seg7_code : out std_logic_vector (7 downto 0);
		sel_disp  : out std_logic_vector (7 downto 0)

	);

end entity MF_MotorSpeedControl;

-------------------------------------------------------

architecture arc of MF_MotorSpeedControl is

	component M1_Gen_PWM is
		port (
			CLK        : in  std_logic;
			rst        : in  std_logic;
			sw_Dir     : in  std_logic;
			PWM_vector : in  std_logic_vector(7 downto 0);
			pinDir     : out std_logic;
			pinEn      : out std_logic
		);
	end component M1_Gen_PWM;

	component M2_Sel_PWM is
		port (
			clk      : in  std_logic;
			rst      : in  std_logic;
			btn_up   : in  std_logic;
			btn_down : in  std_logic;
			vec_PWM  : out std_logic_vector (7 downto 0)
		);
	end component M2_Sel_PWM;

	component M3_Visualiza is
		port(
			clk        : in  std_logic;
			rst        : in  std_logic;
			PWM_vector : in  std_logic_vector (7 downto 0);
			sw_Dir     : in  std_logic;
			sw_sel_dir : in  std_logic;
			velocidad  : in  std_logic_vector (7 downto 0);
			seg7_code  : out std_logic_vector (7 downto 0);
			sel_disp   : out std_logic_vector (7 downto 0)
		);
	end component M3_Visualiza;

	component M4_Calc_Velocidad is
		port (
			clk       : in  std_logic;
			rst       : in  std_logic;
			pinSA     : in  std_logic;
			pinSB     : in  std_logic;
			velocidad : out std_logic_vector (7 downto 0)
		);
	end component M4_Calc_Velocidad;

	component M5_Control is
		port (
			clk            : in  std_logic;
			rst            : in  std_logic;
			velocidad      : in  std_logic_vector(7 downto 0);
			PWM_vector_in  : in  std_logic_vector(7 downto 0);
			PWM_vector_out : out std_logic_vector(7 downto 0)

		);
	end component M5_Control;

	signal PWM_vector_i : std_logic_vector (7 downto 0);
	signal PWM_vector_out_i : std_logic_vector (7 downto 0);
	signal velocidad_i  : std_logic_vector (7 downto 0);

begin

	M1 : M1_Gen_PWM
		port map (

			CLK        => clk,
			rst        => rst,
			sw_Dir     => sw_Dir,
			PWM_vector => PWM_vector_out_i,
			pinDir     => pinDir,
			pinEn      => pinEn

		);

	M2 : M2_Sel_PWM
		port map (

			clk      => clk,
			rst      => rst,
			btn_up   => btn_up,
			btn_down => btn_down,
			vec_PWM  => PWM_vector_i

		);

	M3 : M3_Visualiza
		port map(
			clk        => clk,
			rst        => rst,
			PWM_vector => PWM_vector_i,
			sw_Dir     => sw_Dir,
			sw_sel_dir => sw_sel_dir,
			velocidad  => velocidad_i,
			seg7_code  => seg7_code,
			sel_disp   => sel_disp
		);

	M4 : M4_Calc_Velocidad
		port map (
			clk       => clk,
			rst       => rst,
			pinSA     => pinSA,
			pinSB     => pinSB,
			velocidad => velocidad_i
		);

	M5: M5_Control
	port map (
		clk            => clk,
		rst            => rst,
		velocidad      => velocidad_i,
		PWM_vector_in  => PWM_vector_i,
		PWM_vector_out => PWM_vector_out_i
	);

end architecture arc;
