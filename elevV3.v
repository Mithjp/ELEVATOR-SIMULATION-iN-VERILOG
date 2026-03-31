module elevator_controller(

input clk,
input rst,

input [3:0] button,
input man_door_open,
input man_door_close,
input door_obstruct,

output reg move_up,
output reg move_down,
output reg door_open
);

// ================= PARAMETERS =================

parameter IDLE  = 3'd0;
parameter MOVE  = 3'd1;
parameter DOOR  = 3'd2;

parameter FLOOR_TIME = 20;
parameter DOOR_TIME  = 10;

// ================= REGISTERS =================

reg [2:0] state,next_state;
reg [1:0] floor,floor_next;
reg [3:0] request,request_next;
reg direction,direction_next;

reg [7:0] move_timer,move_timer_next;
reg [7:0] door_timer,door_timer_next;

// SEQUENTIAL

always @(posedge clk or posedge rst)
begin
 if(rst)
 begin
   state <= IDLE;
   floor <= 0;
   request <= 0;
   move_timer <= 0;
   door_timer <= 0;
   direction <= 1;
 end
 else
 begin
   state <= next_state;
   floor <= floor_next;
   request <= request_next;
   move_timer <= move_timer_next;
   door_timer <= door_timer_next;
   direction <= direction_next;
 end
end


// FSM


always @(*)
begin

next_state = state;
floor_next = floor;
request_next = request | button;

move_timer_next = move_timer;
door_timer_next = door_timer;
direction_next = direction;

case(state)

// IDLE
IDLE:
begin
 if(request_next != 0)
 begin
   if(request_next[floor])
   begin
     request_next[floor] = 0;
     next_state = DOOR;
   end
   else
   begin
     if(floor < 3 && (request_next > (1 << floor)))
       direction_next = 1;
     else
       direction_next = 0;

     next_state = MOVE;
   end
 end
end

// MOVE
MOVE:
begin
 if(move_timer == FLOOR_TIME)
 begin
   move_timer_next = 0;

   if(direction && floor < 3)
     floor_next = floor + 1;
   else if(!direction && floor > 0)
     floor_next = floor - 1;

   if(request_next[floor_next])
   begin
     request_next[floor_next] = 0;
     next_state = DOOR;
   end
 end
 else
   move_timer_next = move_timer + 1;
end

// DOOR with safety logic
DOOR:
begin
 if(door_obstruct)
 begin
   door_timer_next = 0;
 end
 else if(man_door_close || door_timer == DOOR_TIME)
 begin
   door_timer_next = 0;
   next_state = IDLE;
 end
 else if(man_door_open)
 begin
   door_timer_next = 0;
 end
 else
 begin
   door_timer_next = door_timer + 1;
 end
end

endcase
end

// outpuy logic


always @(*)
begin
 move_up = 0;
 move_down = 0;
 door_open = 0;

 case(state)

 MOVE:
 begin
   if(direction) move_up = 1;
   else move_down = 1;
 end

 DOOR:
 door_open = 1;

 endcase
end

endmodule
//mjupdate3
//safety added
//timer reset logic