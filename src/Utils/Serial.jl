import Base.readline
function readline(f::Function, ch::Chemostat)
    while true
        line = readline(ch.sp)
        f(line) == true && break
    end
end

import Base.write
function write(ch::Chemostat, msg)
    write(ch.sp, string(msg))
    sleep(0.1)
end

import Base.close
function close(ch::Chemostat)
    close(ch.sp)
end