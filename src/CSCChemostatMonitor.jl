module CSCChemostatMonitor

    using LibSerialPort
    using Serialization
    using Dates
    using DataStructures

    #! include .
    
    #! include Types
    include("Types/2_Monitor.jl")
    include("Types/3_CHRequest.jl")
    
    #! include Base
    include("Base/Monitor.jl")
    include("Base/cmds.jl")
    include("Base/exportall.jl")
    include("Base/requets.jl")
    include("Base/utils.jl")
    include("Base/virtual_sd.jl")
    

    @_exportall_non_underscore
    
end