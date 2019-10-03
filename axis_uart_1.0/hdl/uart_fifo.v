`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: mcjtag
// 
// Create Date: 03.10.2019 14:19:09
// Design Name: 
// Module Name: uart_fifo
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

module uart_fifo #(
	parameter DATA_WIDTH = 8,
	parameter DATA_DEPTH = 8
)
(
	input wire aclk,
	input wire aresetn,
	input wire [DATA_WIDTH-1:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	output wire [DATA_WIDTH-1:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire almost_empty,
	output wire almost_full
);

function integer clogb2;
    input [31:0]value;
    begin
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
    end
endfunction

localparam RWIDTH = clogb2(DATA_DEPTH);
localparam CWIDTH = RWIDTH+1;

reg [DATA_WIDTH-1:0]data[DATA_DEPTH-1:0];
reg [RWIDTH-1:0]head;
reg [RWIDTH-1:0]tail;
reg [CWIDTH-1:0]count;

reg tready;
reg [DATA_WIDTH-1:0]tdata;
reg tvalid;

reg aempty;
reg afull;

wire wr_valid;
wire rd_valid;

integer i;

assign s_axis_tready = tready;
assign m_axis_tdata = tdata;
assign m_axis_tvalid = tvalid;

assign wr_valid = s_axis_tvalid & s_axis_tready;
assign rd_valid = m_axis_tvalid & m_axis_tready;

assign almost_empty = aempty;
assign almost_full = afull; 

always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		for (i = 0; i < DATA_DEPTH-1; i = i + 1) begin
			data[i] <= 0;
		end
		head <= 0;
		tail <= 0;
		count <= 0;
	end else begin
		case ({wr_valid,rd_valid})
		2'b00: begin
			head <= head;
			tail <= tail;
			count <= count;
		end
		2'b01: begin
			head <= head;
			tail <= tail + 1;
			count <= count - 1;
		end
		2'b10: begin
			data[head] <= s_axis_tdata;
			head <= head + 1;
			tail <= tail;
			count <= count + 1;
		end
		2'b11: begin
			data[head] <= s_axis_tdata;
			head <= head + 1;
			tail <= tail + 1;
			count <= count;
		end
		endcase
	end
end

always @(*) begin
	if (aresetn == 1'b0) begin
		tready <= 1'b0;
		tdata <= 0;
		tvalid <= 1'b0;
	end else begin
		tready <= (count < DATA_DEPTH) ? 1'b1 : 1'b0;
		tdata <= data[tail];
		tvalid <= (count > 0) ? 1'b1 : 1'b0;
	end
end

always @(*) begin
	if (aresetn == 1'b0) begin
		aempty <= 1'b0;
		afull <= 1'b0;
	end else begin
		aempty <= (count <= 1) ? 1'b1 : 1'b0;
		afull <= (count >= (DATA_DEPTH - 1)) ? 1'b1 : 1'b0;
	end
end

endmodule
