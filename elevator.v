module elevator_controller(
	input wire clk,
	input wire rst,
	input wire man_door_close,
	input wire man_door_open,
	input wire [2:0]button,
	output reg move_up, move_down, door_open
);

reg [2:0] floor_number, floor_number_next, button_press, button_press_next;
reg [5:0] door_timer, door_timer_next;
reg [2:0] state, next_state;

parameter IDLE 		= 3'b000;
parameter BUTTON_PRESS	= 3'b001;
parameter UP 		= 3'b010;
parameter DOWN 		= 3'b011;
parameter DOOR_OPEN 	= 3'b100; 

always @(posedge clk or posedge rst)begin
	if(rst)begin
		state 		<= IDLE;
		floor_number 	<= 3'b001;		// ground floor on default
		door_timer 	<= 6'b0;
	end else begin
		state 		<= next_state;
		floor_number 	<= floor_number_next;
		door_timer 	<= door_timer_next;
		button_press 	<= button_press_next;
	end
end

always @(*)begin
	next_state 		= state;
	floor_number_next 	= floor_number;
	door_timer_next 	= door_timer;
	button_press_next 	= button_press;
	case(state)
		IDLE:	begin
			button_press_next = button;
			if(button > 3'b0)
				next_state = BUTTON_PRESS;
			else if (man_door_open)
				next_state =	DOOR_OPEN;
			else
				next_state =	IDLE;
			end
		BUTTON_PRESS:	begin
			if(button_press > floor_number)
				next_state = UP;
			else if(button_press < floor_number)
				next_state = DOWN;
			else 
				next_state = DOOR_OPEN;
			end
		UP:	begin
			if(floor_number == button_press)begin
				next_state = DOOR_OPEN;
				button_press_next = 3'b0;
			end else begin
				next_state = UP;
				floor_number_next = floor_number + 1'b1;
			end
			end
		DOWN:	begin		
			if(floor_number == button_press) begin
				next_state = DOOR_OPEN;
				button_press_next = 3'b0;
			end else begin
				next_state = DOWN;
				floor_number_next = floor_number - 1'b1;
			end
			end
		DOOR_OPEN:
			begin
			if(door_timer == 6'b1000)begin		// 60
				next_state = IDLE;
				door_timer_next = 6'b0;
			end else if(man_door_close)begin
				next_state = IDLE;
				door_timer_next = 6'b0;
			end else if(man_door_open)begin
				next_state = DOOR_OPEN;
				door_timer_next = 6'b0;
			end else begin 
				next_state = DOOR_OPEN;
				door_timer_next = door_timer + 1'b1;
			end
			end
		default:
			next_state = IDLE;
	endcase
end

always @(state) begin
	case(state)
		IDLE:	begin
			door_open = 1'b0;
			move_up   = 1'b0;
			move_down = 1'b0;
			end
		BUTTON_PRESS:	begin
			door_open = 1'b0;
			move_up   = 1'b0;
			move_down = 1'b0;
			end
		UP:	begin
			door_open = 1'b0;
			move_up   = 1'b1;
			move_down = 1'b0;
			end
		DOWN:	begin
			door_open = 1'b0;
			move_up   = 1'b0;
			move_down = 1'b1;
			end
		DOOR_OPEN:	begin
			door_open = 1'b1;
			move_up   = 1'b0;
			move_down = 1'b0;
			end
		default:	begin
			door_open = 1'b0;
			move_up   = 1'b0;
			move_down = 1'b0;
			end
	endcase
end

endmodule
