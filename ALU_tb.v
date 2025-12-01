`timescale 1ns / 1ps

module ALU_tb;

reg  [7:0] A_tb;
reg  [7:0] B_tb;
reg  [2:0] opcode_tb;
wire [7:0] Y_tb;
wire       c_tb;
wire       zero_flag_tb;

ALU #(8) dut (.A(A_tb), .B(B_tb), .opcode(opcode_tb), .Y(Y_tb), .c(c_tb),
         .zero_flag(zero_flag_tb));
         
initial begin
    opcode_tb=3'b000; //ADD
    A_tb=254; B_tb=006; #10;
    A_tb=100; B_tb=146; #10;
    
    opcode_tb=3'b001; //SUB
    A_tb=254; B_tb=006; #10;
    A_tb=100; B_tb=146; #10;
    
    opcode_tb=3'b010; //AND
    A_tb=010; B_tb=005; #10;
    A_tb=011; B_tb=013; #10;
    
    opcode_tb=3'b011; //OR
    A_tb=010; B_tb=005; #10;
    A_tb=011; B_tb=013; #10;
    
    opcode_tb=3'b100; //NOT
    A_tb=010; #10;
    A_tb=011; #10;
    
    opcode_tb=3'b101; //XOR
    A_tb=010; B_tb=005; #10;
    A_tb=011; B_tb=013; #10;
        
    opcode_tb=3'b000; //SLL
    A_tb=010; B_tb=001; #10;
    A_tb=011; B_tb=002; #10;
    
    opcode_tb=3'b000; //SRL
    A_tb=010; B_tb=001; #10;
    A_tb=011; B_tb=002; #10;
    
    $finish;
end

initial $monitor("opcode=%3b(%0d), A=%8b(%3d), B=%8b(%3d), c=%0b ,Y=%8b(%3d), zero_flag=%0b",
                  opcode_tb, opcode_tb, A_tb, A_tb, B_tb, B_tb, c_tb, Y_tb, Y_tb, zero_flag_tb); 
endmodule
