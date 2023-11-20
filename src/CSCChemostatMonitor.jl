module CSCChemostatMonitor

    import LibSerialPort
    import LibSerialPort: SerialPort
    using Serialization
    using Dates

    #! include .
    
    #! include Types
    include("Types/Chemostats.jl")
    
    #! include Utils
    include("Utils/Serial.jl")
    include("Utils/cmds.jl")
    

end