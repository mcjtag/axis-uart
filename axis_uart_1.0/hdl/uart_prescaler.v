`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: mcjtag
// 
// Create Date: 03.10.2019 14:24:13
// Design Name: 
// Module Name: uart_prescaler
// Project Name: axis_uart
// Target Devices: All
// Tool Versions: 2018.3
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_prescaler
(
	input wire clk,
	input wire rst,
	input wire en,
	input wire [15:0]div,
	output wire stb,
	output wire half
);

reg [15:0]cnt;
reg stb_out;
reg half_out;

assign stb = stb_out;
assign half = half_out;

always @(posedge clk) begin
	if (rst == 1'b1) begin
		cnt <= 0;
	end else begin
		if (en == 1'b1) begin
			if (cnt == (div - 1)) begin
				cnt <= 0;
			end else begin
				cnt <= cnt + 1;
			end 
		end else begin
			cnt <= 0;
		end
	end
end

always @(*) begin
	if (rst == 1'b1) begin
		stb_out <= 1'b0;
	end else begin
		stb_out <= (cnt == (div - 1)) ? 1'b1 : 1'b0;
	end
end

always @(*) begin
	if (rst == 1'b1) begin
		half_out <= 1'b0;
	end else begin
		half_out <= (cnt == ({1'b0,div[15:1]} - 1)) ? 1'b1 : 1'b0;
	end
end

endmodule
