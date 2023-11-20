#=

=#

## ------------------------------------------------------
@time begin
    using CSCChemostatMonitor
    using LibSerialPort
    using CairoMakie
end

## ------------------------------------------------------
let
    # config
    progname = "BASHV1"
    baudrate = 115200
    portname = "/dev/tty.usbmodem14101"

    # Chemostat
    global CH = Chemostat(portname, baudrate)

end

## ------------------------------------------------------
let
    # Upload
    file = "" # HERE WRITE THE FILE TO UPLOAD
    sendcmd(CH, "UPLOADER-SET-FILE", file)
    sendcmd(CH, "UPLOADER-UPLOAD")

    # get lines
    global lines = String[]
    started = false
    readline(CH) do _line
        println(_line);
        
        # check for start
        if _line == "+++" # TODO: Interface this
            started = true
            return false
        end
        !started && return false

        # check for end
        _line == "---" && return true

        # collect line
        push!(lines, _line);
    end
end

## ------------------------------------------------------
let

end