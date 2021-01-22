library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------
entity M4_Calc_Velocidad is

	port (

		-- Inputs
		clk   : in std_logic; -- Reloj de 100 MHz
		rst   : in std_logic; -- Reset del sistemas (nivel bajo)
		pinSA : in std_logic; -- Entrada sensor A del encoder (PMOD)
		pinSB : in std_logic; -- Entrada sensor B del encoder (PMOD)

		-- Outputs
		velocidad : out std_logic_vector (7 downto 0) -- Velocidad del motor en rpm (máx. 100)

	);

end entity M4_Calc_Velocidad;
-------------------------------------------------
architecture rtl of M4_Calc_Velocidad is

	-- Señales para reloj de 250 ms
	signal cnt_1ms          : unsigned (16 downto 0);
	constant fin_cnt_1ms    : integer := 99999;
	signal acum_250ms       : unsigned (7 downto 0);
	constant fin_acum_250ms : integer := 250;

	-- Señales para lectura de pulsos en los encoders
	signal cnt_pulse : unsigned (31 downto 0);
	signal pinSA_reg1 : std_logic;
	signal pinSA_reg2 : std_logic;
	signal pinSA_reg3 : std_logic;
	signal pinSA_reg4 : std_logic;
	signal pinSA_reg5 : std_logic;
	signal flg_pulse  : std_logic;

	-- Variables para cálculo de velocidades
	signal vel_aux : unsigned (31 downto 0);
	--signal vel_ext_sd : unsigned (15 downto 0);
	--signal vel_ext : unsigned (7 downto 0);
	
	--Se�al para calcular la 

begin

	process (clk, rst)
	begin

		if (rst = '0') then

			-- Init -> Reloj de 250 ms
			cnt_1ms    <= (others => '0');
			acum_250ms <= (others => '0');

			-- Init -> Pulsos en los encoders
			cnt_pulse <= (others => '0');
			pinSA_reg1 <= '0';
			pinSA_reg2 <= '0';
			pinSA_reg3 <= '0';
			pinSA_reg4 <= '0';
			pinSA_reg5 <= '0';

			-- Init -> Velocidad
			vel_aux <= (others => '0');

		elsif (clk = '1' and clk'event) then

			-- Reloj de 250 ms
			cnt_1ms <= cnt_1ms + 1;
			
			-- Registro de pinSA
			--pinSA_reg1 <= pinSA;
			
			if (pinSA = '0') then
			     flg_pulse <= '0';
			end if;
			
			if (pinSA_reg1 = '1' and pinSA_reg2 = '1' and pinSA_reg3 = '1' and pinSA_reg4 = '1' and pinSA_reg5 = '1' and pinSA = '1' and flg_pulse = '0') then
			     cnt_pulse <= cnt_pulse + 1;
			     flg_pulse <= '1';
			elsif (pinSA_reg1 = '1' and pinSA_reg2 = '1' and pinSA_reg3 = '1' and pinSA_reg4 = '1' and pinSA = '1' and flg_pulse = '0') then
			     pinSA_reg5 <= '1';
			elsif (pinSA_reg1 = '1' and pinSA_reg2 = '1' and pinSA_reg3 = '1' and pinSA = '1' and flg_pulse = '0') then
			     pinSA_reg4 <= '1';
			elsif (pinSA_reg1 = '1' and pinSA_reg2 = '1' and pinSA = '1' and flg_pulse = '0') then
			     pinSA_reg3 <= '1';
			elsif (pinSA_reg1 = '1' and pinSA = '1' and flg_pulse = '0') then
			     pinSA_reg2 <= '1';
			elsif (pinSA = '1' and flg_pulse = '0') then
			     pinSA_reg1 <= '1';
			else
			     pinSA_reg1 <= '0';
                 pinSA_reg2 <= '0';
                 pinSA_reg3 <= '0';
                 pinSA_reg4 <= '0';
                 pinSA_reg5 <= '0';
			end if;

			if (acum_250ms = fin_acum_250ms) then

				acum_250ms <= (others => '0');
				cnt_1ms    <= (others => '0');

				-- Reset del contador de pulsos
				cnt_pulse <= (others => '0');

			elsif (cnt_1ms = fin_cnt_1ms) then

				acum_250ms <= acum_250ms + 1;
				cnt_1ms    <= (others => '0');

			end if;

			-- Conteo de pulsos en los encoders
			--if (pinSA = not(pinSA_reg)) and (pinSA = '1') then
            --
			--	cnt_pulse <= cnt_pulse + 1;
            --
			--end if;
		
		    -- C�lculo de velocidad (jujinha)
			if (acum_250ms = fin_acum_250ms - 1) then
			
			    if (cnt_1ms = fin_cnt_1ms - 4) then
			         -- multiplico los pulsos contados durante los 250 ms por 20
			         vel_aux <= cnt_pulse;
			    elsif (cnt_1ms = fin_cnt_1ms - 3) then
			         -- multiplico la velocidad del eje interno por 3 para pasar al eje externo (falta dividir por 2)
			         vel_aux <= shift_left(vel_aux, 1) + vel_aux;
			    elsif (cnt_1ms = fin_cnt_1ms - 2) then
			         -- Cálculo de la velocidad externa, dividiendo por 2
			         vel_aux <= shift_right(vel_aux, 1);
			    elsif (cnt_1ms = fin_cnt_1ms - 1) then
			         -- Asignaci�n de la velocidad externa a la se�al de salida
			         velocidad <= std_logic_vector(vel_aux(7 downto 0));
			    end if;		
				
			end if;

		end if;

	end process;


end architecture rtl;
