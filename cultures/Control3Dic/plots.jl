@time begin
    using CSV
    using CairoMakie
    using DataFrames
    using Statistics
end

## = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
function _renormalize(x::Vector, damp = 0.2)
    dth = mean(abs, diff(x))
    nx = copy(x)
    for i in eachindex(x)
        i == 1 && continue
        di = x[i] - x[i-1]
        abs(di) < dth && continue
        nx[i] = nx[i-1] + sign(di) * dth * damp
    end
    return nx
end

## = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
let
    fn = joinpath(@__DIR__, "data.txt")
    global df = CSV.read(fn, DataFrame)
    @show size(df)

    idxs = 8000:8700
    xs = idxs ./ size(df, 1)
    T = v -> _renormalize(float.(v), 0.0)
    
    f = Figure()
    ax = Axis(f[1:3,1:3], xlabel = "cul progress", ylabel = "led1");
    scatter!(ax, xs, T(df[idxs, 1]))

    ax = Axis(f[1:3,4:6], xlabel = "cul progress", ylabel = "led2");
    scatter!(ax, xs, T(df[idxs, 2]))
    
    ax = Axis(f[4:6, 1:3], xlabel = "cul progress", ylabel = "led1/led2");
    # scatter!(ax, xs, T(df[idxs, 1] ./ df[idxs, 2]))
    scatter!(ax, xs, df[idxs, 1] ./ df[idxs, 2])

    ax = Axis(f[4:6,4:6], xlabel = "cul progress", ylabel = "temp (Celsius)");
    scatter!(ax, xs, T(df[idxs, 3]))
    return f

end