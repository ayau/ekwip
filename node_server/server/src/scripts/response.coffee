exports.resp =
    UNAUTHORIZED: 401
    NOT_FOUND: 404
    INTERNAL: 500
    BAD: 400
    FORBIDDEN: 403
    CONFLICT: 409
    CREATED: 201
    OK: 200

    success: (res, msg) ->
        res.status @OK
        res.send {status: @OK, data: msg}

    error: (res, code, msg) ->
        if msg
            res.status(code).send {status: code, error: msg}
        else
            res.send code


