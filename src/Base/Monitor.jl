serialport(obj::Monitor)::SerialPort = obj.sp

import Base.isopen
isopen(m::Monitor) = isopen(serialport(m))
import Base.close
close(m::Monitor) = close(serialport(m))

function reopen!(m::Monitor) 
    isopen(m) && close(m)
    mode = LibSerialPort.SP_MODE_READ_WRITE
    m.sp = LibSerialPort.open(portname, baudrate; mode)
    return m
end

import Base.readline
function readline(f::Function, m::Monitor)
    while true
        line = readline(serialport(m))
        f(line) == true && break
    end
end

import Base.write
function write(m::Monitor, msg)
    write(serialport(m), string(msg))
    sleep(0.1)
end

import Base.flush
flush(m::Monitor) = flush(serialport(m))


# export isconnected
# isconnected(ch::Chemostat) = sendcmd(ch, "ECHO", "")