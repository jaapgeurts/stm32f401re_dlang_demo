import stmbridge;

// https://github.com/ldc-developers/ldc/issues/3290
import ldc.attributes;
@llvmAttr("nounwind") : import ldc.llvmasm;

__gshared bool blinking = true;

void console_putc(char c)
{
    while(usart_get_flag(USART2, USART_SR_TXE) == 0)
        continue;

    usart_send(USART2,cast(short)c & 0xff);

}

void console_puts(string s)
{
    foreach(l; s)
        console_putc(l);
}

void gpio_setup()
{
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_GPIOC);

    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO5);
    gpio_mode_setup(GPIOC, GPIO_MODE_INPUT, GPIO_PUPD_NONE, GPIO13);

    // Setup serial
    // GPIO2 = TX
    // GPIO3 = RX
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO2 | GPIO3);
    gpio_set_af(GPIOA, GPIO_AF7, GPIO2 | GPIO3);
    rcc_periph_clock_enable(RCC_USART2);
    usart_set_baudrate(USART2, 9600);
	usart_set_databits(USART2, 8);
	usart_set_stopbits(USART2, USART_STOPBITS_1);
	usart_set_mode(USART2, USART_MODE_TX_RX);
	usart_set_parity(USART2, USART_PARITY_NONE);
	usart_set_flow_control(USART2, USART_FLOWCONTROL_NONE);
	usart_enable(USART2);

	console_puts("Hello world\r\n");
}

void delay(int f)
{
    int i;
    for (i = 0; i < 100000 * f; i++) /* Wait a bit. */
        __asm("nop", "");
}

extern(C) void main()
{
 //bool blinking = true;
    gpio_setup();

    while(true) {

        if (gpio_get(GPIOC, GPIO13) != GPIO13)  {
            console_puts("Button pushed\r\n");
            //gpio_toggle(GPIOA, GPIO5);
            blinking = !blinking;
        }
        console_puts( blinking ? "true\r\n" : "false\r\n");
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
