library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------

entity M5_Control is

	port (
	
		-- Inputs
		clk           : in std_logic;
		rst           : in std_logic;
		PWM_vector_in : in std_logic_vector (7 downto 0);
		velocidad     : in std_logic_vector (7 downto 0);
		
		-- Outputs
		PWM_vector_out : out std_logic_vector(7 downto 0)
		
	);

end entity M5_Control;

-------------------------------------------------------

architecture rtl of M5_Control is

	-- Señales para el algoritmo de control
	signal PWM_vector_ctr : unsigned (7 downto 0);
	signal PWM_vector_out_aux : unsigned (7 downto 0);
	signal err             : signed (7 downto 0);

	-- Señales para el reloj de 250 ms
	signal cnt_1ms          : unsigned (16 downto 0);
	constant fin_cnt_1ms    : integer := 99999;
	signal acum_250ms       : unsigned (7 downto 0);
	constant fin_acum_250ms : integer := 250;

	-- Señales intermedias para conversión rpm-PWM
	signal a : unsigned (15 downto 0);


begin

    -- Reloj de 250 ms
	process (clk, rst)
	begin

		if (rst = '0') then

			cnt_1ms    <= (others => '0');
			acum_250ms <= (others => '0');

		elsif (clk = '1' and clk'event) then

			-- lógica del reloj
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
    
    -- Lazo de control
    process(clk, rst)
    begin
    
        if (rst = '0') then
        
            PWM_vector_ctr <= (others => '0');
            PWM_vector_out_aux <= (others => '0');
            err <= (others => '0');
            a <= (others => '0');
        
        elsif (clk = '1' and clk'event) then
        
            if (acum_250ms = fin_acum_250ms - 1) then
            
                if (cnt_1ms = fin_cnt_1ms - 5) then
                    -- Convierto velocidad a PWM duty cicle. Paso 1: multiplicaci�n por 5
                    PWM_vector_ctr <= shift_left(unsigned(velocidad), 2) + unsigned(velocidad);
                elsif (cnt_1ms = fin_cnt_1ms - 4) then
                    -- Convierto velocidad a PWM duty cicle. Paso 2: dividiendo por 8
                    PWM_vector_ctr <= shift_right(PWM_vector_ctr, 3);
                elsif (cnt_1ms = fin_cnt_1ms - 3) then
                    -- C�lculo del error
                    err <= signed(PWM_vector_in) - signed(PWM_vector_ctr); 
                elsif (cnt_1ms = fin_cnt_1ms - 2) then
                    -- Actualizo la salida dependiendo del signo del error
                    if (err > 0) then
                        PWM_vector_out_aux <= unsigned(PWM_vector_in) + shift_right(unsigned(PWM_vector_in), 4);
                    elsif (err < 0) then
                        PWM_vector_out_aux <= unsigned(PWM_vector_in) - shift_right(unsigned(PWM_vector_in), 4);
                    end if;
                elsif (cnt_1ms = fin_cnt_1ms - 1) then
                    -- Asigno a la salida los 8 bits de menor peso de la sig auxiliar
                    PWM_vector_out <= std_logic_vector(PWM_vector_out_aux(7 downto 0));
                end if;
            
            end if;
        
        end if;
    
    end process;

end architecture rtl;