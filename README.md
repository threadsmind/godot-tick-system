# Godot Tick System (Godot 4)

A frame-independent game tick system based on Godot's physics processing loop.

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
