ENTRY(_binary_tee_rk3566_bin_start);

SECTIONS
{
        . = 0x08400000;
        .data : {
                *(.data)
        }
}
