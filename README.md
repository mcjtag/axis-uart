# axis-uart
AXI Stream UART


## Features
* Parity: None, Even, Odd, Mark, Space
* Byte Size: up to 16 bits
* Stop Bits: One, Two
* Flow Control: None, RTS/CTS
* Static and Dynamic Configuration

## Baudrate Calculation

Baudrate ~ `aclk / prescaler_value`
Example: if aclk is 100MHz, and desired baudrate is 115200, then the prescaler value must be approximately equal ~868.

## Dynamic Configuration

Use s_axis_config_* interface to dynamically configurate UART.
Bits:
* [15:0] - prescaler
* [18:16] - parity (0 - none, 1 - even, 2 - odd, 3 - mark, 4 - space)
* [22:19] - byte_size (from 1 to 16)
* [23] - stop_bits (0 - one stop, 1 - two stops)

## Component

Component created in Vivado v2018.3.