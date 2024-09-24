This simulation of elevator controller is based on FINITE STATE MACHINE,which allows transition between various operational states based on various inputs.

Inputs:

# clk: A clock signal that times the operations.
# rst: A reset signal that initializes the elevator to its default state.
# man_door_close: A manual signal to close the elevator door.
# man_door_open: A manual signal to open the elevator door.
# button: A 3-bit signal representing which floor button (1 to 7) is pressed.

Outputs:

# move_up: Moves the elevator up one floor when set to 1.
# move_down: Moves the elevator down one floor when set to 1.
# door_open: Opens the door when set to 1.




States:

IDLE (3'b000):
The elevator is stationary, waiting for an event (either a button press or a manual door command).

BUTTON_PRESS (3'b001):
 The system determines whether the elevator needs to move up or down, depending on the button pressed and the current floor.
 
UP (3'b010):
The elevator is moving up one floor at a time.

DOWN (3'b011):
The elevator is moving down one floor at a time.

DOOR_OPEN (3'b100):
The door is open, either automatically after reaching the destination or manually triggered.

WORKING:

 The system transitions between states based on conditions, such as a button press, floor comparisons, and manual door operations.
 Each state has its own set of outputs that dictate what the elevator is doing:
•	In IDLE, the elevator doesn’t move.
•	In UP or DOWN, the elevator moves up or down one floor at a time.
•	In DOOR_OPEN, the elevator door opens.
  The button_press logic determines the selected floor, and the elevator moves up or down until it reaches that floor.
