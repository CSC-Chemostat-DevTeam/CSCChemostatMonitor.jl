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
    # ----
# set MAIN
# ----
# $SD-SET-FILE:MAIN%
# $SD-SET-LINE:BATCH1%
# $SD-REMOVE:%
# $SD-WRITELINE:%
# $SD-READLINE:%
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



# ----
# set PROGRESS
# ----
# $SD-SET-FILE:PROGRESS%
# $SD-SET-LINE:0%
# $SD-REMOVE:%
# $SD-WRITELINE:%
# $SD-READLINE:%

# ----
# set JUMPAT
# ----
# $SD-SET-FILE:BATCH1/JUMPAT%
# $SD-SET-LINE:1000000000%
# $SD-REMOVE:%
# $SD-WRITELINE:%
# $SD-READLINE:%

# ----
# set JUMPTO
# ----
# $SD-SET-FILE:BATCH1/JUMPTO%
# $SD-SET-LINE:NOWHERE%
# $SD-REMOVE:%
# $SD-WRITELINE:%
# $SD-READLINE:%

# ----
# set MKDIR
# ----
# $SD-SET-FILE:BATCH1%
# $SD-SET-LINE:%
# $SD-REMOVE:%
# $SD-MKDIR:%

# ----
# set DATAHEADER
# ----

# ----
# set DATA
# ----

# ----
# Upload DATA
# $UPLOADER-SET-FILE:BATCH1/DATA%
# $UPLOADER-UPLOAD:%