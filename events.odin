package events

import "core:encoding/uuid"
import "core:sync"

@(private="file")
Listener :: struct {
    id: uuid.Identifier,
    method: proc(e: ^Event),
}

Event :: struct {
    id: uuid.Identifier,
    name: string,
    listeners: map[string][dynamic]^Listener,
    lock: ^sync.Mutex,
}

create_event :: proc(name: string, concurrent: bool = false) -> (event: Event) {
    event.id = uuid.generate_v4()
    event.name = name
    event.listeners = map[string][dynamic]^Listener{}

    if !concurrent {
        event.lock = nil
        return
    }
    event.lock =  &sync.Mutex{}

    return
}

add_event_listener :: proc(e: ^Event, event_identifier: string, listener_method: proc(e: ^Event)) {
    id := uuid.generate_v4()

    listener := &Listener{
        id,
        listener_method
    }

    if e.lock != nil {
        sync.lock(e.lock)
    }

    listeners, found := e.listeners[event_identifier]
    if !found {
        e.listeners[event_identifier] = [dynamic]^Listener{listener}
        return
    }

    append(&e.listeners[event_identifier], listener)

    if e.lock != nil {
        sync.unlock(e.lock)
    }
}

dispatch_event :: proc(e: ^Event, event_identifier: string) {

    if e.lock != nil {
        sync.lock(e.lock)
    }

    listeners, found := e.listeners[event_identifier]

    if e.lock != nil {
        sync.unlock(e.lock)
    }

    if !found {
        return
    }

    for listener in listeners {
        listener.method(e)
    }
}
