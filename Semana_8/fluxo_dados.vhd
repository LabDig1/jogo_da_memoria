library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados is
    port (
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
		  fimRes: out std_logic;
      nivel: in std_logic_vector (1 downto 0)
    );
end entity fluxo_dados;

architecture estrutural of fluxo_dados is

    component contador_163 is
        port (
        clock : in  std_logic;
        clr   : in  std_logic;
        ld    : in  std_logic;
        ent   : in  std_logic;
        enp   : in  std_logic;
        D     : in  std_logic_vector (3 downto 0);
        Q     : out std_logic_vector (3 downto 0);
        rco   : out std_logic 
   );
    end component;

    component contador_mod is
      port (
        clock : in std_logic; -- sinais de entrada
        clr : in std_logic;
        ld : in std_logic;
        ent : in std_logic;
        enp : in std_logic;
        D : in std_logic_vector (12 downto 0);
        Q : out std_logic_vector (12 downto 0); -- sinais de saída
        rco : out std_logic 
 );
  end component;

  component contador_mod_2s is
    port (
      clock : in std_logic; -- sinais de entrada
    clr : in std_logic;
    ld : in std_logic;
    ent : in std_logic;
    enp : in std_logic;
    D : in std_logic_vector (10 downto 0);
    Q : out std_logic_vector (10 downto 0); -- sinais de saída
    rco : out std_logic 
);
end component;
	 
	 
	 
    component comparador_85 is
        port (  -- entradas
	i_A3   : in  std_logic;
	i_B3   : in  std_logic;
	i_A2   : in  std_logic;
	i_B2   : in  std_logic;
	i_A1   : in  std_logic;
	i_B1   : in  std_logic;
	i_A0   : in  std_logic;
	i_B0   : in  std_logic;
	i_AGTB : in  std_logic;
	i_ALTB : in  std_logic;
	i_AEQB : in  std_logic;
	-- saidas
	o_AGTB : out std_logic;
	o_ALTB : out std_logic;
	o_AEQB : out std_logic
        );
    end component;

	 
	 
	 
    component ram_16x4 is
        port(
          clk          : in  std_logic;
          endereco: in std_logic_vector(3 downto 0);
          dado_entrada: in std_logic_vector(3 downto 0);
          we: in std_logic;
          ce: in std_logic;
          dado_saida: out std_logic_vector(3 downto 0)
        );
    end component;

	 
    component registrador_4bits is
        port (
          clock:  in  std_logic;
          clear:  in  std_logic;
          enable: in  std_logic;
          D:      in  std_logic_vector(3 downto 0);
          Q:      out std_logic_vector(3 downto 0)
        );
      end component;
	 
    component edge_detector is
        port (
          clock  : in  std_logic;
          reset  : in  std_logic;
          sinal  : in  std_logic;
          pulso  : out std_logic);
        end component;
    
    signal great,zeraE_baixo,igual_out,menor,great_o,menor_o,enable_cin,rco_outc,or_JGD,zeraL_baixo,rco_outL,fim_L: std_logic;
    signal enderecoMenorqueLimite, IgualLimite, ZeraT_baixo,zera2_baixo: std_logic;
    signal s_jogada, entrada_m: std_logic_vector (3 downto 0);
    signal contador_out, s_dado,s_endereco,s_lim: std_logic_vector (3 downto 0);
    signal final: std_logic_vector (3 downto 0);
    begin
		  
        
          zeraE_baixo<= not zeraE;
        Contend: contador_163 port map (
            clock => clock,
            clr => zeraE_baixo,
            ld    => '1',
            ent   => '1',
            enp   =>enable_Cin,
            D     => "0000",
            Q     => s_endereco,
            rco   => rco_outC
        );
       
        ZeraL_baixo<= not ZeraL;
        Contlim: contador_163 port map (
            clock => clock,
            clr => ZeraL_baixo,
            ld    => '1',
            ent   => '1',
            enp   =>contaL,
            D     => "0000",
            Q     => s_lim,
            rco   => rco_outL
        );
        fimL<=rco_outL;
        db_limite<=s_lim;
      enable_Cin<=contaE;
      db_contagem<=s_endereco;

      ZeraT_baixo<= not Zera_T;

      Conttemp: contador_mod port map (
        clock => clock,
        clr => ZeraT_baixo,
        ld    => '1',
        ent   => '1',
        enp=>conta_T,
        D=> "0000000000000", 
        rco=>timeout
    );
    Zera2_baixo<= not Zera_2;
    Conttemp2: contador_mod_2s port map (
      clock => clock,
      clr => Zera2_baixo,
      ld    => '1',
      ent   => '1',
      enp=>conta_2,
      D=> "00000000000", 
      rco=>timeout2
  );

      complim: comparador_85 port map (
        i_A3  =>s_endereco(3),
          i_B3   => s_lim(3),
          i_A2   =>s_endereco(2),
          i_B2   => s_lim(2),
          i_A1   =>s_endereco(1),
          i_B1   => s_lim(1),
          i_A0   =>s_endereco(0),
          i_B0   => s_lim(0),
          i_AGTB =>'0',
          i_ALTB => '0',
          i_AEQB => '1',
          -- saidas
          o_ALTB =>enderecoMenorQueLimite,
          o_AEQB =>IgualLimite
    );

    compfim: comparador_85 port map (
        i_A3  =>s_endereco(3),
          i_B3   => final(3),
          i_A2   =>s_endereco(2),
          i_B2   => final(2),
          i_A1   =>s_endereco(1),
          i_B1   => final(1),
          i_A0   =>s_endereco(0),
          i_B0   => final(0),
          i_AGTB =>'0',
          i_ALTB => '0',
          i_AEQB => '1',
          -- saidas
          o_AEQB =>FimE
    );

    with nivel select
    final<="0011" when "00",
          "0111" when "01",
          "1011" when "10",
          "1111" when "11",
          "0000" when others;
        
	 
    enderecoIgualLimite<=IgualLimite;
    enderecoMenorOuIgualLimite<= enderecoMenorQueLimite or IgualLimite;

        compJog: comparador_85 port map (
            i_A3  =>s_dado(3),
	          i_B3   => botoes(3),
	          i_A2   =>s_dado(2),
	          i_B2   => botoes(2),
	          i_A1   =>s_dado(1),
	          i_B1   => botoes(1),
	          i_A0   =>s_dado(0),
	          i_B0   => botoes(0),
	          i_AGTB =>'0',
	          i_ALTB => '0',
	          i_AEQB => '1',
	          -- saidas
	          o_AGTB =>great,
	          o_ALTB =>menor,
	          o_AEQB => igual_out
        );
		  
		  compRes: comparador_85 port map (
            i_A3  =>s_dado(3),
	          i_B3   => '1',
	          i_A2   =>s_dado(2),
	          i_B2   => '1',
	          i_A1   =>s_dado(1),
	          i_B1   => '1',
	          i_A0   =>s_dado(0),
	          i_B0   => '1',
	          i_AGTB =>'0',
	          i_ALTB => '0',
	          i_AEQB => '1',
	          -- saidas
	          o_AEQB => fimRes
        );


        memoria: ram_16x4 port map(
          clk=> clock,
            endereco => s_endereco,
            dado_entrada => entrada_m,
            we => escreve,
            ce => '0',
            dado_saida => s_dado
        );
		  with reset_m select
		  entrada_m<=s_jogada when '0',
		  "1111"  when '1',
      "0000" when others;
        db_memoria<=s_dado;
        chavesIgualMemoria<=igual_out;

        RegBotoes: registrador_4bits port map(
        clock=>clock,
        clear=>limpaR,
        enable=>registraR,
        D=>botoes,
        Q=>s_jogada);
        db_jogada<=s_jogada;
        or_JGD<=botoes(0) or botoes(1) or botoes(2) or botoes(3);
        JGD: edge_detector port map(
            clock=>clock,
            reset=>reset,
            sinal=>or_JGD,
            pulso=>jogada_feita
        );
        db_tem_jogada<=or_JGD;
    end architecture;