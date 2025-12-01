`timescale 1ps / 1ps

module top_module_tb;

reg  [07:0] A_tb;
reg  [07:0] B_tb;
reg  [02:0] opcode_tb;

reg         clk;
reg         rst;
reg         write_en;
reg         read_addr_en;
reg  [04:0] read_addr;
wire [28:0] data_out;
wire [04:0] maxfilled_addr;

reg  [31:0] file;
integer i;

top_module dut (.A(A_tb), .B(B_tb), .opcode(opcode_tb), .clk(clk), .rst(rst), .write_en(write_en), 
                .read_addr_en(read_addr_en), .read_addr(read_addr), .data_out(data_out), 
                .maxfilled_addr(maxfilled_addr));
    
always #5 clk = ~clk;
              
initial begin
    clk=1'b0;
    write_en=1'b0;
    read_addr_en=1'b0;
    read_addr = 0;
    
    rst=1'b0; #10; rst=1'b1;
    
    file = $fopen("register_file.txt", "w");
    
    if (file == 0) begin
        $display("File opening ERROR!");
        $finish;
    end
    
    write_en=1'b1;
    
    opcode_tb=3'b000; //ADD
    A_tb=254; B_tb=006; @(posedge clk) #1;
    A_tb=100; B_tb=146; @(posedge clk) #1;
    
    opcode_tb=3'b001; //SUB
    A_tb=254; B_tb=006; @(posedge clk) #1;
    A_tb=100; B_tb=146; @(posedge clk) #1;
    
    opcode_tb=3'b010; //AND
    A_tb=010; B_tb=005; @(posedge clk) #1;
    A_tb=011; B_tb=013; @(posedge clk) #1;
    
    opcode_tb=3'b011; //OR
    A_tb=010; B_tb=005; @(posedge clk) #1;
    A_tb=011; B_tb=013; @(posedge clk) #1;
    
    opcode_tb=3'b100; //NOT
    A_tb=010; @(posedge clk) #1;
    A_tb=011; @(posedge clk) #1;
    
    opcode_tb=3'b101; //XOR
    A_tb=010; B_tb=005; @(posedge clk) #1;
    A_tb=011; B_tb=013; @(posedge clk) #1;
    
    opcode_tb=3'b110; //SLL
    A_tb=010; B_tb=001; @(posedge clk) #1;
    A_tb=011; B_tb=002; @(posedge clk) #1;
    
    opcode_tb=3'b111; //SRL
    A_tb=010; B_tb=001; @(posedge clk) #1;
    A_tb=011; B_tb=002; @(posedge clk) #1;
    
    write_en = 1'b0;
    read_addr_en = 1'b1;
    
    for (i=0; i<maxfilled_addr+1; i=i+1) begin
        read_addr = i; #1;
        $fdisplay(file, "time=%0t A=%8b(%3d), B=%8b(%3d), opcode=%3b(%0d), Y=%8b(%3d), c=%0b, zero_flag=%0b",
                  $time, data_out[28:21], data_out[28:21], 
                  data_out[20:13], data_out[20:13],
                  data_out[12:10], data_out[12:10],
                  data_out[9:2], data_out[9:2],
                  data_out[1], data_out[0]);
        #10;
    end
    
    $fclose(file); 
    $finish;
end

endmodule
