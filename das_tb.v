`timescale 1ns/1ps
module das_tb;
    localparam N_CH=4, DATA_W=16, MAX_DELAY=16, ADDR_W=4, OUT_W=DATA_W+2;
    reg clk=0, rst_n=0, in_valid=0;
    reg  [N_CH*DATA_W-1:0] in_data=0;
    reg  [N_CH*ADDR_W-1:0] in_delays;
    wire out_valid; wire signed [OUT_W-1:0] out_data;
    integer n;

    das_top #(.N_CH(N_CH),.DATA_W(DATA_W),.MAX_DELAY(MAX_DELAY)) dut (
        .clk(clk),.rst_n(rst_n),.in_valid(in_valid),.in_data(in_data),
        .in_delays(in_delays),.out_valid(out_valid),.out_data(out_data));

    always #5 clk = ~clk; // 100 MHz

    initial begin
        $dumpfile("das.vcd"); $dumpvars(0, das_tb);
        in_delays = {4'd3, 4'd2, 4'd1, 4'd0};
        #20 rst_n = 1;
        for (n = 0; n < 40; n = n + 1) begin
            @(posedge clk); in_valid <= 1;
            in_data <= {4{n[DATA_W-1:0]}};
        end
        @(posedge clk); in_valid <= 0;
        #50 $finish;
    end
    always @(posedge clk) if (out_valid) $display("t=%0t out=%0d", $time, out_data);
endmodule
