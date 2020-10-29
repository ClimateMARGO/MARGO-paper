import Base.+, Base.-, Base.*, Base.getindex, Base.length

function suboptimal_step_forward!(model::ClimateModel, model_previous::ClimateModel, Δt::Float64, suboptimality::Float64)
    Δ_idx = (t(model) .>= model.domain.present_year)
    Δcontrols = suboptimality*(model.controls - model_previous.controls)
    model.controls = model_previous.controls + (Δcontrols * Δ_idx)
    step_forward!(model, Δt)
end

function +(c1::Controls, c2::Controls)
    return Controls(
        c1.mitigate .+ c2.mitigate,
        c1.remove .+ c2.remove,
        c1.geoeng .+ c2.geoeng,
        c1.adapt .+ c2.adapt
    )
end

function -(c1::Controls, c2::Controls)
    return Controls(
        c1.mitigate .- c2.mitigate,
        c1.remove .- c2.remove,
        c1.geoeng .- c2.geoeng,
        c1.adapt .- c2.adapt
    )
end

function *(a::Float64, c::Controls)
    return Controls(
        a*c.mitigate,
        a*c.remove,
        a*c.geoeng,
        a*c.adapt
    )
end

function *(c::Controls, a::BitArray{1})
    return Controls(
        a.*c.mitigate,
        a.*c.remove,
        a.*c.geoeng,
        a.*c.adapt
    )
end