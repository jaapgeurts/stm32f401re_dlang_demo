import core.stdc.stdio;

import stmbridge;
import io;

// https://github.com/ldc-developers/ldc/issues/3290
import ldc.attributes;
@llvmAttr("nounwind") : import ldc.llvmasm;

__gshared bool blinking = true;


void gpio_setup()
{
    rcc_periph_clock_enable(RCC_GPIOC);

    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO5);
    gpio_mode_setup(GPIOC, GPIO_MODE_INPUT, GPIO_PUPD_NONE, GPIO13);

}

void delay(int f)
{
    int i;
    for (i = 0; i < 100000 * f; i++) /* Wait a bit. */
        __asm("nop", "");
}

extern(C) void main()
{

    gpio_setup();
    setupIO();

    writeln("Hello world");

    while(true) {

        if (gpio_get(GPIOC, GPIO13) != GPIO13)  {
            writeln("Button pushed");
            //gpio_toggle(GPIOA, GPIO5);
            blinking = !blinking;
        }
        writeln(blinking);

        // ulong value = cast(ulong)&blinking;
        //
        // string hexChars = "0123456789ABCDEF";
        // char[40] result = "0x\0";
        //
        // int j = 2;
        // for (int i = value.sizeof * 2 - 1; i >= 0; --i) {
        //     result[j] = hexChars[(value >> (i * 4)) & 0xF];
        //     j++;
        // }
        // result[j] = 0;
        // console_puts(result);
        // console_puts("\r\n");

       if (blinking)
            setled();

        delay(2);
        //console_puts("Button pushed");
    }
}
void setled() {
    gpio_toggle(GPIOA, GPIO5);
}

void blink()
{
    foreach (i; 0 ..20) {
        gpio_toggle(GPIOA, GPIO5); /* LED on/off */
        delay(4);
    }
    foreach (i; 0 ..10) {
        gpio_toggle(GPIOA, GPIO5); /* LED on/off */
        delay(8);
    }
}
