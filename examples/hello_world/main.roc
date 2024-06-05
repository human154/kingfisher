app [main, Model] {
    webserver: platform "../../platform/main.roc",
}

import webserver.Webserver exposing [Request, Response, updateModel]
import webserver.Task

Program : {
    decodeModel : [Init, Existing (List U8)] -> Result Model Str,
    encodeModel : Model -> List U8,
    handleRequest : Request, Model -> Task Response I32,
}

Model : Str

main : Program
main = {
    decodeModel,
    encodeModel,
    handleRequest,
}

decodeModel : [Init, Existing (List U8)] -> Result Model Str
decodeModel = \fromPlatform ->
    when fromPlatform is
        Init ->
            Ok "World"

        Existing encoded ->
            encoded
            |> Str.fromUtf8
            |> Result.mapErr \_ -> "Error: Can not decode database."

encodeModel : Model -> List U8
encodeModel = \model ->
    model |> Str.toUtf8

handleRequest : Request, Model -> Response
handleRequest = \request, model ->
    when request.method is
        Post ->
            newModel =
                if List.isEmpty request.body then
                    "World"
                else
                    request.body
                    |> Str.fromUtf8
                    |> Result.withDefault "invalid body"
            Task.updateModel newModel!

            Task.ok {
                body: newModel |> Str.toUtf8,
                headers: [],
                status: 200,
            }

        _ ->
            Task.ok {
                body: "Hello $(model)\n" |> Str.toUtf8,
                headers: [],
                status: 200,
            }
