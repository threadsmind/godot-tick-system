# Godot Tick System (Godot 4)

A frame-independent game tick system based on Godot's physics processing loop.

## Description

**TickSystem** is a wrapper for Godot's physics processing loop. It provides
ways to control and access a frame-independent game tick loop separately from
Godot's physics loop.

**Example:** Set the target TPS to a non-default value and create a method
that will be called on each game tick:

```
func _ready():
   TickSystem.ticked.connect(_on_tick)
   TickSystem.targetTPS = 10
   TickSystem.Start()

func _on_tick(_ticks):
    print("Tick!")
```

**Note:** While starting, stopping, or changing the TPS of the TickSystem does
not affect Godot's physics loop, changes to `Engine.physics_ticks_per_second`
**will** affect the speed of the TickSystem loop.

## Properties

`int` `targetTPS` [default: `20`] [property: setter]

## Methods

`bool` `IsTicking()`

`void` `Pause()`

`void` `Reset()`

`void` `Start()`

## Signals

- `reset()` - Emitted when the tick system is reset (see `Reset()`).
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
