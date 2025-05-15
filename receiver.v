module receiver (
    input clk,
    input rstn,
    output reg ready,
    output reg [6:0] data_out,
    output reg parity_ok_n,
    input serial_in
);
    reg [3:0] contador_bits;
    reg [7:0] armazenador_bits;
    reg recebendo_dados;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            contador_bits <= 0;
            armazenador_bits <= 0;
            recebendo_dados <= 0;
            data_out <= 0;
            ready <= 0;
            parity_ok_n <= 1;
        end else begin
            if (!recebendo_dados) begin
                if (serial_in == 0) begin 
                    recebendo_dados <= 1;
                    contador_bits <= 0;
                end
            end else if (recebendo_dados) begin
                if (contador_bits < 8) begin
                    armazenador_bits <= {serial_in, armazenador_bits[7:1]};
                end
                
                contador_bits <= contador_bits + 1;

                if (contador_bits == 8) begin
                    data_out <= armazenador_bits[6:0];
                    parity_ok_n <= (^armazenador_bits == 1'b0) ? 1:0; 
                    ready <= 1;
                    recebendo_dados <= 0;
                end
            end
        end
    end

endmodule