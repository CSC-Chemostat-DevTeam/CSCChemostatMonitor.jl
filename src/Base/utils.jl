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
function _crc16_hash(crc::UInt16, str::String)
    for c in str
        crc = _crc16_hash(crc, c)
    end
    return crc
end

function _match(reg::Regex, str::String)
    rm = match(reg, str)
    return !isnothing(rm)
end
_match(reg::String, str::String) = _match(Regex(reg), str)