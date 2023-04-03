module exgcd_recursion (
	input 	clk,    // Clock
	// input clk_en, // Clock Enable
	input 	rst_n,  // Asynchronous reset active low
	input	[7:0] data_a,
	input 	[7:0] data_b,
	input	valid_in,
	output 	[7:0] gcd,
	output  [7:0] inv,
	output  reg valid_out
//-----------------<temporary output>-----------------//
);

localparam 	IDLE = 2'b00,
			DIV = 2'b01,
			FIN = 2'b10,
			CYC  = 2'b11;

reg [1:0] current_state;
reg	[1:0] next_state;
reg [7:0] a;
reg [7:0] b;

reg [7:0] s_0;
reg [7:0] s_1;
reg [7:0] t_0;
reg [7:0] t_1;

reg [7:0] q;
reg [7:0] r;

reg [7:0] tmps;
reg [7:0] tmpt;
reg [7:0] gcd_out;
reg [7:0] inv_out;

assign gcd = gcd_out;
assign inv = inv_out;

always @(posedge clk or negedge rst_n) begin : state
	if(~rst_n) begin
		current_state <= IDLE;
	end else begin
		current_state <= next_state;
	end
end

always @(*) begin : calculate
	if(~rst_n) begin
 		tmps = 8'b0;
        tmpt = 8'b0;
 		s_0 = 8'b1;
 		s_1 = 8'b0;
 		t_0 = 8'b0;
 		t_1 = 8'b1;
        q = 8'b0;
        r = 8'b0;
		valid_out = 0;
	end else begin
		 case (current_state)
		 	IDLE : begin
                s_0 = 8'b1;
                s_1 = 8'b0;
                t_0 = 8'b0;
                t_1 = 8'b1;
				valid_out = 0;
				if(valid_in) begin
					a = data_a;
		 			b = data_b;
					next_state = DIV;
				end
				else next_state = IDLE;
		 	end
		 	DIV : begin
                r = a % b;
                q = a / b;
		 		next_state = FIN;
		 	end
            FIN : begin
                if(r) next_state = CYC;
                else begin
					valid_out = 1;
					next_state = IDLE;
				end
		 	end
		 	CYC : begin
                a = b;
                b = r;

                tmps = s_0;
                s_0 = s_1;
                s_1 = tmps - q * s_1;

                tmpt = t_0;
                t_0 = t_1;
                t_1 = tmpt - q * t_1;
                next_state = DIV;
		 	end
		 	default : begin 
                next_state = IDLE;
		 	end 
		 endcase
	end
end

always @(posedge clk or negedge rst_n) begin : result
	if(~rst_n) begin
		gcd_out <= 8'b0;
        inv_out <= 8'b0;
	end else begin
		if(current_state == FIN && valid_out == 1)begin
            gcd_out <= b;
            inv_out <= s_1;
        end
	end
end

endmodule : exgcd_recursion