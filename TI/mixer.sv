`timescale 1ns / 1ps

module ti_mixer(
    input logic CLK, nRST,
    input logic [3:0] vol0, vol1, vol2, vol3,
    input logic ch0out, ch1out, ch2out, ch3out, //Make sure ch3out is shift register out
    output logic [14:0] digital_out
);
    logic [14:0] volume_table[16] = '{
        15'd32767, 15'd26028, 15'd20675, 15'd16422, 15'd13045, 15'd10362, 15'd8231, 15'd6568,
        15'd5193, 15'd4125, 15'd3277, 15'd2603, 15'd2067, 15'd1642, 15'd1304, 15'd0
    };
    
    logic [16:0] intermediate, c0, c1, c2, c3;
    
    always_comb begin
        c0 = ch0out ? volume_table[vol0] : 15'd0;
        c1 = ch1out ? volume_table[vol1] : 15'd0;
        c2 = ch2out ? volume_table[vol2] : 15'd0;
        c3 = ch3out ? volume_table[vol3] : 15'd0;
    end
    
    always_ff @(posedge CLK, negedge nRST) begin
        if (!nRST) begin
            intermediate <= 0;
        end
        else begin
            intermediate <= c0 + c1 + c2 + c3; 
        end
    end
    
    assign digital_out = intermediate[16:2];

endmodule