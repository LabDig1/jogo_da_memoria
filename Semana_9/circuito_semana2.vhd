library ieee;
use ieee.std_logic_1164.all;
entity circuito_semana2 is
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
end entity;

architecture estrutural of circuito_semana2 is
    component fluxo_dados is
        port(
            clock : in std_logic;
		  reset: in std_logic;
      zera_T: in std_logic;
      conta_T: in std_logic;
      timeout: out std_logic;
        zeraE : in std_logic;
        limpaR: in std_logic;
        registraR: in std_logic;
        zeraL: in std_logic;
        contaL: in std_logic;
        contaE : in std_logic;
        escreve: in std_logic;
        botoes : in std_logic_vector (3 downto 0);
        fimE: out std_logic;
        fimL: out std_logic;
        db_tem_jogada: out std_logic;
        db_contagem : out std_logic_vector (3 downto 0);
        db_memoria: out std_logic_vector(3 downto 0);
        db_limite: out std_logic_vector (3 downto 0);
        jogada_feita: out std_logic;
        db_jogada: out std_logic_vector (3 downto 0);
        chavesIgualMemoria: out std_logic;
        enderecoMenorOuIgualLimite: out std_logic;
        enderecoIgualLimite: out std_logic;
        reset_m: in std_logic;
        zera_2: in std_logic;
        conta_2: in std_logic;
        timeout2: out std_logic;
		  fimRes:out std_logic;
          nivel: in std_logic_vector (1 downto 0);
          limpaN: in std_logic;
      registraN: in std_logic;
      nivel_out:  out std_logic_vector (1 downto 0)
        );
    end component;

    component unidade_controle is
        port(
            clock:     in  std_logic; 
    reset:     in  std_logic; 
    iniciar:   in  std_logic;
    fimC:       in  std_logic;
    fimL:       in  std_logic;
    timeout: in std_logic;
    jogada:   in std_logic;
    enderecoIgualLimite: in std_logic;
    espera: out std_logic;
    zera:      out std_logic;
    conta_end:     out std_logic;
    conta_lim: out std_logic;
    conta_T: out std_logic;
    zera_T: out std_logic;
    zera_lim: out std_logic;
    pronto:    out std_logic;
    db_estado: out std_logic_vector(4 downto 0);
    acertou: out std_logic;
    errou: out std_logic;
    registra: out std_logic;
    igual: in std_logic;
    escreve: out std_logic;
    zera_2: out std_logic;
    reset_m: out std_logic;
        conta_2: out std_logic;
        timeout2: in std_logic;
        repete: in std_logic;
        chegou: in std_logic;
        limpaN: out std_logic;
      registraN: out std_logic;
		mostra_m: out std_logic;
        display: out std_logic_vector (3 downto 0);
        nivel:  in std_logic_vector (1 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
        end component;

    component estado7seg is
        port (
                estado : in  std_logic_vector(4 downto 0);
                display : out std_logic_vector(6 downto 0)
        );
        end component;
    
    signal conta4,memo4,joga4,lim4,botoes_led: std_logic_vector (3 downto 0);
    signal conta,zeraE,registra,clk,jogada,igual_i,escreve_baixo,escreve,db_tem_jogada,db_clock: std_logic;
    signal zeraL,contaL,contaE,fimE,fimL,jogada_feita,chavesIgualMemoria,enderecoIgualLimite_i,zera_T,conta_T,timeout: std_logic;
    signal zera_2, conta_2,timeout2,reset_m,tudo_aceso_baixo,tudo_aceso,chegou: std_logic;
    signal mostra_memoria: std_logic;
    signal estad4: std_logic_vector (4 downto 0);
    signal limpaN, registraN: std_logic;
    signal db_limite, db_contagem, db_memoria, db_estado, db_jogada :  std_logic_vector (6 downto 0);
    signal display: std_logic_vector (3 downto 0);
    signal nivel_o: std_logic_vector (1 downto 0);
   
   
    begin
        
        with mostra_memoria select
		  leds<= botoes when '0',
		  memo4 when '1',
          "0000" when others;
        clk<=clock;
        FD: fluxo_dados port map(
            clock =>clk,
				reset=> reset,
        zeraE =>zeraE,
        limpaR=> zeraE,
        registraR=>registra,
        zeraL=>zeraL,
        contaL=>contaL,
        contaE =>contaE,
        escreve=>escreve_baixo,
        botoes =>botoes,
        fimE=>fimE,
        fimL=>fimL,
        db_tem_jogada=>db_tem_jogada,
        db_contagem =>conta4,
        db_memoria=>memo4,
        db_limite=>lim4,
        jogada_feita=>jogada_feita,
        db_jogada=>joga4,
        chavesIgualMemoria=>chavesIgualMemoria,
        enderecoIgualLimite=>enderecoIgualLimite_i,
        zera_T=>zera_T,
        conta_T=>conta_T,
        timeout=>timeout,
        zera_2=>zera_2,
    reset_m=>reset_m,
        conta_2=>conta_2,
        timeout2=>timeout2,
		  fimRes=>chegou,
          nivel=>nivel,
          limpaN=>limpaN,
      registraN=> registraN,
      nivel_out=>nivel_o
        );
        db_igual<=chavesIgualMemoria;
        UC: unidade_controle port map(
            clock=>clock, 
        reset=>reset,
        iniciar=>iniciar,
        fimC=>fimE,
        fimL=>fimL,
        jogada=>jogada_feita,
        enderecoIgualLimite=>enderecoIgualLimite_i,
        zera=>zeraE,
        conta_end=>contaE,
        conta_lim=>contaL,
        zera_lim=>zeraL,
        pronto=>fim,
        db_estado=>estad4,
        acertou=>acertou,
        errou=>errou,
        registra=>registra,
        igual=>chavesIgualMemoria,
        escreve=>escreve,
        espera=>espera,
        zera_T=>zera_T,
        conta_T=>conta_T,
        timeout=>timeout,
        zera_2=>zera_2,
    reset_m=>reset_m,
        conta_2=>conta_2,
        timeout2=>timeout2,
        repete=> repete,
        chegou=>chegou,
        limpaN=>limpaN,
      registraN=> registraN,
		mostra_m=>mostra_memoria,
        display=>display,
        nivel=>nivel_o
        );

        escreve_baixo<= not escreve;
        db_clock<=clk;
        HEX1: hexa7seg port map(
            hexa =>conta4,
            sseg =>db_contagem
        );

        HEX2: hexa7seg port map(
            hexa =>memo4,
            sseg =>db_memoria
        );

        HEX3: estado7seg port map(
            estado =>estad4,
            display =>db_estado
        );

        HEX4: hexa7seg port map(
            hexa=>joga4,
            sseg=> db_jogada
        );
        HEX5: hexa7seg port map(
            hexa=>lim4,
            sseg=> db_limite
        );

        with display select hexa0 <=
        db_contagem when "0000", --db
        "1000000" when "0001", --iniciO
        "1111001" when "0100", -- nivel 1
        "0100100" when "0101" ,-- nivel 2
        "0110000" when "0110" ,-- nivel 3
        "0011001" when "0111" ,-- nivel 4
        "1000000" when "1000" ,-- acertO,
        "1111111" when others;
        with display select hexa1 <=
        db_memoria when "0000", --db
        "1111001" when "0001", --inicIo
        "1000111" when "0100" ,-- niveL 1
        "1000111" when "0101" ,-- niveL 2
        "1000111" when "0110" ,-- niveL 3
        "1000111" when "0111" ,-- niveL 4
        "1000000" when "0011" ,-- tempO
        "0000111" when "1000", --acerTo
        "1111111" when others;

        with display select hexa2 <=
        db_jogada when "0000", --db
        "1000110" when "0001", --iniCio
        "0110000" when "0100" ,-- nivEl 1
        "0110000" when "0101" ,-- nivEl 2
        "0110000" when "0110" ,-- nivEl 3
        "0110000" when "0111" ,-- nivEl 4
        "0001100" when "0011" ,-- temPo
        "0101111" when "1000", --aceRto
        "1000000" when "0010", --errO
        "1111111" when others;

        

        with display select hexa3 <=
        db_limite when "0000", --db
        "1111001" when "0001", --inIcio
        "1100011" when "0100" ,-- niVel 1
        "1100011" when "0101" ,-- niVel 2
        "1100011" when "0110" ,-- niVel 3
        "1100011" when "0111" ,-- niVel 4
        "1010100" when "0011" ,-- teMpo
        "0000110" when "1000", --acErto
        "0101111" when "0010", --erRo
        "1111111" when others;

        with display select hexa4 <=
        "0101011" when "0001", --iNicio
        "1111001"  when "0100" ,-- nIvel 1
        "1111001"  when "0101" ,-- nIvel 2
        "1111001"  when "0110" ,-- nIvel 3
        "1111001"  when "0111" ,-- nIvel 4
        "0000110" when "0011" ,-- tEmpo
        "1000110" when "1000", --aCerto
        "0101111" when "0010", --eRro
        "1111111" when others;

        with display select hexa5 <=
        db_estado when "0000", --db
        "1111001" when "0001", --Inicio
        "0101011" when "0100" ,-- Nivel 1
        "0101011" when "0101" ,-- Nivel 2
        "0101011" when "0110" ,-- Nivel 3
        "0101011" when "0111" ,-- Nivel 4
        "0000111" when "0011" ,-- Tempo
        "1110111" when "1000", --Acerto
        "0000110" when "0010", --Erro
        "1111111" when others;

      



end architecture;