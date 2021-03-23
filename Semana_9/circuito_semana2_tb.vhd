library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity circuito_semana2_tb is
end entity;

architecture tb of circuito_semana2_tb is
	component circuito_semana2
	port(
		clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        botoes : in std_logic_vector (3 downto 0);
        acertou : out std_logic;
        errou : out std_logic;
        fim : out std_logic;
        espera: out std_logic;
        leds: out std_logic_vector (3 downto 0);
        repete: in std_logic;
        nivel: in std_logic_vector (1 downto 0);
        db_igual : out std_logic;
        hexa0 : out std_logic_vector (6 downto 0);
        hexa1 : out std_logic_vector (6 downto 0);
        hexa2 : out std_logic_vector (6 downto 0);
        hexa3 : out std_logic_vector (6 downto 0);
        hexa4 : out std_logic_vector (6 downto 0);
        hexa5 : out std_logic_vector (6 downto 0)
	);
	end component;
	type arranjo_memoria is array(0 to 15) of std_logic_vector(3 downto 0);
	signal memoria : arranjo_memoria := 
		(
			"0100",
			"0010",
			"0100",
			"1000",
			"0100",
			"0010",
			"1000",
			"0001",
			"0010",
			"0010",
			"0100",
			"0100",
			"1000",
			"1000",
			"0001",
			"0100" 
		);
  
	constant TbPeriod 			: 	time 		:= 	1000000 ns; --1000000ns para 1kHz de clock
	signal TbSimulation 		: 	std_logic 	:= 	'0';
	signal TbButtonOnWait		: 	integer 	:= 	4;
	signal TbButtonOffWait		: 	integer 	:= 	7;
	signal TbZero				: 	std_logic_vector(3 downto 0) := "0000";

	signal clock, reset, inicia, fim, acertou, errou, espera, repete : std_logic;
	signal botoes, leds 	: std_logic_vector(3 downto 0);
	signal hexa0, hexa1, hexa2, hexa3, hexa4, hexa5: std_logic_vector(6 downto 0);
	signal nivel : std_logic_vector(1 downto 0);

begin
	DUT: circuito_semana2 port map 
	(
		Clock		=>		clock,
		repete 		=>		repete,
		reset		=>		reset,
		iniciar		=>		inicia,
		botoes		=>		botoes,
		leds		=>		leds,
		fim			=>		fim,
		acertou		=>		acertou,
		errou		=>		errou,
		espera		=>		espera,
		nivel		=>		nivel,
		hexa0		=>		hexa0,
		hexa1		=>		hexa1,
		hexa2		=>		hexa2,
		hexa3		=>		hexa3,
		hexa4		=>		hexa4,
		hexa5		=>		hexa5
	);
	
	clock <= not clock after TbPeriod/2 when TbSimulation = '1' else '0';
	stimuli: process
	begin
		TbSimulation <= '1';
		botoes <= "0000";
			-- Condicoes iniciais
			reset <= '1';
			wait for 2*TbPeriod;
			reset <= '0';
			wait for 2*TbPeriod;
			
			
			--Teste acerta tudo - nivel 00
			nivel <= "00";
			inicia <= '1';
			wait for TbButtonOnWait*TbPeriod;
			inicia <= '0';
			wait for TbPeriod * 5000;
			
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod * 3;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod * 3	;
----------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod * 3;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod * 3;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod * 3;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod * 3;
-----------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------


			--Teste acerta tudo - nivel 01
			nivel <= "01";
			inicia <= '1';
			wait for TbButtonOnWait*TbPeriod;
			inicia <= '0';
			wait for TbButtonOnWait*TbPeriod;
			wait for TbButtonOnWait*TbPeriod;
			wait for TbButtonOnWait*TbPeriod;
			wait for TbButtonOnWait*TbPeriod;
			
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
----------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
-----------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

--------------------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(4);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------

			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(4);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(5);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------

			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(4);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(5);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(6);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------
			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(4);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(5);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(6);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(7);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;
--------------------------------------------------

			botoes <= memoria(0);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(1);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(2);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(3);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(4);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(5);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(6);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;

			botoes <= memoria(7);
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOnWait*TbPeriod;


			--Inicio do jogo
			nivel <= "10";
			inicia <= '1';
			wait for TbButtonOnWait*TbPeriod;
			inicia <= '0';
			wait for TbButtonOnWait*TbPeriod;
			
			--Teste ate o 3 e errar
			for i in 0 to 3 loop
				for j in 0 to i loop
					botoes <= memoria(j);
					wait for TbButtonOnWait * TbPeriod;
					botoes <= TbZero;
					wait for TbButtonOffWait * TbPeriod;
				end loop;
				wait for TbButtonOnWait*TbPeriod;
			end loop;
			-- Erra
			botoes <= "0001";
			wait for TbButtonOnWait * TbPeriod;
			botoes <= TbZero;
			wait for TbButtonOffWait * TbPeriod;



			--Inicio do jogo
			nivel <= "11";
			inicia <= '1';
			wait for TbButtonOnWait*TbPeriod;
			inicia <= '0';
			wait for TbButtonOnWait*TbPeriod;
			
			--Teste ate o 3 e erra por tempo
			for i in 0 to 3 loop
				for j in 0 to i loop
					botoes <= memoria(j);
					wait for TbButtonOnWait * TbPeriod;
					botoes <= TbZero;
					wait for TbButtonOffWait * TbPeriod;
				end loop;
				wait for TbButtonOnWait*TbPeriod;
			end loop;
			-- Erra
			wait for TbPeriod * 5050;

		TbSimulation <= '0';
		wait;
	end process;
		
end architecture;
