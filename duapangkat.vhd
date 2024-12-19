library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity duaPangkat is
    Port (
        i       : in  signed(15 downto 0); -- Index
        keluaran: out  signed(15 downto 0) -- Bilangan yang akan mengurangi atau menambah (didapat dari fungsi cordic)
    );

end duaPangkat;

architecture Behavioral of duaPangkat is
    begin
        process(i)
        begin
            case i is
                when "0000" => keluaran <= "0010000000000000";
                when "0001" => keluaran <= "0001000000000000";
                when "0010" => keluaran <= "0000100000000000";
                when "0011" => keluaran <= "0000010000000000";
                when "0100" => keluaran <= "0000001000000000";
                when "0101" => keluaran <= "0000000100000000";
                when "0110" => keluaran <= "0000000010000000";
                when "0111" => keluaran <= "0000000001000000";
                when "1000" => keluaran <= "0000000000100000";
                when "1001" => keluaran <= "0000000000010000";
                when "1010" => keluaran <= "0000000000001000";
                when "1011" => keluaran <= "0000000000000100";
                when "1100" => keluaran <= "0000000000000010";
                when "1101" => keluaran <= "0000000000000001";
            end case;
        end process;
end Behavioral;
