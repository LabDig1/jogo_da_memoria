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


library ieee;
use ieee.std_logic_1164.all;

entity circuito_exp2 is
    port (
        clock : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        chaves : in std_logic_vector (3 downto 0);
        igual : out std_logic;
		  maior_igual : out std_logic;
        db_contagem : out std_logic_vector (3 downto 0)
    );
end entity circuito_exp2;

architecture estrutural of circuito_exp2 is
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
    signal rco_out, great,enable_in, reset_baixo,igual_out,menor: std_logic;
    signal contador_out : std_logic_vector (3 downto 0);
    begin
		  reset_baixo<=reset;
        contador: contador_163 port map (
            clock => clock,
            clr => not reset_baixo,
            ld    => '1',
            ent   => enable_in,
            enp   =>enable_in,
            D     => "0000",
            Q     => contador_out,
            rco   => rco_out
        );
		  enable_in<=enable;
		  db_contagem <= contador_out;
        comparador: comparador_85 port map (
            i_A3  =>contador_out(3),
	    i_B3   => chaves(3),
	    i_A2   =>contador_out(2),
	    i_B2   => chaves(2),
	    i_A1   =>contador_out(1),
	    i_B1   => chaves(1),
	    i_A0   =>contador_out(0),
	    i_B0   => chaves(0),
	    i_AGTB =>'0',
	    i_ALTB => '0',
	    i_AEQB => '1',
	    -- saidas
	    o_AGTB =>great,
	    o_ALTB =>menor,
	    o_AEQB => igual_out
        );
		  maior_igual<=great or igual_out;
		 igual<=igual_out;
    end architecture;
