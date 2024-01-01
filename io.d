module io;

import stmbridge;

void setupIO() {

    // Setup serial
    rcc_periph_clock_enable(RCC_GPIOA);

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
}

void write_uart(char c)
{
    while(usart_get_flag(USART2, USART_SR_TXE) == 0)
        continue;

    usart_send(USART2,cast(short)c & 0xff);

}

void write_uart(string s)
{
    foreach(l; s) {
        write_uart(l);
    }
}

void writeln(S...)(S args)
{
    write(args, '\r', '\n');
}

enum bool isBoolean(T) = __traits(isUnsigned, T) && is(T : bool);
enum bool isSomeString(T) = is(immutable T == immutable C[], C) && (is(C == char) || is(C == wchar) || is(C == dchar));
template isIntegral(T)
{
    static if (!__traits(isIntegral, T))
        enum isIntegral = false;
    else static if (is(T U == enum))
        enum isIntegral = isIntegral!U;
    else
        enum isIntegral = __traits(isZeroInit, T) // Not char, wchar, or dchar.
            && !is(immutable T == immutable bool) && !is(T == __vector);
}

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

string toString(T)(T arg) {
    return "TODO 1";
}

void write(T...)(T args) {
    foreach (arg; args)
    {
        alias A = typeof(arg);

        static if (isSomeString!A)
        {
            write_uart(arg);
        }
        else static if (isIntegral!A) {
            write_uart(toString(arg));
        }
        else static if (isBoolean!A)
        {
            write_uart(arg ? "true" : "false");
        }
        else {
        // TODO: add other types such as char
            write_uart(arg);
        }
    }
}
