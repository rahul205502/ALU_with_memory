`timescale 1ns / 1ps

module memory_tb ();
reg         clk;
reg         rst;
reg  [28:0] data_in;
reg         write_en;
reg  [04:0] read_addr;
reg         read_addr_en;
wire [28:0] data_out;
wire [04:0] maxfilled_addr;

integer i;
memory dut (clk, rst, data_in, write_en, read_addr, read_addr_en, data_out, maxfilled_addr);

always #5 clk = ~clk;
initial begin
    clk=1'b0;
    rst=1'b0; #10; rst=1'b1;
    
    read_addr_en = 1'b0;
    write_en=1'b1;
    
    data_in = $random; #10;
    
    data_in = $random + 16; #10;
    
    data_in = $random + 8; #10;
    
    data_in = $random + 32; #10;
    
    data_in = $random + 64; #10;
    
    data_in = $random + 2; #10;
    
    data_in = $random + 5; #10;
    
    data_in = $random + 9; #10;
    write_en=1'b0; #10;
    
    read_addr_en = 1'b1;
    for (i=0; i<maxfilled_addr+1; i=i+1) begin
        read_addr = i; #10;
    end
    $finish;
end

task display_reg; begin
    $display(" ------- register block -------");
    for (i=0; i<31; i=i+1) begin
        $display(" %29b | (%0d)", dut.register[i], dut.register[i]);
    end
    $display(" ------------------------------");
end
endtask

always @ (posedge clk or negedge rst) begin
    $display("rst=%0b, write_en=%0b, read_addr_en=%0b, read_addr=%0d, data_in=%0d, data_out=%0d",
             rst, write_en, read_addr_en, read_addr, data_in, data_out);
    display_reg ();
end

endmodule