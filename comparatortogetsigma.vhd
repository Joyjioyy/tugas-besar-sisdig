library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity comparator is
    Port (
        Parameter       : in  signed(7 downto 0); -- Bilangan yang akan dikomparisasi
        Result  : out std_logic -- Hasil operasi Q3.13 ((1 sign, 2 integer, 13 fraction dengan asumsi input di rentang -1 sampai 1)
    );
end comparator;

architecture Behavioral of comparator is
begin

    Result <= not(Parameter(7));
    -- process(Parameter)
    -- begin
    --     if Parameter(7) = '0' then -- jika bilangan positif
    --         Result <= '1';
    --     else
    --         -- Jika bilangan negatif
    --         Result <= '0';
    --     end if;
    -- end process;
end Behavioral;
