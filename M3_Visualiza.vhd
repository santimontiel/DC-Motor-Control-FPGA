library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity M3_Visualiza is

	port (

		-- Inputs
		clk        : in std_logic;                      -- Reloj de 100 MHz
		rst        : in std_logic;                      -- Reset asíncrono (a nivel bajo)
		PWM_vector : in std_logic_vector (7 downto 0); -- Vector de ciclo de trabajo
		sw_Dir     : in std_logic;                      -- Switch para sentido de giro
		sw_sel_dir : in std_logic;                      -- Switch para selección de información de display
														-- 0 -> Duty cycle, 1 -> Velocidad
		velocidad  : in std_logic_vector (7 downto 0);

		-- Outputs
		seg7_code : out std_logic_vector (7 downto 0); -- Bus de 7 segmentos
		sel_disp  : out std_logic_vector (7 downto 0)  -- Bus de ánodos de los displays

	);

end entity M3_Visualiza;

architecture rtl of M3_Visualiza is

    -- Signals para mapeo de bcd2seg
	signal bcd_code : std_logic_vector (3 downto 0);

    -- Signals para mapeo de bin2bcd
    signal hex_in_i : std_logic_vector (7 downto 0);
    signal bcd_hun_i : std_logic_vector (3 downto 0);
    signal bcd_ten_i : std_logic_vector (3 downto 0);
    signal bcd_uni_i : std_logic_vector (3 downto 0);    
    
    -- Signal de selecci�n de display
	signal selection : std_logic_vector (1 downto 0);

    -- Signals temporales
	signal cnt_1ms          : unsigned (16 downto 0);
	constant fin_cnt_1ms    : integer := 99999;
	signal acum_250ms       : unsigned (7 downto 0);
	constant fin_acum_250ms : integer := 250;

    -- Declaraci�n: bcd2seg
	component bcd2seg is
		port (
			bcd     : in  std_logic_vector (3 downto 0);
			display : out std_logic_vector (7 downto 0)
		);
	end component bcd2seg;

    -- Declaraci�n bin2bcd
	component bin2bcd is
		port (
			clk     : in  std_logic;
			rst     : in  std_logic;
			hex_in  : in  std_logic_vector (7 downto 0);
			bcd_hun : out std_logic_vector (3 downto 0);
			bcd_ten : out std_logic_vector (3 downto 0);
			bcd_uni : out std_logic_vector (3 downto 0)
		);
	end component bin2bcd;

begin

	U1 : bcd2seg
		port map (
			bcd     => bcd_code,
			display => seg7_code
		);

	U2 : bin2bcd
		port map (
			clk     => clk,
			rst     => rst,
			hex_in  => hex_in_i,
			bcd_hun => bcd_hun_i,
			bcd_ten => bcd_ten_i,
			bcd_uni => bcd_uni_i
		);

	-- Reloj de 250 ms
	process (clk, rst)
	begin

		if (rst = '0') then

			cnt_1ms    <= (others => '0');
			acum_250ms <= (others => '0');

		elsif (clk = '1' and clk'event) then

			cnt_1ms <= cnt_1ms + 1;

			if (acum_250ms = fin_acum_250ms) then

				acum_250ms <= (others => '0');
				cnt_1ms    <= (others => '0');

			elsif (cnt_1ms = fin_cnt_1ms) then

				acum_250ms <= acum_250ms + 1;
				cnt_1ms    <= (others => '0');

			end if;

		end if;

	end process;

	-- Selección de dato y display a mostrar
	process (clk, rst)
	begin

		if (rst = '0') then

			bcd_code  <= (others => '0');
			sel_disp  <= (others => '1');
			selection <= (others => '0');

		elsif (clk = '1' and clk'event) then
		
		    if (sw_sel_dir = '1') then
                    
                hex_in_i <= velocidad(7 downto 0);
                    
            elsif (sw_sel_dir = '0') then
                    
                hex_in_i <= PWM_vector(7 downto 0);                
                    
            end if;

			if (cnt_1ms = fin_cnt_1ms) then

				case (selection) is

					when "00" =>

						sel_disp <= "11111110";
						bcd_code <= bcd_uni_i;
						selection <= "01";

					when "01" =>

						sel_disp <= "11111101";
					    bcd_code <= bcd_ten_i;
						selection <= "10";

					when "10" =>

						sel_disp <= "11111011";
						bcd_code <= bcd_hun_i;
						selection <= "11";

					when "11" =>

						sel_disp <= "11110111";
						if (sw_Dir = '0') then
							bcd_code <= "1111";
						elsif (sw_Dir = '1') then
							bcd_code <= "0000";
						end if;
						selection <= "00";

					when others =>
						null;

				end case;

			end if;

		end if;

	end process;

end architecture rtl;
