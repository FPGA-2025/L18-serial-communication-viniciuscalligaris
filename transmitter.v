module transmitter (
    input clk,
    input rstn,
    input start,
    input [6:0] data_in,
    output reg serial_out
);
    reg [3:0] contador_bits;
    reg [7:0] armazenador_bits;
    reg enviando_dados;

    wire bit_paridade = ~ (^data_in); 

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            serial_out <= 1'b1; 
            armazenador_bits <= 8'd0;
            contador_bits <= 0;
            enviando_dados <= 0;
        end else begin
            if (start && !enviando_dados) begin    
                armazenador_bits <= {bit_paridade, data_in};
                contador_bits <= 0;
                serial_out <= 1'b0; 
                enviando_dados <= 1;
            end else if (enviando_dados) begin
                
                contador_bits <= contador_bits + 1;

                if (contador_bits < 8) begin
                    serial_out <= armazenador_bits[0];
                    armazenador_bits <= {1'b0, armazenador_bits[7:1]};
                end else begin
                    serial_out <= 1'b1; 
                    enviando_dados <= 0;
                end
            end
        end
    end

endmodule