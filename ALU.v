
module ALU #(parameter N = 8) (
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire [2:0]   opcode,
    output reg  [N-1:0] Y,
    output reg          c,
    output reg          zero_flag
);

parameter ADD = 3'b000;
parameter SUB = 3'b001;
parameter AND = 3'b010;
parameter OR  = 3'b011;
parameter NOT = 3'b100;
parameter XOR = 3'b101;
parameter SLL = 3'b110;
parameter SRL = 3'b111;

//assign zero_flag = & (~({c,Y}^{N{1'b0}}))

always @ (*) begin  
    case (opcode)
        ADD: {c, Y} = A+B;
        SUB: {c, Y} = A-B;
        AND: {c, Y} = {1'b0, A&B};
        OR : {c, Y} = {1'b0, A|B};
        NOT: {c, Y} = {1'b0, ~A};
        XOR: {c, Y} = {1'b0, A^B};
        SLL: {c, Y} = {1'b0, A<<B};
        SRL: {c, Y} = {1'b0, A>>B};
    endcase
    zero_flag = ({c, Y} == {N{1'b0}});
end
 
endmodule