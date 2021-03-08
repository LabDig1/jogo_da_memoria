library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
  port ( 
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
end entity;

architecture fsm of unidade_controle is
  type t_estado is (A, B, C, D, E, F, M,J,L,K,W,Q,P,R,S,T,I,G,H,U,V,O,Z,X);
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
      R when Eatual=B else
      R when Eatual=R and jogada ='0' else
      S when Eatual=R and jogada ='1' else
      T when Eatual=S else
      I when Eatual=T else
      J when Eatual=I else
      J when Eatual=J and jogada='0' and timeout='0' else
      M when Eatual=J and jogada='1'and timeout='0' else
      C when Eatual=M else
      D when Eatual=C and enderecoIgualLimite='0' and igual='1' else
      F when  Eatual=C and igual='0' else
      F when Eatual=J and timeout='1'else 
      F when Eatual=Q and timeout='1' else
		L when Eatual=W else
      K when Eatual=C and enderecoIgualLimite='1' and igual='1' and fimC='0' else
		Q when Eatual=K else
		Q when Eatual=Q and jogada ='0' and timeout='0' else
      P when Eatual=Q and jogada ='1' and timeout='0' else
		W when Eatual=P else
      J when  Eatual=D else
      J when Eatual=L else
      E when  Eatual=C and FimC='1' and igual ='1' else
      O when  Eatual=E and iniciar='1' else
      E when  Eatual=E and iniciar='0' else
      O when  Eatual=F and iniciar='1' and repete='0' else
      F when  Eatual=F and iniciar='0' and repete='0'else
		X when Eatual =O else
		Z when Eatual=X and fimC='0' else
		B when Eatual =X and fimC='1' else
		X when Eatual=Z else
      G when  Eatual=F and repete='1' else
      H when Eatual=G else
      H when Eatual = H and timeout2 ='0' and fimC='0' else
		F when Eatual=H and timeout2 ='0' and fimC='1' else
      U when Eatual =H and timeout2='1' else
      V when Eatual =U else
      H when Eatual=V and chegou='0' else
      F when Eatual=V and chegou='1' else
      A;

  -- logica de saída (maquina de Moore)
  with Eatual select
    registra <= '0' when A | B | C | D | E | F | J,
              '1' when M | P | S,
              '0' when others;

  with Eatual select
    zera_T <= '1' when K | L | D | B | I,
              '0' when others;
	with Eatual select
    zera_2 <= '1' when  B | V,
              '0' when others;

  with Eatual select
    reset_m <='1' when Z | X,
              '0' when others;

  with Eatual select
    conta_T <= '1' when J | Q,
              '0' when others;
with Eatual select
    conta_2 <= '1' when H,
              '0' when others;

  with Eatual select
    espera <= '1' when Q | R,
              '0' when others;

  with Eatual select
    escreve <= '0' when A | B | C | D | E | F | J,
              '1' when W | T | X,
              '0' when others;
  
              with Eatual select

    zera <=   '0' when A | C | D | E | F | M | J,
              '1' when B | L | I | G | O,
              '0' when others;
    
  with Eatual select
    conta_end <=  '0' when A | B | C | E | F | M | J,
                  '1' when D | K | U | Z,
                  '0' when others;
  
  with Eatual select  
      conta_lim <=  '0' when A | B | C | E | F | M | J | D,
                '1' when L,
                '0' when others;

  with Eatual select
      zera_lim <=  '0' when A | C | E | F | M | J | D | L,
                   '1' when B,
                   '0' when others;

  with Eatual select
    pronto <= '0' when A | B | C | D | M | J,
              '1' when E | F | G | H | U | V,
              '0' when others;

  with Eatual select
    acertou <='0' when A | B | C | D | F | M | J,
              '1' when E,
              '0' when others;
                    
  with Eatual select
    errou <=  '0' when A | B | C | D | E | M | J,
              '1' when F | G | H | U | V,
              '0' when others;

  -- saida de depuracao (db_estado)
  with Eatual select
    db_estado <= "0000" when A,      -- 0
                 "1011" when B,      -- B
                 "1100" when C,      -- C
                 "1101" when D,      -- D
                 "1110" when E,      -- E
					  "0100" when Q, --Q,4
					  "0100" when U, --Q,4
					  "0010" when R, --R,2
					  "0010" when G,
					  "0011" when K, --K,3
					  "0011" when H, --K,3
                 "0101" when P, -- P,5
                 "0110" when W, --W,6
					  "0111" when M,-- M,7
					  "1000" when J,  -- J,8
					  "1001" when L, --L,9
					  "1111" when F,      -- F
					  "0001" when others;  -- 1 
end fsm;
