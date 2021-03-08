library ieee;
use ieee.std_logic_1164.all;
entity circuito_exp7_desafio is
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
        db_limite : out std_logic_vector (6 downto 0);
        db_igual : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria : out std_logic_vector (6 downto 0);
        db_estado : out std_logic_vector (6 downto 0);
        db_jogada : out std_logic_vector (6 downto 0)
    );
end entity;

architecture estrutural of circuito_exp7_desafio is
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
		  fimRes:out std_logic
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
    db_estado: out std_logic_vector(3 downto 0);
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
        chegou: in std_logic
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
        end component;
    
    signal conta4,memo4,estad4,joga4,lim4,botoes_led: std_logic_vector (3 downto 0);
    signal conta,zeraE,registra,clk,jogada,igual_i,escreve_baixo,escreve,db_tem_jogada,db_clock: std_logic;
    signal zeraL,contaL,contaE,fimE,fimL,jogada_feita,chavesIgualMemoria,enderecoIgualLimite_i,zera_T,conta_T,timeout: std_logic;
    signal zera_2, conta_2,timeout2,reset_m,tudo_aceso_baixo,tudo_aceso,chegou: std_logic;
    signal mostra_memoria: std_logic_vector (3 downto 0);
    begin
        tudo_aceso_baixo<= not chegou;
        tudo_aceso<= not tudo_aceso_baixo;
        mostra_memoria(0)<= memo4(0) and tudo_aceso_baixo;
        mostra_memoria(1)<= memo4(1) and tudo_aceso_baixo;
        mostra_memoria(2)<= memo4(2) and tudo_aceso_baixo;
        mostra_memoria(3)<= memo4(3) and tudo_aceso_baixo;
        leds(0)<=botoes(0) xor mostra_memoria(0);
        leds(1)<=botoes(1) xor mostra_memoria(1);
        leds(2)<=botoes(2) xor mostra_memoria(2);
        leds(3)<=botoes(3) xor mostra_memoria(3);
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
		  fimRes=>chegou
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
        chegou=>chegou
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

        HEX3: hexa7seg port map(
            hexa =>estad4,
            sseg =>db_estado
        );

        HEX4: hexa7seg port map(
            hexa=>joga4,
            sseg=> db_jogada
        );
        HEX5: hexa7seg port map(
            hexa=>lim4,
            sseg=> db_limite
        );
end architecture;