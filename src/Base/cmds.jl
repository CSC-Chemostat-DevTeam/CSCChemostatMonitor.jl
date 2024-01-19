## ------------------------------------------------------
## CMD INTERFACE
# [IMPORTANT] Must match with board definition
function _cmd_hash(cmd, args...)
    crc = UInt16(0)
    for c in string(cmd)
        crc = _crc16_hash(crc, c)
    end
    for arg in string.(args)
        for c in arg
            crc = _crc16_hash(crc, c)
        end
    end
    return Int(crc)
end

# [IMPORTANT] Must match with board definition
function _cmd_string(cmd, args...)
    return string("\$", join(string.([cmd, args...]), ":"), "%")
end

# read a response block with a given hash
function _read_response(M::Monitor, cmd_str; tout = 10.0)
    response = String[]
    t0 = time()
    valid = false
    readline(M) do _line
        time() - t0 >= tout && return true
        # if contains(_line, string(hash))
        # INIT
        if _match(">>>.*-$(cmd_str).*", _line)
            !isempty(response) && return true # This is invalid
            push!(response, _line)
            t0 = time()
            return false
        end
        isempty(response) && return false # Non init yet, continue
        # END
        if _match("<<<.*-$(cmd_str).*", _line)
            push!(response, _line)
            valid = true
            return true
        end
        # DATA
        push!(response, _line)
        t0 = time()
        return false
    end
    return valid ? response : ""
end

export read_cmd
# Send a command and return the response
function read_cmd(M::Monitor, cmd, args...; 
        tout = 1.0, # wait time
    )
    # Send
    cmd_str = _cmd_string(cmd, args...)
    write(M, cmd_str)
    # response
    hash = _cmd_hash(cmd, args...)
    # TODO: return Response Object
    return _read_response(M, hash; tout)
end

# 24091