export Chemostat
struct Chemostat
    # Serial
    portname::String
    baudrate::Int
    sp::SerialPort
    # State
    state::Dict
    
    function Chemostat(portname::String, baudrate::Int)
        mode = LibSerialPort.SP_MODE_READ_WRITE
        sp = LibSerialPort.open(portname, baudrate; mode)
        return new(portname, baudrate, sp, Dict{String, Any}())
    end
end
