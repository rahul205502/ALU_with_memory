
module top_module (
    // ALU i/p
    input  wire [07:0] A,
    input  wire [07:0] B,
    input  wire [02:0] opcode,
    
    // memory i/p and o/p
    input  wire        clk,
    input  wire        rst,
    input  wire        write_en,
    input  wire        read_addr_en,
    input  wire [04:0] read_addr,
    output wire [28:0] data_out,
    output wire [04:0] maxfilled_addr
);

wire [07:0] Y;
wire        c;
wire        zero_flag;

ALU #(8) alu1 (.A(A), .B(B), .opcode(opcode),
               .Y(Y), .c(c), .zero_flag(zero_flag));
               
memory m1 (.clk (clk), .rst (rst), 
           .data_in ({A, B, opcode, Y, c, zero_flag}),
           .write_en (write_en),
           .read_addr_en (read_addr_en),
           .read_addr (read_addr),
           .data_out (data_out),
           .maxfilled_addr (maxfilled_addr) );
           
endmodule