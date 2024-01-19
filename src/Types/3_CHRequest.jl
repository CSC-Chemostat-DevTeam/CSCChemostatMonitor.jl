struct CHRequest
    key::String
    vals::Vector{String}
end

function CHRequest(req::String)
    req = replace(req, "\$" => "")
    req = strip(req)
    vals = split(req, ":")
    key = popfirst!(vals)

    return CHRequest(string(key), string.(vals))
end

## -------------------------

import Base.getkey
getkey(r::CHRequest) = r.key
getval(r::CHRequest, i) = checkbounds(Bool, r.vals, i) ? r.vals[i] : ""
getval(r::CHRequest) = getval(r, 1)

import Base.haskey
haskey(r::CHRequest, key0::String) = isequal(getkey(r), key0)
haskeyprefix(r::CHRequest, pf::String) = startswith(getkey(r), pf)
haskeysuffix(r::CHRequest, sf::String) = endswith(getkey(r), pf)
