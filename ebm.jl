function DICE_EBM(t, F; ζ = [0.098, 3.8/2.9, 0.088, 0.025], physics=nothing, default="DICE-2013r", Δt = nothing)    
    if isnothing(physics)
        if default == "Geoffroy-2013"
            physics = Dict("Δt" => Δt, "Cu" => 7.3, "Cd" => 106., "κ" => 0.73, "B" => 1.13)
        elseif default == "Geoffroy-NoMixing"
            physics = Dict("Δt" => Δt, "Cu" => 7.3, "Cd" => 106., "κ" => 0.0, "B" => 1.13)
        elseif default == "MARGO"
            physics = Dict("Δt" => Δt, "Cu" => 0., "Cd" => 106., "κ" => 0.73, "B" => 1.13)
        elseif default == "DICE-2013r"
            physics = nothing
        elseif default == "DICE-NoMixing"
            physics = nothing
            ζ[3] = 0.
        end
    end
        
    if !isnothing(physics)
        ζ[1] = Δt/physics["Cu"]
        ζ[2] = physics["B"]
        ζ[3] = physics["κ"]
        ζ[4] = physics["κ"]*physics["Δt"]/physics["Cd"]
    end
    
    if isnothing(Δt)
        print("Need to set Δt!")
    end 
    
    T = zeros(size(t))
    T_LO = zeros(size(t))
    
    for i = 1:length(t)-1
        if ζ[1] == Inf
            T[i+1] = (F[i] + ζ[3]*T_LO[i]) / (ζ[2] + ζ[3])
        else
            T[i+1] = T[i] + ζ[1]*(F[i] - ζ[2]*T[i] - ζ[3]*(T[i] - T_LO[i]))
        end
        T_LO[i+1] = T_LO[i] + ζ[4]*(T[i] - T_LO[i])
    end
    
    return T
end;