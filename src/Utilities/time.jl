"""
    T_REF

The time to which all times are referred, default `January 1, 2000`.

This is a `Ref`, access or modify the actual value with `T_REF.x`.
"""
const T_REF = Ref{DateTime}(DateTime(2000, 1, 1))

"""
    time2months(yr::Integer, mnth::Integer)

Calculate the number of months since [`T_REF`](@ref) of the date with year `yr` and month `mnth`.

    time2months(yearmonth::Tuple{Integer, Integer})

Compute `time2months(yearmonth[1], yearmonth[2])`.

    time2months(time::DateTime)

Compute `time2months(year(time), month(time))`.

### Example

```julia
time2months(2018, 4)
219
```
"""
function time2months(yr::Integer, mnth::Integer)
    δyr = yr - year(T_REF.x)
    δmnth = mnth - month(T_REF.x)
    return 12*δyr + δmnth
end

function time2months(yearmonth::Tuple{Integer, Integer})
    δyr = yearmonth[1] - year(T_REF.x)
    δmnth = yearmonth[2] - month(T_REF.x)
    return 12*δyr + δmnth
end

function time2months(time::DateTime)
    δyr = year(time) - year(T_REF.x)
    δmnth = month(time) - month(T_REF.x)
    return 12*δyr + δmnth
end

"""
    months2time(months::Integer)

Calculate the date in `(year, month)` format after `months` months have elapsed since [`T_REF`](@ref).

### Example

```julia
months2time(219)
(2018, 4)
```
"""
function months2time(months::Integer)
    return yearmonth(T_REF.x + Month(months))
end

"""
    datetime2time(dt)

Convert `dt::DateTime` to the amount of time since [`T_REF`](@ref) expressed in the units of `UNITS["time"]`.

This inverts [`time2datetime`](@ref).
"""
function datetime2time(dt::DateTime)
    return uconvert(UNITS["time"], dt - T_REF.x) |> x -> float(x.val)
end

"""
    time2datetime(time)

Convert the amount of time since [`T_REF`](@ref) expressed in the units of `UNITS["time"]` to a `DateTime`.

By convention, `time` is rounded down to the nearest second.   

This inverts [`datetime2time`](@ref).
"""
function time2datetime(time::Real)
    t = uconvert(u"s", time * UNITS["time"]) |> x -> round(Int64, x.val)

    return T_REF.x + Second(t)
end

"""
    ymw2time(y, m, w)

Convert the time corresponding to the year `y`, month `m` and week `w` indicated into a single time measured in
days since [`T_REF`](@ref).

The days of the four weeks per month are defined as the 7th, 14th, 21nd and 28th.

Can be applied as `ymw2time((y, m , w))`.

This is the inverse of [`time2ymw`](@ref).
"""
function ymw2time(year::Integer, month::Integer, week::Integer)

    @argcheck week in [1, 2, 3, 4]

    return datetime2time(DateTime(year, month, 7*week))
end

function ymw2time(ymw::NTuple{3, Integer})
    ymw2time(ymw[1], ymw[2], ymw[3])
end

"""
    time2ymw(time)

Convert the time measured in days since [`T_REF`](@ref)
to the corresponding to the year `y`, month `m` and week `w`.

The days of the four weeks per month are defined as the 7th, 14th, 21nd and 28th.

This is the inverse of [`ymw2time`](@ref).
"""
function time2ymw(time::Real)
    y, m, d = yearmonthday(time2datetime(time))

    @argcheck d in [7, 14, 21, 28]

    return (y, m, Integer(d/7))
end

"""
    ymwspan2weekspan(ymw1, ymw2)

Return a vector list of all `(year, month, week)` tuples between `ym1 = (year1, month1, week1)` and `ym2 = (year2, month2, week2)` inclusive.
"""
function ymwspan2weekspan(ymw1::NTuple{3, Integer}, ymw2::NTuple{3, Integer})

    @argcheck ymw1[3] in [1, 2, 3, 4]
    @argcheck ymw2[3] in [1, 2, 3, 4]
    @argcheck ymw1 < ymw2

    times = [ymw1]
    cur_time = ymw1

    while cur_time < ymw2
        nexty, nextm, nextw = cur_time .+ (0, 0, 1)

        if nextw == 5
            nextw = 1
            nextm = nextm + 1

            if nextm == 13
                nextm = 1
                nexty = nexty + 1
            end
        end

        cur_time = (nexty, nextm, nextw)
        push!(times, cur_time)
    end


    return times
end

"""
    ymwplusweek(ymw, n_week)

Calculate the `(year, month, week)` after `n_week` weeks have passed since `ymw`.

### Example

`ymwplusweek((2018, 10, 2), 12) == (2019, 1, 2)`
"""
function ymwplusweek(ymw, n_week)
	y, m, w = ymw
	new_months, new_weeks = (0, 1) .+ divrem(w + n_week - 1, 4)
	new_years, new_months = (0, 1) .+ divrem(m + new_months - 1, 12)
	return (y + new_years, new_months, new_weeks)
end