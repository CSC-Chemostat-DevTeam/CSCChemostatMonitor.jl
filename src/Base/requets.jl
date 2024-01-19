export read_request
# read lines till hit a request and recieve a confirmation
function read_request(M::Monitor; tout = 3.0)
    t0 = time()
    req = ""
    # Get request
    readline(M) do _line
        time() - t0 >= tout && return true
        # Check request line
        if _match("\\\$\\\$\\\$.*\\\$\\\$\\\$", _line)
            # Send AKN
            hash = _crc16_hash(UInt16(0), _line)
            conf = _read_confirmation(M, hash; tout)
            if _match("REQUEST: CONFIRMED", conf)
                req = _line
                return true
            end
        end
        return false
    end 
    return isempty(req) ? nothing : CHRequest(req)
end

export _read_confirmation
# Send a command and return the response
function _read_confirmation(M::Monitor, hash; tout = 10.0)
    # send conf cmd
    cmd_str = _cmd_string("RQCONF", hash)
    write(M, cmd_str)
    # read 
    conf = ""
    t0 = time()
    readline(M) do _line
        time() - t0 >= tout && return true
        # confimation
        if _match(">>> REQUEST.* $(hash) .*<<<", _line)
            conf = _line
            return true
        end
        return false
    end
    return conf
end