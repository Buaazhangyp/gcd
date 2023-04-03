module exgcd (
	input 	clk,    // Clock
	// input clk_en, // Clock Enable
	input 	rst_n,  // Asynchronous reset active low
	input	[7:0] data_a,
	input 	[7:0] data_b,
	output 	[7:0] gcd,
	output  [7:0] inv,
//-----------------<temporary output>-----------------//
	output 	[1:0] current_state_out
);

localparam 	IDLE = 2'b00,
			COMP = 2'b01,
			CALC = 2'b10,
			FIN  = 2'b11;

reg [1:0] current_state;
reg	[1:0] next_state;
reg [7:0] a;
reg [7:0] b;

reg [7:0] m;
reg [7:0] n;
reg [7:0] x;
reg [7:0] y;

reg [7:0] d;
reg [7:0] tmp;
reg [7:0] tmpm;
reg [7:0] tmpn;
reg [7:0] gcd_result;
reg [7:0] inv_out;

assign gcd = gcd_result;
assign current_state_out = current_state;
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
 		tmp = 8'b0;
 		x = 8'b0;
 		y = 8'b1;
 		m = 8'b1;
 		n = 8'b0;
 		next_state = IDLE;
	end else begin
		 case (current_state)
		 	IDLE : begin
		 		a = data_a;
		 		b = data_b;
		 		next_state = COMP;
		 	end
		 	COMP : begin
		 		if (a < b) begin
		 			tmp = a;
		 			a = b;
		 			b = tmp;
		 		end
		 		next_state = CALC;
		 	end
		 	CALC : begin
		 		d = (a % b) * b;
		 		tmpm = m;
		 		m = x - d * tmp;
		 		x = tmpm;
		 		tmpn = n;
		 		n = y - d * tmpn;
		 		y = tmpn;
		 		tmp = a % b;
		 		a = b;
		 		b = tmp;
		 		if (~b) next_state = FIN;
		 		else next_state = CALC;
		 	end
		 	FIN : begin
		 		gcd_result = a;
		 		inv_out = x % data_b;
		 		next_state = IDLE;
		 	end
		 	default : begin 
				gcd_result = 8'b0;
				inv_out = 8'b1;
		 	end 
		 endcase
	end
end

endmodule : exgcd