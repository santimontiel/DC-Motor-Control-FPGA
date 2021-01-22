library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------

entity M321_VisualizaGenSel_PWM is
    port (


		clk        : in std_logic;
		rst        : in std_logic;
		sw_Dir     : in std_logic;
		btn_up     : in std_logic;
		btn_down   : in std_logic;
        sw_sel_dir : in std_logic;
        velocidad  : in std_logic_vector (11 downto 0);

		pinDir : out std_logic;
        pinEn  : out std_logic;
        seg7_code : out std_logic_vector (7 downto 0); 
        sel_disp  : out std_logic_vector (7 downto 0)  

    );
    
end entity M321_VisualizaGenSel_PWM;

architecture rtl of M321_VisualizaGenSel_PWM is

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
		clk        : in std_logic;                      
		rst        : in std_logic;                      
		PWM_vector : in std_logic_vector (7 downto 0); 
		sw_Dir     : in std_logic;                      
		sw_sel_dir : in std_logic;                      										
		velocidad  : in std_logic_vector (11 downto 0);
		seg7_code  : out std_logic_vector (7 downto 0); 
        sel_disp   : out std_logic_vector (7 downto 0)  
        );
    end component M3_Visualiza;

    signal PWM_vector_i : std_logic_vector (7 downto 0);
    
    begin 
        M1 : M1_Gen_PWM
            port map (

                CLK        => clk,
                rst        => rst,
                sw_Dir     => sw_Dir,
                PWM_vector => PWM_vector_i,
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
                velocidad  => velocidad,
                seg7_code  => seg7_code,
                sel_disp   => sel_disp 



            );

    end architecture rtl;