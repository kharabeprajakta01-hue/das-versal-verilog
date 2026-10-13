// DAS (Delay-And-Sum) - high speed data processing core
// Target: AMD/Xilinx Versal | Implemented in Verilog
module das_top #(
    parameter N_CH      = 8,
    parameter DATA_W    = 16,
    parameter MAX_DELAY = 256,
    parameter ADDR_W    = $clog2(MAX_DELAY),
    parameter OUT_W     = DATA_W + $clog2(N_CH)
)(
    input  wire                            clk,
    input  wire                            rst_n,
    input  wire                            in_valid,
    input  wire [N_CH*DATA_W-1:0]          in_data,    // packed channels
    input  wire [N_CH*ADDR_W-1:0]          in_delays,  // per-channel delay (samples)
    output reg                             out_valid,
    output reg  signed [OUT_W-1:0]         out_data
);
    wire signed [DATA_W-1:0] delayed [0:N_CH-1];
    genvar i;
    generate
        for (i = 0; i < N_CH; i = i + 1) begin : g_ch
            das_channel_delay #(.DATA_W(DATA_W), .MAX_DELAY(MAX_DELAY)) u_dly (
                .clk(clk), .rst_n(rst_n), .en(in_valid),
                .delay(in_delays[i*ADDR_W +: ADDR_W]),
                .din(in_data[i*DATA_W +: DATA_W]),
                .dout(delayed[i])
            );
        end
    endgenerate

    integer k;
    reg signed [OUT_W-1:0] acc;
    always @* begin
        acc = 0;
        for (k = 0; k < N_CH; k = k + 1) acc = acc + delayed[k];
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            out_valid <= 1'b0;
            out_data  <= 0;
        end else begin
            out_valid <= in_valid;
            if (in_valid) out_data <= acc;
        end
    end
endmodule
