// Per-channel programmable delay line (circular buffer)
module das_channel_delay #(
    parameter DATA_W    = 16,
    parameter MAX_DELAY = 256,
    parameter ADDR_W    = $clog2(MAX_DELAY)
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     en,
    input  wire [ADDR_W-1:0]        delay,
    input  wire signed [DATA_W-1:0] din,
    output reg  signed [DATA_W-1:0] dout
);
    reg signed [DATA_W-1:0] mem [0:MAX_DELAY-1];
    reg [ADDR_W-1:0] wr_ptr;
    wire [ADDR_W-1:0] rd_ptr = wr_ptr - delay;

    always @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            dout   <= 0;
        end else if (en) begin
            mem[wr_ptr] <= din;
            wr_ptr      <= wr_ptr + 1'b1;
            dout        <= (delay == 0) ? din : mem[rd_ptr];
        end
    end
endmodule
