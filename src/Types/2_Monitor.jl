## ------------------------------------------------------
export Monitor
struct Monitor
    # SerialHandler
    portname::String
    baudrate::Int
    sp::SerialPort
    line_buffer::CircularBuffer{String}

    # extras
    extras::Dict{String, Any}

    function Monitor(portname::String, baudrate::Int; 
            read_buffer_size::Int = 100
        )
        mode = LibSerialPort.SP_MODE_READ_WRITE
        sp = LibSerialPort.open(portname, baudrate; mode)
        read_buffer = CircularBuffer{String}(read_buffer_size)
        extras = Dict{String, Any}()
        new(portname, baudrate, sp, read_buffer, extras)
    end
end

## ------------------------------------------------------
import Base.show
function show(io::IO, m::Monitor)
    println(io, "Monitor(\"", m.portname, "\", ", m.baudrate, ")")
end

## ------------------------------------------------------
