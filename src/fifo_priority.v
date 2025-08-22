`timescale 1ns / 1ps
module fifo_priority #(
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = 3   // log2(DEPTH)
)(
    input wire clk,
    input wire rst,
    // High-priority write
    input wire hp_wr_en,
    input wire [DATA_WIDTH-1:0] hp_din,
    // Low-priority write
    input wire lp_wr_en,
    input wire [DATA_WIDTH-1:0] lp_din,
    // Single read interface
    input wire rd_en,
    output reg [DATA_WIDTH-1:0] dout,
    // Other  signals
    output wire hp_empty,
    output wire lp_empty,
    output wire hp_full,
    output wire lp_full
);

// Internal Memory
reg [DATA_WIDTH-1:0] hp_mem [0:DEPTH-1];
reg [DATA_WIDTH-1:0] lp_mem [0:DEPTH-1];

// Pointers with extra MSB 
reg [ADDR_WIDTH:0] hp_wr_ptr;
reg [ADDR_WIDTH:0] hp_rd_ptr;
reg [ADDR_WIDTH:0] lp_wr_ptr;
reg [ADDR_WIDTH:0] lp_rd_ptr;

// Write Logic

// High-priority write
always @(posedge clk) begin
    if (rst) begin
        hp_wr_ptr <= 0;
    end else if (hp_wr_en && !hp_full) begin
        hp_mem[hp_wr_ptr[ADDR_WIDTH-1:0]] <= hp_din;
        hp_wr_ptr <= hp_wr_ptr + 1;
    end
end

// Low-priority write
always @(posedge clk) begin
    if (rst) begin
        lp_wr_ptr <= 0;
    end else if (lp_wr_en && !lp_full) begin
        lp_mem[lp_wr_ptr[ADDR_WIDTH-1:0]] <= lp_din;
        lp_wr_ptr <= lp_wr_ptr + 1;
    end
end

//  Read Logic 
always @(posedge clk) begin
    if (rst) begin
        dout <= 0;
        hp_rd_ptr <= 0;
        lp_rd_ptr <= 0;
    end else if (rd_en) begin
        if (!hp_empty) begin
            // Read from high-priority FIFO
            dout <= hp_mem[hp_rd_ptr[ADDR_WIDTH-1:0]];
            hp_rd_ptr <= hp_rd_ptr + 1;
        end else if (!lp_empty) begin
            // Read from low-priority FIFO
            dout <= lp_mem[lp_rd_ptr[ADDR_WIDTH-1:0]];
            lp_rd_ptr <= lp_rd_ptr + 1;
        end
    end
end

// Empty/Full 
// Empty condition: write pointer equals read pointer
assign hp_empty = (hp_wr_ptr == hp_rd_ptr);
assign lp_empty = (lp_wr_ptr == lp_rd_ptr);

// Full condition: address bits equal but MSBs differ
assign hp_full = (hp_wr_ptr[ADDR_WIDTH] != hp_rd_ptr[ADDR_WIDTH]) && 
                 (hp_wr_ptr[ADDR_WIDTH-1:0] == hp_rd_ptr[ADDR_WIDTH-1:0]);
assign lp_full = (lp_wr_ptr[ADDR_WIDTH] != lp_rd_ptr[ADDR_WIDTH]) && 
                 (lp_wr_ptr[ADDR_WIDTH-1:0] == lp_rd_ptr[ADDR_WIDTH-1:0]);

endmodule