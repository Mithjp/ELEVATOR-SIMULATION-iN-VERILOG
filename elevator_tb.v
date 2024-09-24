module elevator_controller_tb;

elevator_controller dut (
	.clk(clk),
	.rst(rst),
	.man_door_close(man_door_close),
	.man_door_open(man_door_open),
	.button(button_press),
	.move_up(move_up),
	.move_down(move_down),
	.door_open(door_open)
);

reg clk, rst, man_door_close, man_door_open;
reg [2:0] button_press;

wire move_up, move_down, door_open;

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

initial begin
	$dumpfile("elevator_wave.vcd");
	$dumpvars(0, elevator_controller_tb);
	
	rst = 1'b1;
	button_press = 3'b0;
	man_door_open = 1'b0;
	man_door_close = 1'b0;

	#10 rst = 1'b0;

	#10 button_press = 3'b100;
	#50 button_press = 3'b000;

	#200;

	#10 man_door_open = 1'b1;
	#50 man_door_open = 1'b0;

	#10 man_door_close = 1'b1;
	#50 man_door_close = 1'b0;

	#10 man_door_open = 1'b1;
	#50 man_door_open = 1'b0;
	
	#200;
	
	#10 button_press = 3'b001;
	#50 button_press = 3'b000;
	
	#700;
	$finish;
end

initial begin
	$monitor("Time=%t, Floor_Selection=%d, Door=%b, UP=%b, Down=%b", $time, button_press, door_open, move_up, move_down);
end

endmodule 
