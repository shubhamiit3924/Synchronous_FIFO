`timescale 1ns / 1ps

module sync_fifo_tb;
    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = 4;

    // Signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full;
    wire empty;

    // DUT
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $monitor($time, " rst=%b, wr_en=%b, rd_en=%b, din=%d, dout=%d, full=%b, empty=%b", 
                 rst, wr_en, rd_en, din, dout, full, empty);
        
        // Initialize
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        
        // Release reset
        #10 rst = 0;
        
        // Write some values
        #10 wr_en = 1; din = 10;
        #10 din = 20;
        #10 din = 30;
        #10 din = 40;
        #10 wr_en = 0;
        
        // Read values
        #10 rd_en = 1;
        #10;
        #10;
        #10;
        #10 rd_en = 0;
        
        // Write in memory
        #10 wr_en = 1; din = 50;
        #10 din = 60;
        #10 din = 70;
        #10 din = 80;
        #10 din = 90;
        #10 din = 100;
        #10 din = 110;
        #10 din = 120;
        #10 din = 130;
        #10 din = 140;
        #10 din = 150;
        #10 din = 160;
        #10 wr_en = 0;
        
        // Read until empty
        #10 rd_en = 1;
        #160;
        #20;
        #10 rd_en=0;
        
        #10 $finish;
    end
endmodule