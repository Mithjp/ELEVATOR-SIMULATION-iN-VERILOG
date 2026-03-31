module elevator_controller_tb;

reg clk;
reg rst;

reg [3:0] button;
reg man_door_open;
reg man_door_close;
reg door_obstruct;

wire move_up;
wire move_down;
wire door_open;

// DUT
elevator_controller dut (
    .clk(clk),
    .rst(rst),
    .button(button),
    .man_door_open(man_door_open),
    .man_door_close(man_door_close),
    .door_obstruct(door_obstruct),
    .move_up(move_up),
    .move_down(move_down),
    .door_open(door_open)
);

// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Stimulus
initial begin
    $dumpfile("elevator_wave.vcd");
    $dumpvars(0, elevator_controller_tb);

    rst = 1;
    button = 0;
    man_door_open = 0;
    man_door_close = 0;
    door_obstruct = 0;

    #20 rst = 0;

    // Floor 3 request
    #20 button = 4'b1000;
    #10 button = 0;

    #300;

    // Floor 1 request while moving
    button = 4'b0010;
    #10 button = 0;

    #400;

    // Obstruction
    door_obstruct = 1;
    #50 door_obstruct = 0;

    #200;

    // Manual open
    man_door_open = 1;
    #20 man_door_open = 0;

    #100;

    // Manual close
    man_door_close = 1;
    #20 man_door_close = 0;

    #300;

    $finish;
end

// Monitor
initial begin
    $monitor("T=%0t | State=%0d | Floor=%0d | UP=%b DOWN=%b DOOR=%b | Req=%b | Obs=%b",
              $time,
              dut.state,
              dut.floor,
              move_up,
              move_down,
              door_open,
              dut.request,
              door_obstruct);
end

endmodule