library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
  port ( 
    clock:     in  std_logic; 
    reset:     in  std_logic; 
    iniciar:   in  std_logic;
    fim:       in  std_logic;
    zera:      out std_logic;
    conta:     out std_logic;
    pronto:    out std_logic;
    db_estado: out std_logic_vector(3 downto 0)
  );
end entity;

architecture fsm of unidade_controle is
  type t_estado is (A, B, C, D, E, M);
  signal Eatual, Eprox: t_estado;
begin
  -- memoria de estado
  process (clock,reset)
  begin
    if reset='1' then
      Eatual <= A;
    elsif clock'event and clock = '1' then
      Eatual <= Eprox; 
    end if;
  end process;

  -- logica de proximo estado
  Eprox <=
      A when  Eatual=A and iniciar='0' else
      B when  Eatual=A and iniciar='1' else
		M when  Eatual=B else
      C when  Eatual=M else
      D when  Eatual=C and fim='0' else
      E when  Eatual=C and fim='1' else
      M when  Eatual=D else
      A when  Eatual=E else
      A;

  -- logica de saída (maquina de Moore)
  with Eatual select
    zera <=   '0' when A | C | D | E | M,
              '1' when B,
              '0' when others;

  with Eatual select
    conta <=  '0' when A | B | C | E | M,
              '1' when D,
              '0' when others;

  with Eatual select
    pronto <= '0' when A | B | C | D | M,
              '1' when E,
              '0' when others;

  -- saida de depuracao (db_estado)
  with Eatual select
    db_estado <= "0000" when A,      -- 0
                 "1011" when B,      -- B
                 "1100" when C,      -- C
                 "1101" when D,      -- D
                 "1110" when E,      -- E
					  "0111" when M,      -- M
                 "1111" when others; -- F
end fsm;

----------------------------------------------------------------
-- Arquivo : contador_163.vhd
-- Projeto : Experiencia 01 - Primeiro Contato com VHDL
----------------------------------------------------------------
-- Descricao : contador binario hexadecimal (modulo 16)
-- similar ao CI 74163
----------------------------------------------------------------
-- Revisoes :
-- Data Versao Autor Descricao
-- 29/12/2020 1.0 Edson Midorikawa criacao
----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity contador_163 is -- entidade principal
 port (
clock : in std_logic; -- sinais de entrada
clr : in std_logic;
ld : in std_logic;
ent : in std_logic;
enp : in std_logic;
D : in std_logic_vector (3 downto 0);
Q : out std_logic_vector (3 downto 0); -- sinais de saída
rco : out std_logic
 );
end contador_163;
architecture comportamental of contador_163 is -- declaração da arquitetura
 signal IQ: integer range 0 to 15;
begin
 process (clock,ent,IQ) -- inicio do process do circuito
 begin
if clock'event and clock='1' then
-- as mudanças no circuito ocorrem com o clock em 1
if clr='0' then IQ <= 0;
-- caso o sinal clear seja 0, a contagem é reiniciada
elsif ld='0' then IQ <= to_integer(unsigned(D));
-- caso o sinal load seja 0, a entrada D é carregada
elsif ent='1' and enp='1' then
-- ambos os sinais de controle precisam estar em 1
-- para que a contagem seja realizada
if IQ=15 then IQ <= 0;
-- caso chegue no final da contagem, volta p/ 0
else IQ <= IQ + 1;
-- caso contrário, soma-se 1 no contador
end if;
else IQ <= IQ;
-- caso um dos dois sinais de controle não esteja em nível
-- lógico alto, o contador permanece em seu estado atual
end if;
end if;
if IQ=15 and ent='1' then rco <= '1';
-- caso o contador tenha chegado no final, rco assume valor 1
else rco <= '0';
end if;
Q <= std_logic_vector(to_unsigned(IQ, Q'length));
-- a saída Q recebe o valor do sinal utilizado para a contagem
 end process; -- fim do process
end comportamental; -- fim da arquitetura




-------------------------------------------------------------------
-- Arquivo   : comparador_85.vhd
-- Projeto   : Experiencia 02 - Um Fluxo de Dados Simples
-------------------------------------------------------------------
-- Descricao : comparador binario de 4 bits
--         	similar ao CI 7485
--         	baseado em descricao criada por Edson Gomi (11/2017)
-------------------------------------------------------------------
-- Revisoes  :
-- 	Data    	Versao  Autor         	Descricao
-- 	02/01/2021  1.0 	Edson Midorikawa  criacao
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity comparador_85 is  -- declaracao da entidade do comparador
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
end entity comparador_85;

architecture dataflow of comparador_85 is -- inicio da arquitetura do comparador
  -- sinais intermediarios que comparam A e B sem levar em consideracao as entradas de cascateamento 
 signal agtb : std_logic;
  signal aeqb : std_logic;
  signal altb : std_logic;
begin
  -- equacoes dos sinais: pagina 462, capitulo 6 do livro-texto
  -- Wakerly, J.F. Digital Design - Principles and Practice, 4th Edition
  -- veja tambem datasheet do CI SN7485 (Function Table)
  agtb <= (i_A3 and not(i_B3)) or
      	(not(i_A3 xor i_B3) and i_A2 and not(i_B2)) or
      	(not(i_A3 xor i_B3) and not(i_A2 xor i_B2) and i_A1 and not(i_B1)) or
      	(not(i_A3 xor i_B3) and not(i_A2 xor i_B2) and not(i_A1 xor i_B1) and i_A0 and not(i_B0));
  -- checa se a > b
  aeqb <= not((i_A3 xor i_B3) or (i_A2 xor i_B2) or (i_A1 xor i_B1) or (i_A0 xor i_B0));
  -- checa se a = b 
  altb <= not(agtb or aeqb);
  -- checa se a < b
  o_AGTB <= agtb or (aeqb and (not(i_AEQB) and not(i_ALTB)));
  o_ALTB <= altb or (aeqb and (not(i_AEQB) and not(i_AGTB)));
  o_AEQB <= aeqb and i_AEQB;
  -- nas saidas, são levadas em consideracao as entradas de cascateamento para obter um resultado final
 
end architecture dataflow; -- fim da arquitetura

----------------------------------------------------------------
-- Arquivo   : ram_16x4.vhd
-- Projeto   : Experiencia 03 - Desenvolvendo o Fluxo de Dados
----------------------------------------------------------------
-- Descricao : módulo de memória RAM 16x4 
--             sinais we e ce ativos em baixo
--             codigo ADAPTADO do código encontrado no livro 
--               VHDL Descricao e Sintese de Circuitos Digitais
--               Roberto D'Amore, LTC Editora.
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     08/01/2020  1.0     Edson Midorikawa  criacao
--     01/02/2020  2.0     Antonio V.S.Neto  Atualizacao para 
--                                           RAM sincrona para
--                                           minimizar problemas
--                                           com Quartus.
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_16x4 is
   port (       
		 clk          : in  std_logic;
		 endereco     : in  std_logic_vector(3 downto 0);
       dado_entrada : in  std_logic_vector(3 downto 0);
       we           : in  std_logic;
       ce           : in  std_logic;
       dado_saida   : out std_logic_vector(3 downto 0)
    );
end entity ram_16x4;

architecture ram1 of ram_16x4 is
  type   arranjo_memoria is array(0 to 15) of std_logic_vector(3 downto 0);
  signal memoria : arranjo_memoria;
  
  -- Configuracao do Arquivo MIF
  attribute ram_init_file: string;
  attribute ram_init_file of memoria: signal is "ram_conteudo_jogadas.mif";
  
begin

  process(clk)
  begin
    if (clk = '1' and clk'event) then
		if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"
		   
			-- Detecta nível baixo de we para escrita
			if (we = '0') 
				then memoria(to_integer(unsigned(endereco))) <= dado_entrada;
			end if;
			
		end if;
		
		-- Atualiza saida da memoria
		dado_saida <= memoria(to_integer(unsigned(endereco)));
		
	end if;
  end process;
  
end architecture ram1;








library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados is
    port (
        clock : in std_logic;

        zeraC : in std_logic;

        contaC : in std_logic;
        escreveM: in std_logic;
        chaves : in std_logic_vector (3 downto 0);
        fimC: out std_logic;
        db_contagem : out std_logic_vector (3 downto 0);
        db_memoria: out std_logic_vector(3 downto 0);


        igual: out std_logic
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
          endereco     : in  std_logic_vector(3 downto 0);
            dado_entrada : in  std_logic_vector(3 downto 0);
            we           : in  std_logic;
            ce           : in  std_logic;
            dado_saida   : out std_logic_vector(3 downto 0)
        );
    end component;

	 
	 
	 
	 
    signal great,ZeraC_baixo,igual_out,menor,great_o,menor_o,enable_cin,rco_outc: std_logic;
    signal contador_out, s_dado,s_endereco: std_logic_vector (3 downto 0);
    begin
		  
        
          ZeraC_baixo<= not ZeraC;
        Contend: contador_163 port map (
            clock => clock,
            clr => ZeraC_baixo,
            ld    => '1',
            ent   => '1',
            enp   =>enable_Cin,
            D     => "0000",
            Q     => s_endereco,
            rco   => rco_outc
        );
      enable_Cin<=contaC;
      db_contagem<=s_endereco;
        compJog: comparador_85 port map (
            i_A3  =>s_dado(3),
	          i_B3   => chaves(3),
	          i_A2   =>s_dado(2),
	          i_B2   => chaves(2),
	          i_A1   =>s_dado(1),
	          i_B1   => chaves(1),
	          i_A0   =>s_dado(0),
	          i_B0   => chaves(0),
	          i_AGTB =>'0',
	          i_ALTB => '0',
	          i_AEQB => '1',
	          -- saidas
	          o_AGTB =>great,
	          o_ALTB =>menor,
	          o_AEQB => igual_out
        );


        memoria: ram_16x4 port map(
            clk=>clock,
            endereco => s_endereco,
            dado_entrada => chaves,
            we => escreveM,
            ce => '0',
            dado_saida => s_dado
        );
        db_memoria<=s_dado;
     igual<=igual_out;
    fimC<=rco_outC;
    end architecture;


----------------------------------------------------------------
-- Arquivo   : hexa7seg.vhd
-- Projeto   : Jogo do Desafio da Memoria
----------------------------------------------------------------
-- Descricao : decodificador hexadecimal para 
--             display de 7 segmentos 
-- 
-- entrada: hexa - codigo binario de 4 bits hexadecimal
-- saida:   sseg - codigo de 7 bits para display de 7 segmentos
----------------------------------------------------------------
-- dica de uso: mapeamento para displays da placa DE0-CV
--              bit 6 mais significativo é o bit a esquerda
--              p.ex. sseg(6) -> HEX0[6] ou HEX06
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     29/12/2020  1.0     Edson Midorikawa  criacao
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity hexa7seg is
    port (
        hexa : in  std_logic_vector(3 downto 0);
        sseg : out std_logic_vector(6 downto 0)
    );
end hexa7seg;

architecture comportamental of hexa7seg is
begin

  sseg <= "1000000" when hexa="0000" else
          "1111001" when hexa="0001" else
          "0100100" when hexa="0010" else
          "0110000" when hexa="0011" else
          "0011001" when hexa="0100" else
          "0010010" when hexa="0101" else
          "0000010" when hexa="0110" else
          "1111000" when hexa="0111" else
          "0000000" when hexa="1000" else
          "0000000" when hexa="1000" else
          "0010000" when hexa="1001" else
          "0001000" when hexa="1010" else
          "0000011" when hexa="1011" else
          "1000110" when hexa="1100" else
          "0100001" when hexa="1101" else
          "0000110" when hexa="1110" else
          "0001110" when hexa="1111" else
          "1111111";

end comportamental;





library ieee;
use ieee.std_logic_1164.all;
entity circuito_exp4 is
    port(
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        chaves : in std_logic_vector (3 downto 0);
        pronto : out std_logic;
        db_igual : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria : out std_logic_vector (6 downto 0);
        db_estado : out std_logic_vector (6 downto 0)
    );
end entity;

architecture estrutural of circuito_exp4 is
    component fluxo_dados is
        port(
            clock : in std_logic;

            zeraC : in std_logic;
    
            contaC : in std_logic;
            escreveM: in std_logic;
            chaves : in std_logic_vector (3 downto 0);
            fimC: out std_logic;
            db_contagem : out std_logic_vector (3 downto 0);
            db_memoria: out std_logic_vector(3 downto 0);
    
    
            igual: out std_logic
        );
    end component;

    component unidade_controle is
        port(
            clock:     in  std_logic; 
            reset:     in  std_logic; 
            iniciar:   in  std_logic;
            fim:       in  std_logic;
            zera:      out std_logic;
            conta:     out std_logic;
            pronto:    out std_logic;
            db_estado: out std_logic_vector(3 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
        end component;
    
    signal conta4,memo4,estad4: std_logic_vector (3 downto 0);
    signal conta,fimi,zera,clk: std_logic;
    begin
        clk<=clock;
        FD: fluxo_dados port map(
            clock => clk,

            zeraC => zera,
    
            contaC => conta,
            escreveM=> '1',
            chaves => chaves,
            fimC=> fimi,
            db_contagem => conta4,
            db_memoria=> memo4,
            igual=>db_igual
        );

        UC: unidade_controle port map(
            clock=>clk, 
            reset=>reset, 
            iniciar=>iniciar,
            fim=>fimi,
            zera=> zera,     
            conta=> conta,   
            pronto=>pronto,
            db_estado=> estad4
        );

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
end architecture;

