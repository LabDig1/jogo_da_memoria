library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
  port ( 
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
    igual: in std_logic;
    escreve: out std_logic
  );
end entity;

architecture fsm of unidade_controle is
  type t_estado is (A, B, C, D, E, F, M,J,L,K,W,Q,P);
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
      J when Eatual=B else
      J when Eatual=J and jogada='0' else
      M when Eatual=J and jogada='1' else
      C when Eatual=M else
      D when Eatual=C and enderecoIgualLimite='0' and igual='1' else
      F when  Eatual=C and igual='0' else
		L when Eatual=W else
      K when Eatual=C and enderecoIgualLimite='1' and igual='1' and fimC='0' else
		Q when Eatual=K else
		Q when Eatual=Q and jogada ='0' else
      P when Eatual=Q and jogada ='1' else
		W when Eatual=P else
      J when  Eatual=D else
      J when Eatual=L else
      E when  Eatual=C and FimC='1' and igual ='1' else
      B when  Eatual=E and iniciar='1' else
      E when  Eatual=E and iniciar='0' else
      B when  Eatual=F and iniciar='1'else
      F when  Eatual=F and iniciar='0' else
      A;

  -- logica de saída (maquina de Moore)
  with Eatual select
    registra <= '0' when A | B | C | D | E | F | J,
              '1' when M | P,
              '0' when others;
  
  with Eatual select
    escreve <= '0' when A | B | C | D | E | F | J,
              '1' when W,
              '0' when others;
  
              with Eatual select

    zera <=   '0' when A | C | D | E | F | M | J,
              '1' when B | L,
              '0' when others;
  
  with Eatual select
    conta_end <=  '0' when A | B | C | E | F | M | J,
              '1' when D | K,
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
              '1' when E | F ,
              '0' when others;

  with Eatual select
    acertou <='0' when A | B | C | D | F | M | J,
              '1' when E,
              '0' when others;
                    
  with Eatual select
    errou <=  '0' when A | B | C | D | E | M | J,
              '1' when F,
              '0' when others;

  -- saida de depuracao (db_estado)
  with Eatual select
    db_estado <= "0000" when A,      -- 0
                 "1011" when B,      -- B
                 "1100" when C,      -- C
                 "1101" when D,      -- D
                 "1110" when E,      -- E
					  "0100" when Q, --Q,4
					  "0011" when K, --K,3
                 "0101" when P, -- P,5
                 "0110" when W, --W,6
					  "0111" when M,-- M,7
            "1000" when J,  -- J,8
            "1001" when L, --L,9
            "1111" when F,      -- F
            "0001" when others;  -- 1 
end fsm;
