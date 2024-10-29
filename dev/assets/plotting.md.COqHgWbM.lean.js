import{_ as l,c as n,a4 as t,j as e,a as s,G as o,B as d,o as r}from"./chunks/framework.CsgBfYqC.js";const C=JSON.parse('{"title":"Plotting","description":"","frontmatter":{},"headers":[],"relativePath":"plotting.md","filePath":"plotting.md","lastUpdated":null}'),p={name:"plotting.md"},c={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""};function v(j,a,y,S,A,x){const i=d("Badge");return r(),n("div",null,[a[24]||(a[24]=t('<h1 id="plotting" tabindex="-1">Plotting <a class="header-anchor" href="#plotting" aria-label="Permalink to &quot;Plotting&quot;">​</a></h1><p>Sargassum.jl has built-in plotting via the <a href="/Sargassum.jl/dev/plotting#Sargassum.viz"><code>viz</code></a> function. In general, all of the key objects across the ecosystem such as <a href="/Sargassum.jl/dev/simulation-api#Sargassum.InterpolatedField"><code>InterpolatedField</code></a>, <a href="/Sargassum.jl/dev/simulation-api#Sargassum.RaftTrajectory"><code>RaftTrajectory</code></a> and <a href="/Sargassum.jl/dev/afai-api#SargassumDistribution"><code>SargassumDistribution</code></a> can all be visualized quickly with <code>viz(object)</code>. Sargassum.jl further interfaces easily with Julia&#39;s <a href="https://docs.makie.org/stable/" target="_blank" rel="noreferrer">Makie</a> plotting system via the <a href="/Sargassum.jl/dev/plotting#Sargassum.viz!"><code>viz!</code></a> function. This allows Sargassum.jl objects to be plotted on a preexisting axis for greater control over the style of the plot. Refer to the full documentation of <code>viz</code> and <code>viz!</code> for further details.</p><h2 id="index" tabindex="-1">Index <a class="header-anchor" href="#index" aria-label="Permalink to &quot;Index&quot;">​</a></h2><h2 id="Core-Functions" tabindex="-1">Core Functions <a class="header-anchor" href="#Core-Functions" aria-label="Permalink to &quot;Core Functions {#Core-Functions}&quot;">​</a></h2>',4)),e("details",c,[e("summary",null,[a[0]||(a[0]=e("a",{id:"Sargassum.EUREKA",href:"#Sargassum.EUREKA"},[e("span",{class:"jlbinding"},"Sargassum.EUREKA")],-1)),a[1]||(a[1]=s()),o(i,{type:"info",class:"jlObjectType jlConstant",text:"Constant"})]),a[2]||(a[2]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> EUREKA</span></span></code></pre></div><p>A <code>ColorSchemes.ColorScheme</code> ranging from white, to blue, to yellow, to orange, to rust.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/PlottingCore/eureka.jl#L9-L13" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",u,[e("summary",null,[a[3]||(a[3]=e("a",{id:"Sargassum.SHADDEN",href:"#Sargassum.SHADDEN"},[e("span",{class:"jlbinding"},"Sargassum.SHADDEN")],-1)),a[4]||(a[4]=s()),o(i,{type:"info",class:"jlObjectType jlConstant",text:"Constant"})]),a[5]||(a[5]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> SHADDEN</span></span></code></pre></div><p>A <code>ColorSchemes.ColorScheme</code> ranging from white, to light blue, to light green, to yellow, to red.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/PlottingCore/shadden.jl#L68-L72" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",g,[e("summary",null,[a[6]||(a[6]=e("a",{id:"Sargassum.GEO_THEME-Tuple{}",href:"#Sargassum.GEO_THEME-Tuple{}"},[e("span",{class:"jlbinding"},"Sargassum.GEO_THEME")],-1)),a[7]||(a[7]=s()),o(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),a[8]||(a[8]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">GEO_THEME</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>This is a <code>Makie.Theme</code> where the <code>x</code> and <code>y</code> axes are appropriate for degrees N/S and E/W.</p><p>Use this theme in your <code>Makie</code> plots by including <code>set_theme!(GEO_THEME())</code>.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/PlottingCore/geo_theme.jl#L21-L27" target="_blank" rel="noreferrer">source</a></p>',4))]),e("details",h,[e("summary",null,[a[9]||(a[9]=e("a",{id:"Sargassum.land!-Tuple{Axis}",href:"#Sargassum.land!-Tuple{Axis}"},[e("span",{class:"jlbinding"},"Sargassum.land!")],-1)),a[10]||(a[10]=s()),o(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),a[11]||(a[11]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">land!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(axis; resolution, grid, landcolor, args</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Add a land heatmap to <code>axis::Makie.Axis</code>. This will be placed on top of any graphics that are already on the axis. The land is gray by default. Returns <code>Makie.poly!</code>.</p><p>The land data is provided by <code>NaturalEarth.jl</code>.</p><p><strong>Optional Arguments</strong></p><ul><li><p><code>resolution</code>: The parameter resolution should be either &quot;l&quot;, &quot;m&quot; or &quot;h&quot; (standing for low, medium and high resolution). This controls which features are visible, with smaller landmass &quot;switching on&quot; at higher resolutions. Default <code>&quot;m&quot;</code>.</p></li><li><p><code>landcolor</code>: The color of the landmass. Default <code>RGBf(0.5, 0.5, 0.5)</code>.</p></li><li><p><code>args...</code>: All keyword arguments are passed directly to <code>Makie.heatmap!</code>.</p></li></ul><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/PlottingCore/land.jl#L1-L14" target="_blank" rel="noreferrer">source</a></p>',6))]),a[25]||(a[25]=e("h2",{id:"afai-specific",tabindex:"-1"},[s("AFAI-specific "),e("a",{class:"header-anchor",href:"#afai-specific","aria-label":'Permalink to "AFAI-specific"'},"​")],-1)),e("details",m,[e("summary",null,[a[12]||(a[12]=e("a",{id:"Sargassum.clouds!-Tuple{Axis, Union{AFAI, SargassumDistribution}, Integer}",href:"#Sargassum.clouds!-Tuple{Axis, Union{AFAI, SargassumDistribution}, Integer}"},[e("span",{class:"jlbinding"},"Sargassum.clouds!")],-1)),a[13]||(a[13]=s()),o(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),a[14]||(a[14]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">clouds!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ax, dist, week; args</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Add a heatmap of <code>dist.clouds[:, :, week]</code> to <code>ax::Makie.Axis</code>, where dist can be <a href="/Sargassum.jl/dev/afai-api#Sargassum.AFAI"><code>AFAI</code></a> or <a href="/Sargassum.jl/dev/afai-api#SargassumDistribution"><code>SargassumDistribution</code></a>.</p><p><strong>Optional Arguments</strong></p><ul><li><code>args...</code>: All keyword arguments are passed directly to <code>Makie.heatmap!</code>.</li></ul><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/Plotting/afai.jl#L30-L38" target="_blank" rel="noreferrer">source</a></p>',5))]),e("details",b,[e("summary",null,[a[15]||(a[15]=e("a",{id:"Sargassum.coast!-Tuple{Axis, Union{AFAI, SargassumDistribution}}",href:"#Sargassum.coast!-Tuple{Axis, Union{AFAI, SargassumDistribution}}"},[e("span",{class:"jlbinding"},"Sargassum.coast!")],-1)),a[16]||(a[16]=s()),o(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),a[17]||(a[17]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">coast!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ax, dist; args</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Add a heatmap of <code>dist.coast</code> to <code>ax::Makie.Axis</code>, where dist can be <a href="/Sargassum.jl/dev/afai-api#Sargassum.AFAI"><code>AFAI</code></a> or <a href="/Sargassum.jl/dev/afai-api#SargassumDistribution"><code>SargassumDistribution</code></a>.</p><p><strong>Optional Arguments</strong></p><ul><li><code>args...</code>: All keyword arguments are passed directly to <code>Makie.heatmap!</code>.</li></ul><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/Plotting/afai.jl#L1-L9" target="_blank" rel="noreferrer">source</a></p>',5))]),a[26]||(a[26]=e("h2",{id:"General-objects",tabindex:"-1"},[s("General objects "),e("a",{class:"header-anchor",href:"#General-objects","aria-label":'Permalink to "General objects {#General-objects}"'},"​")],-1)),e("details",f,[e("summary",null,[a[18]||(a[18]=e("a",{id:"Sargassum.viz",href:"#Sargassum.viz"},[e("span",{class:"jlbinding"},"Sargassum.viz")],-1)),a[19]||(a[19]=s()),o(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),a[20]||(a[20]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">viz</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(object, [spec]; args</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Create a visualization of <code>object</code>. This function is defined on many objects, the complete list is as follows.</p><p>Refer to <a href="/Sargassum.jl/dev/plotting#Sargassum.viz!"><code>viz!</code></a> for the mutating version (i.e in the case where you want to add a visualization to an existing plot).</p><p><strong>AFAI Objects</strong></p><p>The following optional arguments apply to all functions unless otherwise noted.</p><ul><li><p><code>show_coast</code>: Highlight the coastlines in each graph via <a href="/Sargassum.jl/dev/plotting#Sargassum.coast!-Tuple{Axis, Union{AFAI, SargassumDistribution}}"><code>coast!</code></a>.</p></li><li><p><code>show_clouds</code>: Highlight clouds/missing data in each graph via <a href="/Sargassum.jl/dev/plotting#Sargassum.clouds!-Tuple{Axis, Union{AFAI, SargassumDistribution}, Integer}"><code>clouds!</code></a>.</p></li><li><p><code>limits</code>: A <code>NTuple{4, Int64}</code> giving the limits of the graph in the form <code>(lon_min, lon_max, lat_min, lat_max)</code>.</p></li><li><p><code>log_scale</code>: If <code>true</code>, plot on a logarithmic scale.</p></li></ul><p><strong>AFAI</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz(afai; show_coast, show_clouds, limits, thresh)</span></span></code></pre></div><p>Plot <a href="/Sargassum.jl/dev/afai-api#Sargassum.AFAI"><code>AFAI</code></a> for each of the four weeks on one graph. This function has the <code>thresh</code> argument instead of <code>log_scale</code>. Set <code>thresh</code> to a number between 0 and 1 to cut off all data below the <code>thresh</code> quantile. This can help to see the pixels with high AFAI values.</p><p><strong>SargassumDistribution Full</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz(sargassum_distribution; show_coast, show_clouds, limits, log_scale)</span></span></code></pre></div><p>Plot <a href="/Sargassum.jl/dev/afai-api#SargassumDistribution"><code>SargassumDistribution</code></a> for each of the four weeks in one graph.</p><p><strong>SargassumDistribution Weekly</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz(sargassum_distribution, week; show_coast, show_clouds, limits, log_scale)</span></span></code></pre></div><p>Plot <a href="/Sargassum.jl/dev/afai-api#SargassumDistribution"><code>SargassumDistribution</code></a> for the week <code>week</code>.</p><p><strong>Interpolant Objects</strong></p><p><strong>InterpolatedField</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz(itp, field; limits, time, show_land, n_points)</span></span></code></pre></div><p>Plot a <a href="/Sargassum.jl/dev/simulation-api#Sargassum.InterpolatedField"><code>InterpolatedField</code></a> or a <code>Ref{InterpolatedField}</code>. The field <code>field</code> is plotted, which should be a <code>Symbol</code> corresponding to the name of the field. Use <code>fields(itp)</code> to check which fields are available.</p><p><strong>Optional Arguments</strong></p><ul><li><p><code>limits</code>: If provided, the plot will be displayed in the region <code>lon_min, lon_max, lat_min, lat_min = limits</code>. Otherwise it is displayed according to <code>lon_min, lon_max, lat_min, lat_min = boundary(itp)</code>. Default <code>nothing</code>.</p></li><li><p><code>time</code>: If the interpolant is time dependent, plot it at this time. Default the first available time from <code>limits(itp)</code>.</p></li><li><p><code>show_land</code>: If <code>true</code>, overlay a plot of land. Default <code>true</code>.</p></li><li><p><code>n_points</code>: The number of points to use in each dimension of the plot, more gives higher resolution. Default <code>100</code>.</p></li></ul><p><strong>Simulation Objects</strong></p><p><strong>Trajectory and RaftTrajectory</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz(traj; limits)</span></span></code></pre></div><p>Visualize a <a href="/Sargassum.jl/dev/simulation-api#Sargassum.Trajectory"><code>Trajectory</code></a> or <a href="/Sargassum.jl/dev/simulation-api#Sargassum.RaftTrajectory"><code>RaftTrajectory</code></a> on a plot with <code>lon_min, lon_max, lat_min, lat_min = limits</code></p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/Plotting/viz.jl#L1-L57" target="_blank" rel="noreferrer">source</a></p>',26))]),e("details",k,[e("summary",null,[a[21]||(a[21]=e("a",{id:"Sargassum.viz!",href:"#Sargassum.viz!"},[e("span",{class:"jlbinding"},"Sargassum.viz!")],-1)),a[22]||(a[22]=s()),o(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),a[23]||(a[23]=t('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">viz!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(axis, object, [spec]; args</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Add a visualization of <code>object</code> to <code>axis</code>. This function is defined on many objects, the complete list is as follows.</p><p>Refer to <a href="/Sargassum.jl/dev/plotting#Sargassum.viz"><code>viz</code></a> for the non-mutating version (i.e in the case where you want an &quot;all-in-one&quot; solution).</p><p><strong>AFAI Objects</strong></p><p><strong>SargassumDistribution</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz!(axis, sargassum_distribution, week; show_coast, show_clouds, log_scale, args...)</span></span></code></pre></div><p>Add a plot of <a href="/Sargassum.jl/dev/afai-api#SargassumDistribution"><code>SargassumDistribution</code></a> for the week <code>week</code> to <code>Axis::Makie.Axis</code>. Returns a <code>Makie.heatmap!</code>.</p><p><strong>Optional Arguments</strong></p><ul><li><p><code>show_coast</code>: Highlight the coastlines in each graph via <a href="/Sargassum.jl/dev/plotting#Sargassum.coast!-Tuple{Axis, Union{AFAI, SargassumDistribution}}"><code>coast!</code></a>. Default <code>false</code>.</p></li><li><p><code>show_clouds</code>: Highlight clouds/missing data in each graph via <a href="/Sargassum.jl/dev/plotting#Sargassum.clouds!-Tuple{Axis, Union{AFAI, SargassumDistribution}, Integer}"><code>clouds!</code></a>. Default <code>false</code>.</p></li><li><p><code>log_scale</code>: Plot on a <code>log10</code> scale. Default <code>false</code>.</p></li><li><p><code>args...</code>: All keyword arguments are passed directly to <code>Makie.heatmap!</code>.</p></li></ul><p><strong>Interpolant Objects</strong></p><p><strong>InterpolatedField</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz!(ax, itp, field; time, n_points)</span></span></code></pre></div><p>Add a plot of <a href="/Sargassum.jl/dev/simulation-api#Sargassum.InterpolatedField"><code>InterpolatedField</code></a> or a <code>Ref{InterpolatedField}</code> to <code>Axis::Makie.Axis</code>. Returns a <code>Makie.heatmap!</code>.</p><p>The field <code>field</code> is plotted, which should be a <code>Symbol</code> corresponding to the name of the field. Use <code>fields(itp)</code> to check which fields are available.</p><p><strong>Optional Arguments</strong></p><ul><li><p><code>time</code>: If the interpolant is time dependent, plot it at this time. Default the first available time from <code>limits(itp)</code>.</p></li><li><p><code>n_points</code>: The number of points to use in each dimension of the plot, more gives higher resolution. Default <code>100</code>.</p></li></ul><p><strong>Simulation Objects</strong></p><p><strong>Trajectory and RaftTrajectory</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz!(ax, traj; args...)</span></span></code></pre></div><p>Add a line plot of <a href="/Sargassum.jl/dev/simulation-api#Sargassum.Trajectory"><code>Trajectory</code></a> or <a href="/Sargassum.jl/dev/simulation-api#Sargassum.RaftTrajectory"><code>RaftTrajectory</code></a> to <code>Axis::Makie.Axis</code>. Returns a <code>Makie.lines!</code>. <code>args...</code> are passed directly to <code>Makie.lines!</code>.</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz!(ax, rtraj, lon_bins, lat_bins; log_scale, args...)</span></span></code></pre></div><p>Add a heatmap plot of <a href="/Sargassum.jl/dev/simulation-api#Sargassum.RaftTrajectory"><code>RaftTrajectory</code></a> to <code>Axis::Makie.Axis</code>. The heatmap is binned according to <code>lon_bins</code> and <code>lat_bins</code>, which should be ranges. Pass <code>log_scale = true</code> to plot on a log scale. <code>args...</code> are passed directly to <code>Makie.heatmap!</code>.</p><p><code>rtraj</code> can be a single <a href="/Sargassum.jl/dev/simulation-api#Sargassum.RaftTrajectory"><code>RaftTrajectory</code></a> or a vector.</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>viz!(ax, rtraj, dist, week; log_scale, args...)</span></span></code></pre></div><p>Add a heatmap plot of <a href="/Sargassum.jl/dev/simulation-api#Sargassum.RaftTrajectory"><code>RaftTrajectory</code></a> to <code>Axis::Makie.Axis</code>. The heatmap is binned with the same bin specification as <code>dist</code>, a <a href="/Sargassum.jl/dev/afai-api#SargassumDistribution"><code>SargassumDistribution</code></a> at week <code>week</code>. Pass <code>log_scale = true</code> to plot on a log scale. <code>args...</code> are passed directly to <code>Makie.heatmap!</code>.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/2b39baf573445329fcc89cde8a53191faae540ae/src/Plotting/viz.jl#L65-L119" target="_blank" rel="noreferrer">source</a></p>',26))])])}const T=l(p,[["render",v]]);export{C as __pageData,T as default};
