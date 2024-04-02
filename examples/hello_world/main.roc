app "hello_world"
    packages {
        webserver: "../../platform/main.roc",
    }
    imports [webserver.Webserver.{ Request, Response }]
    provides [main, Model] to webserver

Program : {
    init : Model,
    handleReadRequest : Request, Model -> Response,
    handleWriteRequest : Request, Model -> (Response, Model),
}

Model : List U8

main : Program
main = { init, handleReadRequest, handleWriteRequest }

init : Model
init =
    "World" |> Str.toUtf8

handleReadRequest : Request, Model -> Response
handleReadRequest = \_request, model -> {
    body: "Hello " |> Str.toUtf8 |> List.concat model |> List.append '\n',
    headers: [],
    status: 200,
}

handleWriteRequest : Request, Model -> (Response, Model)
handleWriteRequest = \request, _model ->
    model =
        when request.body is
            EmptyBody -> "World" |> Str.toUtf8
            Body b -> b.body
    (
        {
            body: model,
            headers: [],
            status: 200,
        },
        model,
    )