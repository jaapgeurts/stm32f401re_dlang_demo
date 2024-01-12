import core.stdc.stdio;

import stmbridge;
import io;
import clock;
import mcudruntime;
import button;

// TODO: Move to TLS
// TODO: Move to DUB
// TODO: libopencm3 headers. generate per header.
// TODO: Rethink libopencm3 headers (d++ vs dstep)
// TODO: Move to project scaffold template


enum BlinkState { FAST, SLOW }
enum FAST_INTERVAL = 100;
enum SLOW_INTERVAL = 500;

// Put variables in the global segment.
// If we need maximum performance, then move global variables into __gshared
bool blinking = true;
ubyte blinkCount = 0;
BlinkState blinkState = BlinkState.SLOW;
ulong lastTime;
Button but1 = Button(GPIOC,GPIO13);

void gpio_setup()
{
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_GPIOC);

    // Built in led
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO5);

    // Button 1
    gpio_mode_setup(GPIOC, GPIO_MODE_INPUT, GPIO_PUPD_NONE, GPIO13);

}


extern(C) void main()
{

    rt_start();

    // string a;
    // a ~= "a";
    clock_setup();
    systick_setup();

    gpio_setup();
    setupIO();

    writeln("Hello world");

    gpio_set(GPIOA, GPIO5);


    while(true) {

        if (but1.keyDown()) {
            blinking = !blinking;
            if (!blinking) {
                writeln("Off");
                gpio_clear(GPIOA, GPIO5);
            }
            else {
                writeln("On");
            }

            lastTime = system_millis + SLOW_INTERVAL;
        }
//        writeln(blinking);

       if (blinking)
            blink();

    }
}

void setled() {
    gpio_toggle(GPIOA, GPIO5);
}

void blink()
{
    if (lastTime < system_millis) {
        if (blinkState == BlinkState.FAST) {
            gpio_toggle(GPIOA, GPIO5); /* LED on/off */
            lastTime = system_millis + FAST_INTERVAL;
        }
        else {
            gpio_toggle(GPIOA, GPIO5); /* LED on/off */
            lastTime = system_millis + SLOW_INTERVAL;
        }
        blinkCount++;
        if (blinkCount > 10) {
            blinkState = (blinkState == BlinkState.FAST) ? BlinkState.SLOW : BlinkState.FAST;
            blinkCount = 0;
        }
    }

}
