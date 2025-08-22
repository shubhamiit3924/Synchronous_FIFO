`timescale 1ns / 1ps
module tb_fifo_priority;

// Parameters
parameter DATA_WIDTH = 16;
parameter DEPTH = 8;
parameter ADDR_WIDTH = 3;

//  Signals 
reg clk;
reg rst;
reg hp_wr_en;
reg lp_wr_en;
reg [DATA_WIDTH-1:0] hp_din;
reg [DATA_WIDTH-1:0] lp_din;
reg rd_en;
wire [DATA_WIDTH-1:0] dout;
wire hp_empty, lp_empty, hp_full, lp_full;

// Instantiate FIFO 
fifo_priority #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) uut (
    .clk(clk),
    .rst(rst),
    .hp_wr_en(hp_wr_en),
    .hp_din(hp_din),
    .lp_wr_en(lp_wr_en),
    .lp_din(lp_din),
    .rd_en(rd_en),
    .dout(dout),
    .hp_empty(hp_empty),
    .lp_empty(lp_empty),
    .hp_full(hp_full),
    .lp_full(lp_full)
);

// Clock
initial clk = 0;
always #5 clk = ~clk;  // 10ns period

// Monitor
initial begin
    $display("Time\tHP_empty\tLP_empty\tHP_full\tLP_full\tRD_EN\tDOUT");
    $monitor("%0dns\t%b\t\t%b\t\t%b\t%b\t%b\t%h", 
             $time, hp_empty, lp_empty, hp_full, lp_full, rd_en, dout);
end

//  Test Sequence 
initial begin
    // Initialize
    hp_wr_en = 0; lp_wr_en = 0; rd_en = 0; hp_din = 0; lp_din = 0; rst = 1;

    #20 rst = 0;

    // Write low-priority data
    #10 lp_din = 16'hA124; lp_wr_en = 1;
    #10 lp_din = 16'hA267;
    #10 lp_din = 16'hA3B4;
    #10 lp_wr_en = 0;

    // Write high-priority data
    #10 hp_din = 16'hB1B5; hp_wr_en = 1;
    #10 hp_din = 16'hB278;
    #10 hp_wr_en = 0;

    // Start reading
    #10 rd_en = 1;
    #10; #10; #10; #10; #10; // read 5 times
    #10 rd_en = 0;

    // Write more HP and LP data
    #10 hp_din = 16'hC1F6; hp_wr_en = 1;
    #10 hp_wr_en = 0;
    #10 lp_din = 16'hD1D1; lp_wr_en = 1;
    #10 lp_din = 16'hA222;
    #10 lp_din = 16'hA3B3;
    #10 lp_din = 16'h2224;
    #10 lp_din = 16'h33B5;
    #10 lp_din = 16'hA226;
    #10 lp_din = 16'hA3B7;
    #10 lp_din = 16'hC128;
    #10 lp_din = 16'hD9D9;
    #10 lp_din = 16'hDDDD;
    #10 lp_wr_en = 0;

    // Read remaining
    #10 rd_en = 1;
    #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10;
    #10 rd_en = 0;
    #10 lp_wr_en=1;
    #10 lp_din = 16'hDDDD;
    #10 rd_en=1;
    #10; #10;
    #20 $finish;
end

endmodule