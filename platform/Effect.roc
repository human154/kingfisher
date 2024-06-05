# this module will be replaced when effect interpreters are implemented
hosted Effect
    requires { Model }
    exposes [
        Effect,
        after,
        map,
        always,
        forever,
        loop,

        updateModel,
    ]
    imports []
    generates Effect with [after, map, always, forever, loop]

# effects that are provided by the host
updateModel : Model -> Effect (Result {} [UpdateFailed])
