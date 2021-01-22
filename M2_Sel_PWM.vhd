library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------

entity M2_Sel_PWM is

	port (

		-- Inputs
		clk      : in std_logic;
		rst      : in std_logic;
		btn_up   : in std_logic;
		btn_down : in std_logic;

		-- Outputs
		vec_PWM : out std_logic_vector (7 downto 0)

	);

end entity M2_Sel_PWM;

-------------------------------------------------------

architecture rtl of M2_Sel_PWM is

	type estadoFSM is (S0, S1);
	signal estado : estadoFSM;

	signal cnt_1ms    : unsigned (17 downto 0);
	signal acum_100ms : unsigned (6 downto 0);
	signal acum_250ms : unsigned (7 downto 0);
	signal vec_PWM_i  : unsigned (7 downto 0);

	constant fin_cnt_1ms    : integer := 99999;
	constant fin_acum_100ms : integer := 100;
	constant fin_acum_250ms : integer := 250;
	constant fin_vec_PWM    : integer := 99;

begin

	-- Relojes de funcionamiento
	process (rst, clk)
	begin

		if (rst = '0') then

			cnt_1ms <= (others => '0');
			acum_100ms <= (others => '0');
			acum_250ms <= (others => '0');

		elsif (clk = '1' and clk'event) then

            cnt_1ms <= cnt_1ms + 1;

			-- Reloj de 100 ms
			if (estado = S0) then		    

				if (acum_100ms = fin_acum_100ms) then

					acum_100ms <= (others => '0');
					cnt_1ms <= (others => '0');

				elsif (cnt_1ms = fin_cnt_1ms) then

					acum_100ms <= acum_100ms + 1;
					cnt_1ms <= (others => '0');

				end if;

			end if;
			
			if (estado = S1) then
			
			    acum_100ms <= (others => '0');
			
			end if;

			-- Reloj de 250 ms
			if (estado = S0 or estado = S1) then

				if (btn_up = '1' or btn_down = '1') then

					if (acum_250ms = fin_acum_250ms) then

						acum_250ms <= (others => '0');
						cnt_1ms <= (others => '0');

					elsif (cnt_1ms = fin_cnt_1ms) then

						acum_250ms <= acum_250ms + 1;
						cnt_1ms <= (others => '0');

					end if;

				elsif (btn_up = '0' and btn_down = '0') then
				
				    acum_250ms <= (others => '0');
				
				end if;

			end if;

		end if;

	end process;

	-- M谩quina de estados para pulsaci贸n continua o discreta
	process (clk, rst)
	begin

		if (rst = '0') then
		
		    -- Inicializaci髇 de las salidas
		    vec_PWM <= (others => '0');
		    
		    -- Inicializaci髇 de las se馻les intermedias
			estado    <= S0;
			vec_PWM_i <= (others => '0');

		elsif (clk = '1' and clk'event) then

			case estado is

				-- ESTADO 0: PULSACI脫N DISCRETA
				when S0 =>

					-- L贸gica del estado 0: cada 100 ms, se actualiza salida en
					-- funci贸n del valor de los pulsadores.
					if (acum_100ms = fin_acum_100ms) then

						if (btn_up = '1' and vec_PWM_i = fin_vec_PWM) then

							vec_PWM_i <= vec_PWM_i;

						elsif (btn_up = '1') then

							vec_PWM_i <= vec_PWM_i + 1;

						elsif (btn_down = '1' and vec_PWM_i = "0") then

							vec_PWM_i <= (others => '0');

						elsif (btn_down = '1') then

							vec_PWM_i <= vec_PWM_i - 1;

						end if;

					end if;

					-- Cambio de estado 0 -> 1: si se mantiene el pulsador durante
					-- 250 ms, cambio al estado 1 (mirar relojes).
					if (acum_250ms = fin_acum_250ms) then

						estado <= S1;

					end if;

					-- ESTADO 1: PULSACI脫N CONTINUA
					when S1 =>

						-- L贸gica del estado 1: si el pulsador est谩 pulsado durante 250 ms
						-- se aumenta de forma continua.
						if (acum_250ms = fin_acum_250ms) then

							if (btn_up = '1' and vec_PWM_i = fin_vec_PWM) then

								vec_PWM_i <= vec_PWM_i;

							elsif (btn_up = '1') then

								vec_PWM_i <= vec_PWM_i + 1;

							elsif (btn_down = '1' and vec_PWM_i = "0") then

								vec_PWM_i <= (others => '0');

							elsif (btn_down = '1') then

								vec_PWM_i <= vec_PWM_i - 1;

							end if;

						end if;

						-- Cambio de estado 1 -> 0: si ambos pulsadores est谩n no pulsados,
						-- vuelta al estado 0.
						if (btn_down = '0' and btn_up = '0') then

							estado <= S0;

						end if;


						-- OTHERS: Evitar aparici贸n de latches
						when others =>
							null;


				end case;

			vec_PWM <= std_logic_vector(vec_PWM_i);

		end if;

	end process;



						end architecture rtl;