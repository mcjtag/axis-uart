`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: mcjtag
// 
// Create Date: 02.10.2019 14:42:23
// Design Name: 
// Module Name: uart_tx
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

module uart_tx #(
	parameter BAUD_PRESCALER = 12,
	parameter PARITY = 0,
	parameter BYTE_SIZE = 8,
	parameter STOP_BITS = 0,
	parameter FIFO_DEPTH = 16
)
(
	/* AXI-Stream Ports */
	input wire aclk,
	input wire aresetn,
	/* Dynamic Configuration */
	input wire [23:0]s_axis_config_tdata,
	input wire s_axis_config_tvalid,
	output wire s_axis_config_tready,
	/* Data */
	input wire [15:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	/* UART Port */
	output wire txd,
	input wire ctsn 
);

localparam PARITY_NONE = 3'd0;
localparam PARITY_EVEN = 3'd1;
localparam PARITY_ODD = 3'd2;
localparam PARITY_MARK = 3'd3;
localparam PARITY_SPACE = 3'd4;

localparam STOP_BITS_ONE = 1'd0;
localparam STOP_BITS_TWO = 1'd1;

localparam STATE_IDLE = 0;
localparam STATE_START = 1;
localparam STATE_BYTE = 2;
localparam STATE_PAR = 3;
localparam STATE_STOP = 4;
localparam STATE_END = 5;

reg [3:0]state;

reg [15:0]prescaler;
reg [2:0]parity;
reg [3:0]byte_size;
reg [0:0]stop_bits;

wire [15:0]m_data;
wire m_valid;
reg m_ready;

reg [15:0]counter;

reg pre_en;
wire pre_stb;

reg [15:0]tx_data;
reg tx_par;
(* IOB = "TRUE" *) reg txd_out;

assign txd = txd_out;
assign s_axis_config_tready = (state == STATE_IDLE) ? 1'b1 : 1'b0;

/* Configuration */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		prescaler <= BAUD_PRESCALER;
		parity <= PARITY;
		byte_size <= BYTE_SIZE;
		stop_bits <= STOP_BITS;
	end else begin
		if ((s_axis_config_tvalid == 1'b1) && (s_axis_config_tready == 1'b1)) begin
			prescaler <= s_axis_config_tdata[15:0];
			parity <= s_axis_config_tdata[18:16];
			byte_size <= s_axis_config_tdata[22:19];
			stop_bits <= s_axis_config_tdata[23];
		end
	end
end

/* Out */
always @(posedge aclk) begin
	if (aresetn <= 1'b0) begin
		txd_out <= 1'b0;
	end else begin
		case (state)
		STATE_IDLE: begin
			txd_out <= 1'b1;
		end
		STATE_START: begin
			txd_out <= 1'b0;
		end
		STATE_BYTE: begin
			txd_out <= tx_data[0];
		end
		STATE_PAR: begin
			txd_out <= tx_par;
		end
		STATE_STOP: begin
			txd_out <= 1'b1;
		end
		STATE_END: begin
			txd_out <= 1'b1;
		end
		default: begin
			txd_out <= 1'b1;
		end
		endcase
	end
end

/* State Machine */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		pre_en <= 1'b0;
		m_ready <= 1'b0;
		tx_data <= 0;
		counter <= 0;
	end else begin
		case (state)
		STATE_IDLE: begin
			if (m_ready == 1'b0) begin
				if (ctsn == 1'b0) begin
					m_ready <= 1'b1;
				end
			end else begin
				if (m_valid == 1'b1) begin
					m_ready <= 1'b0;
					tx_data <= m_data;
					counter <= 0;
					pre_en <= 1'b1;
					state <= STATE_START;
				end
			end
		end
		STATE_START: begin
			if (pre_stb == 1'b1) begin
				state <= STATE_BYTE;
			end
		end
		STATE_BYTE: begin
			if (pre_stb == 1'b1) begin
				tx_data[14:0] <= tx_data[15:1];
				if (counter == (byte_size - 1)) begin
					counter <= 0;
					if (parity == PARITY_NONE) begin
						state <= STATE_STOP;
					end else begin
						state <= STATE_PAR;
					end
				end else begin
					counter <= counter + 1;
				end
			end
		end
		STATE_PAR: begin
			if (pre_stb == 1'b1) begin
				state <= STATE_STOP;
			end
		end
		STATE_STOP: begin
			if (pre_stb == 1'b1) begin
				case (stop_bits)
				STOP_BITS_ONE: begin
					state <= STATE_END;
				end
				STOP_BITS_TWO: begin
					if (counter == 1) begin
						counter <= 0;
						state <= STATE_END;
					end else begin
						counter <= counter + 1;
					end
				end
				endcase
			end
		end
		STATE_END: begin
			if (m_ready == 1'b0) begin
				pre_en <= 1'b0;
				m_ready <= 1'b1;
			end else begin
				m_ready <= 1'b0;
				if (m_valid == 1'b1) begin
					tx_data <= m_data;
					pre_en <= 1'b1;
					state <= STATE_START;
				end else begin
					state <= STATE_IDLE;
				end
			end
		end
		default: begin
			state <= STATE_IDLE;
		end		
		endcase
	end
end

/* Parity Calculation */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		tx_par <= 1'b0;
	end else begin
		case (state)
		STATE_BYTE: begin
			case (parity)
			PARITY_EVEN: tx_par <= tx_par + tx_data[0];
			PARITY_ODD: tx_par <= tx_par + tx_data[0];
			default: tx_par <= tx_par;
			endcase
		end
		STATE_PAR: begin
			tx_par <= tx_par;
		end
		default: begin
			case (parity)
			PARITY_EVEN: tx_par <= 1'b0;
			PARITY_ODD: tx_par <= 1'b1;
			PARITY_MARK: tx_par <= 1'b1;
			PARITY_SPACE: tx_par <= 1'b0;
			endcase
		end
		endcase
	end
end

uart_fifo #(
	.DATA_WIDTH(16),
	.DATA_DEPTH(FIFO_DEPTH)
) fifo_sync_inst (
	.aclk(aclk),
	.aresetn(aresetn),
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tvalid(s_axis_tvalid),
	.s_axis_tready(s_axis_tready),
	.m_axis_tdata(m_data),
	.m_axis_tvalid(m_valid),
	.m_axis_tready(m_ready)
);

uart_prescaler prescaler_inst (
	.clk(aclk),
	.rst(~aresetn),
	.en(pre_en),
	.div(prescaler),	
	.stb(pre_stb)
);

endmodule
