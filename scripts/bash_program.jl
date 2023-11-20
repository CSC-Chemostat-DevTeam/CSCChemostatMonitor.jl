#=
This script load the arduino with a batch program.
WARNING: this action may incurrer in data loss if done impropertly
=#

## ------------------------------------------------------
@time begin
    using CSCChemostatMonitor
    using LibSerialPort
end

## ------------------------------------------------------
let
    # config
    progname = "BASHV1"
    baudrate = 9600
    portname = "/dev/tty.usbmodem14101"

    # Chemostat
    global CH = Chemostat(portname, baudrate)

    # Set program
    # MAIN
    fn = "MAIN"
    sendcmd(CH, "SD-REMOVE", fn)
    sendcmd(CH, "SD-SET-FILE", fn)
    sendcmd(CH, "SD-SET-LINE", progname)
    sendcmd(CH, "SD-WRITELINE")
    
    # PROGRESS
    fn = "PROGRESS"
    sendcmd(CH, "SD-REMOVE", fn)
    sendcmd(CH, "SD-SET-FILE", fn)
    sendcmd(CH, "SD-SET-LINE", "0")
    sendcmd(CH, "SD-WRITELINE")

    # CHAPTER
    fn = string(progname, "/JOMPTO")
    sendcmd(CH, "SD-REMOVE", fn)
    sendcmd(CH, "SD-SET-FILE", fn)
    sendcmd(CH, "SD-SET-LINE", "NULL")
    sendcmd(CH, "SD-WRITELINE")

    fn = string(progname, "/JOMPAT")
    sendcmd(CH, "SD-REMOVE", fn)
    sendcmd(CH, "SD-SET-FILE", fn)
    sendcmd(CH, "SD-SET-LINE", "10000000000")
    sendcmd(CH, "SD-WRITELINE")

    fn = string(progname, "/DATAHEADER")
    sendcmd(CH, "SD-REMOVE", fn)
    
    fn = string(progname, "/DATA")
    sendcmd(CH, "SD-REMOVE", fn)

    # close
    close(CH)

end

## ------------------------------------------------------



## ------------------------------------------------------
let
    # Cmd Recieved 15755-2488 $ECHO:BLA%
    while !sendcmd(CH, "ECHO", "BLA")
        println("Cmd failed")
    end
    nothing
end
