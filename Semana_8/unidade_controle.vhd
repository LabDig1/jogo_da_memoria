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
    chegou: in std_logic
  );
end entity;

architecture fsm of unidade_controle is
  type t_estado is (O, I1,I2,I3,I4,I5, J1,J2,J3 , C,  E,F,  L, G1,G2,G3,G4 ,R1,R2,R3,R4 ,Z1,Z2,Z3);
  signal Eatual, Eprox: t_estado;
begin
  -- memoria de estado
  process (clock,reset)
  begin
    if reset='1' then
      Eatual <= O;
    elsif clock'event and clock = '1' then
      Eatual <= Eprox; 
    end if;
  end process;

  -- logica de proximo estado
  Eprox <=
      O when  Eatual=O and iniciar='0' else
      I1 when  Eatual=O and iniciar='1' else
      I2 when Eatual=I1 else
      I2 when Eatual=I2 and jogada ='0' else
      I3 when Eatual=I2 and jogada ='1' else
      I4 when Eatual=I3 else
      I5 when Eatual=I4 else
      J1 when Eatual=I5 else
      J1 when Eatual=J1 and jogada='0' and timeout='0' else
      J2 when Eatual=J1 and jogada='1'and timeout='0' else
      C when Eatual=J2 else
      J3 when Eatual=C and enderecoIgualLimite='0' and igual='1' else
      F when  Eatual=C and igual='0' else
      F when Eatual=J1 and timeout='1'else 
      F when Eatual=G2 and timeout='1' else
		L when Eatual=G4 else
      G1 when Eatual=C and enderecoIgualLimite='1' and igual='1' and fimC='0' else
		G2 when Eatual=G1 else
		G2 when Eatual=G2 and jogada ='0' and timeout='0' else
      G3 when Eatual=G2 and jogada ='1' and timeout='0' else
		G4 when Eatual=G3 else
      J1 when  Eatual=J3 else
      J1 when Eatual=L else
      E when  Eatual=C and FimC='1' and igual ='1' else
      Z1 when  Eatual=E and iniciar='1' else
      E when  Eatual=E and iniciar='0' else
      Z1 when  Eatual=F and iniciar='1' and repete='0' else
      F when  Eatual=F and iniciar='0' and repete='0'else
		Z2 when Eatual =Z1 else
		Z3 when Eatual=Z2 and fimC='0' else
		I1 when Eatual =Z2 and fimC='1' else
		Z2 when Eatual=Z3 else
      R1 when  Eatual=F and repete='1' else
      R2 when Eatual=R1 else
      R2 when Eatual = R2 and timeout2 ='0' and fimC='0' else
		F when Eatual=R2 and timeout2 ='0' and fimC='1' else
      R3 when Eatual =R2 and timeout2='1' else
      R4 when Eatual =R3 else
      R2 when Eatual=R4 and chegou='0' else
      F when Eatual=R4 and chegou='1' else
      O;

  -- logica de saída (maquina de Moore)
  with Eatual select
    registra <= '0' when O | I1 | C | J3 | E | F | J1,
              '1' when J2 | G3 | I3,
              '0' when others;

  with Eatual select
    zera_T <= '1' when G1 | L | J3 | I1 | I5,
              '0' when others;
	with Eatual select
    zera_2 <= '1' when  I1 | R4 | R1,
              '0' when others;

  with Eatual select
    reset_m <='1' when Z3 | Z2,
              '0' when others;

  with Eatual select
    conta_T <= '1' when J1 | G2,
              '0' when others;
with Eatual select
    conta_2 <= '1' when R2,
              '0' when others;

  with Eatual select
    espera <= '1' when G2 | I2,
              '0' when others;

  with Eatual select
    escreve <= '0' when O | I1 | C | J3 | E | F | J1,
              '1' when G4 | I4 | Z2,
              '0' when others;
  
              with Eatual select

    zera <=   '0' when O | C | J3 | E | F | J2 | J1,
              '1' when I1 | L | I5 | R1 | Z1,
              '0' when others;
    
  with Eatual select
    conta_end <=  '0' when O | I1 | C | E | F | J2 | J1,
                  '1' when J3 | G1 | R3 | Z3,
                  '0' when others;
  
  with Eatual select  
      conta_lim <=  '0' when O | I1 | C | E | F | J2 | J1 | J3,
                '1' when L,
                '0' when others;

  with Eatual select
      zera_lim <=  '0' when O | C | E | F | J2 | J1 | J3 | L,
                   '1' when I1,
                   '0' when others;

  with Eatual select
    pronto <= '0' when O | I1 | C | J3 | J2 | J1,
              '1' when E | F | R1 | R2 | R3 | R4,
              '0' when others;

  with Eatual select
    acertou <='0' when O | I1 | C | J3 | F | J2 | J1,
              '1' when E,
              '0' when others;
                    
  with Eatual select
    errou <=  '0' when O | I1 | C | J3 | E | J2 | J1,
              '1' when F | R1 | R2 | R3 | R4,
              '0' when others;

  -- saida de depuracao (db_estado)
  with Eatual select
    db_estado <= "00000" when O,  

                 "00001" when I1, 
                 "00010" when I2, 
                 "00011" when I3,
                 "00100" when I4,
                 "00101" when I5,

                 "00110" when J1,
                 "00111" when J2,
                 "01000" when J3,
                 
                 "01001" when Z1,
                 "01010" when Z2,
                 "01011" when Z3,

                 "01100" when C,
                 "01101" when L,
                 "01110" when E,
                 "01111" when F,

                 "10000" when G1,
                 "10001" when G2,
                 "10010" when G3,
                 "10011" when G4,

                 "10100" when R1,
                 "10101" when R2,
                 "10110" when R3,
                 "10111" when R4,
                 "11111" when others;


end fsm;
