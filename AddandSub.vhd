library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity AddSub is
    Port (
        A       : in  signed(15 downto 0); -- Bilangan yang akan dikurangi atau ditambah
        B       : in  signed(15 downto 0); -- Bilangan yang akan mengurangi atau menambah (didapat dari fungsi cordic)
        add_sub : in  std_logic;           -- Kontrol: '0' untuk penjumlahan, '1' untuk pengurangan. Ini nanti didapat dari hasil komparator
        Result  : out signed(15 downto 0) -- Hasil operasi Q3.13 ((1 sign, 2 integer, 13 fraction dengan asumsi input di rentang -1 sampai 1)
    );

    -- Catatan input 1 sign 2 integer 5 fraction. Input maksimal bernilai dari -1 sampai 1
end AddSub;

architecture Behavioral of AddSub is
    -- signal temp_result : signed(7 downto 0); --- Tambahin satu bit di depan buat jaga-jaga overflow dulu
begin

    process(A, B, add_sub)
    begin
        if add_sub = '0' then
            -- Penjumlahan
            Result <= A+B;
            -- resize menambahkan satu bit 0 MSB (tidak mengubah nilai, hanya memperluas rentang jadi 17 bit)
        else
            -- Pengurangan
            Result <= A-B;
        end if;
    end process;

end Behavioral;
