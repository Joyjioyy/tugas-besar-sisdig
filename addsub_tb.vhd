library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;

entity addsub_tb is
-- Testbench tidak memiliki port
end addsub_tb;

architecture Behavioral of addsub_tb is

    -- Komponen untuk Unit Under Test (UUT)
    component addsub
        Port (
            A       : in  signed(15 downto 0); -- Mengganti rentang indeks
            B       : in  signed(15 downto 0);
            add_sub : in  std_logic;
            Result  : out signed(15 downto 0)
        );
    end component;

    -- Sinyal untuk menghubungkan ke UUT
    signal A       : signed(15 downto 0) := (others => '0');
    signal B       : signed(15 downto 0) := (others => '0');
    signal add_sub : std_logic := '0';
    signal Result  : signed(15 downto 0);

begin

    -- Instansiasi UUT
    UUT: AddSub
        Port map (
            A => A,
            B => B,
            add_sub => add_sub,
            Result => Result
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Tes 1: Penjumlahan sederhana
        A <= to_signed(2048, 16); -- 0.5 dalam Q3.13
        B <= to_signed(1024, 16); -- 0.25 dalam Q3.13
        add_sub <= '0';
        wait for 10 ns;

        -- Tes 2: Pengurangan sederhana
        A <= to_signed(2048, 16); -- 0.5 dalam Q3.13
        B <= to_signed(1024, 16); -- 0.25 dalam Q3.13
        add_sub <= '1';
        wait for 10 ns;

        -- Tes 3: Overflow pada penjumlahan
        A <= to_signed(4096, 16); -- 1.0 dalam Q3.13
        B <= to_signed(4096, 16); -- 1.0 dalam Q3.13
        add_sub <= '0';
        wait for 10 ns;

        -- Tes 4: Underflow pada pengurangan
        A <= to_signed(-4096, 16); -- -1.0 dalam Q3.13
        B <= to_signed(4096, 16);  -- 1.0 dalam Q3.13
        add_sub <= '1';
        wait for 10 ns;

        -- Tes selesai
        wait;
    end process;

end Behavioral;
