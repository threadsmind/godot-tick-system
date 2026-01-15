# Godot Tick System (Godot 4)

A framerate-independent game tick system for Godot 4.

## Description

**TickSystem** is a wrapper for Godot's physics processing loop. It provides
ways to control and access a framerate-independent game tick loop separately from
Godot's physics loop.

**Note:** Ticks per second (TPS) for this system is limited to a range from `1` to
`Engine.physics_ticks_per_second`. If your use case requires less frequent ticks
(longer than 1 second), you can use a modulo operation on the tick accumulation
value passed in the `ticked` signal where the modulus is greater than the system's
current TPS (see [Example 3](#example-3)).

**Note:** While starting, stopping, or changing the TPS of the TickSystem does
not affect Godot's physics loop, changes to `Engine.physics_ticks_per_second`
**will** affect the speed of the TickSystem loop.

## Using TickSystem in your project

The entire system is contained in the [TickSystem.gd](src/TickSystem.gd) file.
You can copy/paste the file contents into a `TickSystem.gd` file in your local
project, then set that file as an
[Autoload](https://docs.godotengine.org/en/latest/tutorials/scripting/singletons_autoload.html)
in your project settings. Make sure to remember to call `TickSystem.Start()`
somewhere in your project to begin the tick loop (see [Example 1](#example-1) or
[the demo scene](src/TickSystemDemo.gd)).

All other files in this repository are usage examples. If you wish to see these
examples in action then clone this repo, open it in the Godot editor, and run the
default scene.

## Examples

### Example 1
Set the target TPS to a non-default value, connect a method that will be called
on each game tick, then begin the tick loop:

```
func _ready():
	TickSystem.targetTPS = 10   # [default 20]
	TickSystem.ticked.connect(_on_tick)
	TickSystem.Start()

func _on_tick(_ticks):
	print("Tick!")
```

*See [every tick example](src/components/tick_counter/TickCounter.gd) for a
basic implementation.*

### Example 2
Handling game pause, resume, and exit.

```
func _on_pause():
	TickSystem.Stop()

func _on_resume():
	TickSystem.Start()

func _on_exit_to_menu():
	TickSystem.Reset()
```

### Example 3
Listening for specific tick intervals:

```
var interval: int = 2
var two_second_interval: int

func _ready():
	TickSystem.ticked.connect(_on_tick)
	two_second_interval = TickSystem.targetTPS * 2

func _on_tick(tick: int):
	if tick % interval == 0:
		# thing that happens every 2nd tick here
	if tick % two_second_interval == 0:
		# thing that happens every 2 seconds here
```

*See [nth tick example](src/components/nth_tick_counter/NthTickCounter.gd) for a
basic implementation. See [item pipes example](src/components/pipes/Pipes.gd) for a
more in-depth implementation.*

## Signal Descriptions

- `reset()` - Emitted when the tick system is reset (see `Reset()` method).
- `ticked(accumulator: int)` - Emitted when a tick occurs. The total tick count
is passed in the accumulator argument.
- `toggled(isTicking: bool)` - Emitted when the tick system is started or stopped.
The active state is passed in the `isTicking` argument.
- `tps_updated(tps: int)` - Emitted when the target ticks per second value
(`targetTPS`) is modified.

## Property Descriptions

- `int` `targetTPS` [default: `20`] [property: setter]

The amount of ticks per second ranging from a minimum of `1` to a maximum of
`Engine.physics_ticks_per_second`. Emits `tps_updated` when the value is changed.

## Method Descriptions

- `bool` `IsTicking()` - Returns whether or not the tick system is currently active.
- `void` `Pause()` - Pauses the accumulation of ticks.
- `void` `Reset()` - Stops and resets the accumulation of ticks. Both the `reset`
and `toggled` signals are fired when resetting the system.
- `void` `Start()` - Begins the accumulation of ticks.
