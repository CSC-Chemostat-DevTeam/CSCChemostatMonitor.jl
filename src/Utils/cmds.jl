#  Hashing
#  from: https://forum.arduino.cc/t/simple-checksum-that-a-noob-can-use/300443/3
#  TOSYNC
function _crc16_hash(crc::UInt16, c::Char)
    crc = crc ⊻ UInt16(c)
    for i in 1:8
        if crc & 1 == 1
            crc = (crc >> 1) ⊻ 0xA001
        else
            crc = crc >> 1
        end
    end
    return crc
end

function _cmd_hash(cmd::String, arg::String)
    crc = UInt16(0)
    for c in cmd
        crc = _crc16_hash(crc, c)
    end
    for c in arg
        crc = _crc16_hash(crc, c)
    end
    return Int(crc)
end

export sendcmd
"""
Send a command and wait for the akw.
"""
function sendcmd(ch::Chemostat, cmd::String, arg::String = ""; 
        tout = 1.0
    )
    # Send
    str = string("\$", cmd, ":", arg, "%") # TODO: Interface this
    write(ch, str)
    okflag = false
    # Akw
    t0 = time()
    hash = _cmd_hash(cmd, arg) # Recieved hash
    readline(ch) do _line
        line = _line
        if contains(line, string(hash))
            okflag = true
            return true
        end
        time() - t0 >= tout && return true
    end
    return okflag
end

export isconnected
isconnected(ch::Chemostat) = sendcmd(ch, "ECHO", "")