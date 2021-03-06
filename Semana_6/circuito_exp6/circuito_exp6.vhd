library ieee;
use ieee.std_logic_1164.all;
entity circuito_exp6 is
    port(
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        botoes : in std_logic_vector (3 downto 0);
        acertou : out std_logic;
        errou : out std_logic;
        pronto : out std_logic;
        leds: out std_logic_vector (3 downto 0);
        db_limite : out std_logic_vector (6 downto 0);
        db_igual : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria : out std_logic_vector (6 downto 0);
        db_estado : out std_logic_vector (6 downto 0);
        db_jogada : out std_logic_vector (6 downto 0);
        db_clock : out std_logic;
        db_tem_jogada : out std_logic

    );
end entity;

architecture estrutural of circuito_exp6 is
    component fluxo_dados is
        port(
            clock : in std_logic;
				reset: in std_logic;
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
        enderecoIgualLimite: out std_logic
        );
    end component;

    component unidade_controle is
        port(
            clock:     in  std_logic; 
    reset:     in  std_logic; 
    iniciar:   in  std_logic;
    fimC:       in  std_logic;
    fimL:       in  std_logic;
    jogada:   in std_logic;
    enderecoIgualLimite: in std_logic;
    zera:      out std_logic;
    conta_end:     out std_logic;
    conta_lim: out std_logic;
    zera_lim: out std_logic;
    pronto:    out std_logic;
    db_estado: out std_logic_vector(3 downto 0);
    acertou: out std_logic;
    errou: out std_logic;
    registra: out std_logic;
    igual: in std_logic
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
        end component;
    
    signal conta4,memo4,estad4,joga4,lim4,botoes_led: std_logic_vector (3 downto 0);
    signal conta,fim,zeraE,registra,clk,jogada,igual_i: std_logic;
    signal zeraL,contaL,contaE,fimE,fimL,jogada_feita,chavesIgualMemoria,enderecoIgualLimite: std_logic;
    begin
        leds(0)<=botoes(0);
        leds(1)<=botoes(1);
        leds(2)<=botoes(2);
        leds(3)<=botoes(3);
        clk<=clock;
        FD: fluxo_dados port map(
            clock =>clk,
				reset=>reset,
        zeraE =>zeraE,
        limpaR=> zeraE,
        registraR=>registra,
        zeraL=>zeraL,
        contaL=>contaL,
        contaE =>contaE,
        escreve=>'1',
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
        enderecoIgualLimite=>enderecoIgualLimite
        );
        db_igual<=chavesIgualMemoria;
        UC: unidade_controle port map(
            clock=>clock, 
        reset=>reset,
        iniciar=>iniciar,
        fimC=>fimE,
        fimL=>fimL,
        jogada=>jogada_feita,
        enderecoIgualLimite=>enderecoIgualLimite,
        zera=>zeraE,
        conta_end=>contaE,
        conta_lim=>contaL,
        zera_lim=>zeraL,
        pronto=>pronto,
        db_estado=>estad4,
        acertou=>acertou,
        errou=>errou,
        registra=>registra,
        igual=>chavesIgualMemoria
        );
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