module [
    Request,
    Response,
    Header,
]

import Effect
import Task exposing [Task]

# Request is the same as: https://github.com/roc-lang/basic-webserver/blob/main/platform/InternalHttp.roc
Request : {
    method : [Options, Get, Post, Put, Delete, Head, Trace, Connect, Patch],
    headers : List Header,
    url : Str,
    mimeType : Str,
    body : List U8,
    timeout : [TimeoutMilliseconds U64, NoTimeout],
}

Response : {
    status : U16,
    headers : List Header,
    body : List U8,
}

Header : { name : Str, value : List U8 }

updateModel : Model -> Task {} [UpdateFailed]
updateModel = \model ->
    Effect.updateModel (Box.box model)
    |> Task.fromEffect
