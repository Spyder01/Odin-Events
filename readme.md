# Event System in Odin

This library provides a simple and flexible event system in the Odin programming language. It allows you to create events, add listeners to them, and dispatch these events to all registered listeners. It also supports optional thread-safety for concurrent environments.

## Features

- Create events with unique identifiers.
- Add listeners to specific event identifiers.
- Dispatch events to all listeners of a specific event identifier.
- Optional thread-safety for concurrent environments.

## Installation

To use this event system in your Odin project, simply copy the `events` package into your project's directory.

## Usage

### Importing the Package

```odin
import "events"
```

### Creating an Event

To create an event, use the `create_event` function. You can specify whether the event should be thread-safe by passing `true` as the second argument.

```odin
event := events.create_event("my_event", concurrent=true)
```

### Adding an Event Listener

To add a listener to an event, use the `add_event_listener` function. You need to provide the event, the event identifier, and the listener method.

```odin
listener_method := proc(e: ^events.Event) {
    // Listener code here
}

events.add_event_listener(&event, "my_event_identifier", listener_method)
```

### Dispatching an Event

To dispatch an event to all its listeners, use the `dispatch_event` function. You need to provide the event and the event identifier.

```odin
events.dispatch_event(&event, "my_event_identifier")
```

## Example

Below is a complete example demonstrating how to create an event, add listeners, and dispatch the event.

```odin
import "core:fmt"
import "events"

listener1 := proc(e: ^events.Event) {
    fmt.println("Listener 1 triggered for event:", e.name)
}

listener2 := proc(e: ^events.Event) {
    fmt.println("Listener 2 triggered for event:", e.name)
}

main :: proc() {
    // Create a thread-safe event
    my_event := events.create_event("example_event", concurrent=true)

    // Add listeners to the event
    events.add_event_listener(&my_event, "example_event_identifier", listener1)
    events.add_event_listener(&my_event, "example_event_identifier", listener2)

    // Dispatch the event
    events.dispatch_event(&my_event, "example_event_identifier")
}
```

## Thread Safety

If you need to use the event system in a multi-threaded environment, create the event with the `concurrent` parameter set to `true`. This ensures that access to the event's listeners is protected by a mutex.

```odin
// Create a thread-safe event
my_event := events.create_event("example_event", concurrent=true)
```

## Contributing

Contributions are welcome! If you have suggestions or improvements, please submit a pull request or open an issue on the GitHub repository.

## License

This project is licensed under the MIT License.
