library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------------------

entity M1_Gen_PWM is

	port (
		-- Inputs
		CLK        : in std_logic;                    -- Reloj de 100 MHz
		rst        : in std_logic;                    -- Reset asíncrono activo a nivel bajo
		sw_Dir     : in std_logic;                    -- Switch para sentido de giro
		PWM_vector : in std_logic_vector(7 downto 0); -- Vector dato para PWM

		-- Outputs
		pinDir : out std_logic; -- Sentido de giro del motor
		pinEn  : out std_logic  -- Salida PWM generada
	);

end entity M1_Gen_PWM;

---------------------------------------------------------------------------------------------

architecture rtl of M1_Gen_PWM is
    
    type estadoFSM is (S0, S1);
    signal estado          : estadoFSM;
    
    signal cnt_5us         : unsigned (8 downto 0);
    constant fin_cnt_5us   : integer := 499;
    
    signal cnt_1ms         : unsigned (16 downto 0);
    constant fin_cnt_1ms   : integer := 99999;
    
    signal cnt_15ms        : unsigned (3 downto 0);
    constant fin_cnt_15ms  : integer := 15;
    
    signal bt_15ms         : unsigned (1 downto 0);
    constant fin_bt_15ms   : integer := 2;
	
	signal pwm_cycle       : unsigned (7 downto 0);
	constant fin_pwm_cycle : integer := 99;
	
	signal sw_Dir_i        : std_logic;
		
begin  

	process (clk, rst) is
	begin

		if (rst = '0') then
		
		    estado <= S0;
		
		    -- Inicializaci�n de las salidas
		    pinEn  <= '0';
            pinDir <= '0';
            
			-- Inicializaci�n de las variables del estado 0 (generaci�n de PWM)	
			pwm_cycle <= (others => '0');
            cnt_5us   <= (others => '0');
            sw_Dir_i  <= sw_Dir;
            
            -- Inicializaci�n de las variables del estado 1 (transiciones)
            cnt_1ms  <= (others => '0');
            cnt_15ms <= (others => '0');
            bt_15ms  <= (others => '0');
            
		elsif (clk = '1' and clk'event) then

			case estado is 
			
			     when S0 =>
			         
			        cnt_5us   <= cnt_5us + 1;	
			        sw_Dir_i  <= sw_Dir;
                 
                    if (cnt_5us = fin_cnt_5us and pwm_cycle = fin_pwm_cycle) then
                 
                        cnt_5us   <= (others => '0');
                        pwm_cycle <= (others => '0');
                      
                    elsif (cnt_5us = fin_cnt_5us) then
                      
                        pwm_cycle <= pwm_cycle + 1;
                      
                    end if;
                  
                    if (pwm_cycle = unsigned(PWM_vector)) then
                  
                        pinEn <= '0';
                      
                    elsif (pwm_cycle = 0) then
                      
                        pinEn <= '1';
                                       
                    end if;
                    
                    if (sw_Dir_i = not(sw_Dir)) then
                    
                        estado    <= S1;
                        cnt_5us   <= (others => '0');
                        pwm_cycle <= (others => '0');
                        
                    end if;
                   
               
			     
			     when S1 =>
			     
			         pinEn <= '0';
			         cnt_1ms <= cnt_1ms + 1;
			         
			         if (cnt_1ms = fin_cnt_1ms) then
			         
			             cnt_15ms <= cnt_15ms + 1;
			             cnt_1ms  <= (others => '0');
			          
			         end if;
			          
			         if (cnt_15ms = fin_cnt_15ms) then
			         
			             bt_15ms <= bt_15ms + 1; 
			             cnt_15ms  <= (others => '0');
			             
			         end if;	
			         		
			         if (bt_15ms = fin_bt_15ms) then 
			         
			             estado   <= S0;
			             cnt_1ms  <= (others => '0');
                         cnt_15ms <= (others => '0');
                         bt_15ms  <= (others => '0');
			         
			         elsif (bt_15ms = "01") then
			         
			             pinDir <= sw_Dir;
			             			         
			         end if;
			         			  
			     when others =>
			         null;   
			     
            end case;
			
		end if;  

    end process;

end architecture rtl;
