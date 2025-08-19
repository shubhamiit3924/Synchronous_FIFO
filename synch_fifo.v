module sync_fifo #(
    //set parameters acccording to requirement
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4   //log2(depth)
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 wr_en,
    input  wire                 rd_en,
    input  wire [DATA_WIDTH-1:0] din,
    output reg  [DATA_WIDTH-1:0] dout,
    output wire                 full,
    output wire                 empty
);

    // memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // pointers with extra MSB
    reg [ADDR_WIDTH:0] wr_ptr; // ADDR_WIDTH+1 bits
    reg [ADDR_WIDTH:0] rd_ptr;

    // write logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // read logic 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            dout   <= 0;
        end else if (rd_en && !empty) begin
            dout   <= mem[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1;
        //when read is not enabled
        end else begin
            dout   <= 0;
        end
    end

    // empty condition: pointers equal
    assign empty = (wr_ptr == rd_ptr);

    // full condition: addr bits equal but MSBs differ
    assign full = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&(wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

endmodule


