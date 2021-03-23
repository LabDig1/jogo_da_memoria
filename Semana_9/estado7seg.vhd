library ieee;
use ieee.std_logic_1164.all;

entity estado7seg is
    port (
        estado : in  std_logic_vector(4 downto 0);
        display : out std_logic_vector(6 downto 0)
    );
end estado7seg;

architecture comportamental of estado7seg is
begin

  display <= "1000000"  when estado="00000" else -- O 

  "1101111" when estado="00001"  else -- I1
  "1110111" when estado="00010"  else -- I2
  "1111011" when estado= "00011"  else -- I3
  "0111111" when estado="00100"  else -- I4
  "0100011" when estado="00101"  else -- I5

  "1001111" when estado="00110"  else -- J1
  "1010111" when estado="00111"  else -- J2
  "1011011" when estado="01000"  else -- J3
  
  "1001100" when estado="01001"  else -- Z1
  "1010100" when estado="01010"  else -- Z2
  "1011000" when estado="01011"  else -- Z3

  "1000110" when estado="01100"  else -- C
  "1000111" when estado="01101"  else --L
  "0000110" when estado="01110"  else --E
  "0001110" when estado="01111"  else --F

  "1101110" when estado="10000"  else --G1
  "1110110" when estado="10001"  else -- G2
  "1111010" when estado="10010"  else --G3
  "0111110" when estado="10011"  else --G4

 "1101101" when estado="10100"  else --R1
 "1110101" when estado="10101"  else --R2
 "1111001" when estado="10110"  else --R3
 "0111101" when estado="10111" else
 "0000000";

end comportamental;