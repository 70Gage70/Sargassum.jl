"""
    _download_with_progress(url, output_path)

Download file from `url` to `output_path` with a progress bar.
"""
function _download_with_progress(url::String, output_path::String)
    println("Downloading $url to $output_path")

    started = false

    function progress_callback(total, now)
        if total == 0
            if !started
                print("STARTING DOWNLOAD")
                started = true
            end
        else
            percent = round(now / total * 100, digits = 2)
            bar_length = 50
            filled_length = Int(round(bar_length * percent / 100))
            bar = "█"^filled_length * " "^(bar_length - filled_length)
            print("\r[$bar] $percent%")
        end
        flush(stdout)
    end

    Downloads.download(url, output_path; progress = progress_callback)
    flush(stdout)

    println("\nDownload complete!")

    return nothing
end


"""
    _download_with_progress_http(url, [local_path], [headers]; update_period=1, kw...)

Simular to `[_download_with_progress]`, but suitable for downloading `.nc` files from `https://cwcgom.aoml.noaa.gov/erddap/griddap`.
""" 
function _download_with_progress_http(
    url::AbstractString, 
    local_path = nothing, 
    headers = HTTP.Parsers.Header[]; 
    update_period = 1, 
    kw...)

    format_progress(x) = round(x, digits=4)
    format_bytes(x) = !isfinite(x) ? "∞ B" : Base.format_bytes(round(Int, x))
    format_seconds(x) = "$(round(x; digits=2)) s"
    format_bytes_per_second(x) = format_bytes(x) * "/s"

    local file
    hdrs = String[]
    HTTP.open("GET", url, headers; kw...) do stream
        println("Downloading $(url)")

        resp = startread(stream)

        # Store intermediate header from redirects to use for filename detection
        content_disp = HTTP.Messages.header(resp, "Content-Disposition")
        !isempty(content_disp) && push!(hdrs, content_disp)
        eof(stream) && return  # Don't do anything for streams we can't read (yet)

        file = HTTP.determine_file(local_path, resp, hdrs)
        total_bytes = parse(Float64, HTTP.Messages.header(resp, "Content-Length", "NaN"))
        downloaded_bytes = 0
        start_time = now()
        prev_time = now()

        # Use BufferedStream for efficient reading
        buf_stream = BufferedInputStream(stream)

        if HTTP.Messages.header(resp, "Content-Encoding") == "gzip"
            buf_stream = BufferedInputStream(GzipDecompressorStream(buf_stream))
            total_bytes = 200 * 1e6  # We don't know actual total bytes if the content is zipped
        end

        function report_callback()
            prev_time = now()
            taken_time = (prev_time - start_time).value / 1000  # in seconds

            println(" Total downloaded: $(downloaded_bytes |> format_bytes) in $(taken_time) seconds.")
            flush(stdout)
        end

        Base.open(file, "w") do fh
            while !eof(buf_stream)
                chunk = readavailable(buf_stream)
                downloaded_bytes += write(fh, chunk)

                if !isinf(update_period)
                    if now() - prev_time > Millisecond(round(1000 * update_period))
                        report_callback()
                        flush(stdout)
                    end
                end
            end
        end

        if !isinf(update_period)
            report_callback()
            flush(stdout)
        end
    end

    println("\nDownload complete!")

    file
end

"""
    vec2range(vector; force)

Convert a `Vector` of linearly spaced values to a `StepRangeLen`. 

If `force == true`, the range will be constructed even if the vector isn't linearly spaced by linear interpolation preserving the length. Default `false`.
"""
function vec2range(vector::Vector{<:Real}; force::Bool = false)
    if force
        return range(vector[1], vector[end], length = length(vector))
    end

    step_size = vector[2] - vector[1]
    for i in 2:length(vector)-1
        if abs(vector[i+1] - vector[i] - step_size) > 1e-10
            error("Input vector is not linearly spaced, expected $(step_size), got $(abs(vector[i+1] - vector[i])) at positions $((i, i + 1))")
        end
    end
    
    return vector[1]:step_size:vector[end]
end

"""
    clump_i(u, i)

Return a view to the the `[x, y]` coordinates of the `i`th clump in the solution matrix `u`. This is `view(u :,i)`.
"""
function clump_i(u::Matrix{Float64}, i::Integer)
    return view(u, :, i)
end

"""
    com(u)

Return the center of mass `[x, y]` coordinates of the solution matrix `u`.
"""
function com(u::Matrix{Float64})
    return [mean(u[1,:]), mean(u[2,:])]
end