`timescale 1ns / 1ps

module ti_mixer(
    input logic CLK, nRST,
    input logic [3:0] vol0, vol1, vol2, vol3,
    input logic ch0out, ch1out, ch2out, ch3out, //Make sure ch3out is shift register out
    output logic [14:0] digital_out
);
    logic [14:0] volume0, volume1, volume2, volume3;
    
    (* mark_debug = "true" *)
    logic [16:0] intermediate, c0, c1, c2, c3;
    logic [14:0] int_vol_0;
    
    always_comb begin
        case(vol0)
            4'b0000: volume0 = 15'd32767;
            4'b0001: volume0 = 15'd26028; 
            4'b0010: volume0 = 15'd20675; 
            4'b0011: volume0 = 15'd16422; 
            4'b0100: volume0 = 15'd13045; 
            4'b0101: volume0 = 15'd10362; 
            4'b0110: volume0 = 15'd8231; 
            4'b0111: volume0 = 15'd6568;
            4'b1000: volume0 = 15'd5193; 
            4'b1001: volume0 = 15'd4125; 
            4'b1010: volume0 = 15'd3277; 
            4'b1011: volume0 = 15'd2603; 
            4'b1100: volume0 = 15'd2067; 
            4'b1101: volume0 = 15'd1642; 
            4'b1110: volume0 = 15'd1304; 
            4'b1111: volume0 = 15'd0;  
        endcase
        
        case(vol1)
            4'b0000: volume1 = 15'd32767;
            4'b0001: volume1 = 15'd26028; 
            4'b0010: volume1 = 15'd20675; 
            4'b0011: volume1 = 15'd16422; 
            4'b0100: volume1 = 15'd13045; 
            4'b0101: volume1 = 15'd10362; 
            4'b0110: volume1 = 15'd8231; 
            4'b0111: volume1 = 15'd6568;
            4'b1000: volume1 = 15'd5193; 
            4'b1001: volume1 = 15'd4125; 
            4'b1010: volume1 = 15'd3277; 
            4'b1011: volume1 = 15'd2603; 
            4'b1100: volume1 = 15'd2067; 
            4'b1101: volume1 = 15'd1642; 
            4'b1110: volume1 = 15'd1304; 
            4'b1111: volume1 = 15'd0;
        endcase
        
        case(vol2)
            4'b0000: volume2 = 15'd32767;
            4'b0001: volume2 = 15'd26028; 
            4'b0010: volume2 = 15'd20675; 
            4'b0011: volume2 = 15'd16422; 
            4'b0100: volume2 = 15'd13045; 
            4'b0101: volume2 = 15'd10362; 
            4'b0110: volume2 = 15'd8231;
            4'b0111: volume2 = 15'd6568;
            4'b1000: volume2 = 15'd5193; 
            4'b1001: volume2 = 15'd4125; 
            4'b1010: volume2 = 15'd3277; 
            4'b1011: volume2 = 15'd2603; 
            4'b1100: volume2 = 15'd2067; 
            4'b1101: volume2 = 15'd1642; 
            4'b1110: volume2 = 15'd1304; 
            4'b1111: volume2 = 15'd0;
        endcase
        
        case(vol3)
            4'b0000: volume3 = 15'd32767;
            4'b0001: volume3 = 15'd26028; 
            4'b0010: volume3 = 15'd20675; 
            4'b0011: volume3 = 15'd16422; 
            4'b0100: volume3 = 15'd13045; 
            4'b0101: volume3 = 15'd10362; 
            4'b0110: volume3 = 15'd8231;
            4'b0111: volume3 = 15'd6568;
            4'b1000: volume3 = 15'd5193;
            4'b1001: volume3 = 15'd4125;
            4'b1010: volume3 = 15'd3277;
            4'b1011: volume3 = 15'd2603;
            4'b1100: volume3 = 15'd2067;
            4'b1101: volume3 = 15'd1642;
            4'b1110: volume3 = 15'd1304;
            4'b1111: volume3 = 15'd0;
        endcase
        
        c0 = ch0out ? volume0 : 15'd0;
        c1 = ch1out ? volume1 : 15'd0;
        c2 = ch2out ? volume2 : 15'd0;
        c3 = ch3out ? volume3 : 15'd0;
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