platform "webserver"
    requires { Model } { main : _ }
    exposes []
    packages {}
    imports [Webserver.{ Request, Response }]
    provides [mainForHost]

ProgramForHost : {
    decodeModel : [Init, Existing (List U8)] -> Result (Box Model) Str,
    encodeModel : Box Model -> List U8,
    handleRequest : Request, Box Model -> Task Response U32,
}

mainForHost : ProgramForHost
mainForHost = {
    decodeModel,
    encodeModel,
    handleRequest,
}

decodeModel : [Init, Existing (List U8)] -> Result (Box Model) Str
decodeModel = \fromHost ->
    main.decodeModel fromHost
    |> Result.map \model -> Box.box model

encodeModel : Box Model -> List U8
encodeModel = \boxedModel ->
    main.encodeModel (Box.unbox boxedModel)

handleRequest : Request, Box Model -> Task Response U32
handleRequest = \request, boxedModel ->
    main.handleReadRequest request (Box.unbox boxedModel)

