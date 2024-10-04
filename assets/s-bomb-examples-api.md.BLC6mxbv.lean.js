import{_ as o,c as r,a4 as s,j as a,a as i,G as l,B as n,o as d}from"./chunks/framework.DQ6EixH3.js";const x=JSON.parse('{"title":"SargassumBOMB.Examples API","description":"","frontmatter":{},"headers":[],"relativePath":"s-bomb-examples-api.md","filePath":"s-bomb-examples-api.md","lastUpdated":null}'),p={name:"s-bomb-examples-api.md"},u={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""};function c(g,e,h,f,b,B){const t=n("Badge");return d(),r("div",null,[e[6]||(e[6]=s('<h1 id="SargassumBOMB.Examples-API" tabindex="-1">SargassumBOMB.Examples API <a class="header-anchor" href="#SargassumBOMB.Examples-API" aria-label="Permalink to &quot;SargassumBOMB.Examples API {#SargassumBOMB.Examples-API}&quot;">​</a></h1><p>These are the full docstrings for SargassumBOMB.Examples</p><h2 id="index" tabindex="-1">Index <a class="header-anchor" href="#index" aria-label="Permalink to &quot;Index&quot;">​</a></h2><ul><li><a href="#SargassumBOMB.Examples.QuickRaftParameters-Tuple{}"><code>SargassumBOMB.Examples.QuickRaftParameters</code></a></li><li><a href="#SargassumBOMB.Examples.QuickRaftParameters-Tuple{Tuple{Integer, Integer, Integer}, Tuple{Integer, Integer, Integer}}"><code>SargassumBOMB.Examples.QuickRaftParameters</code></a></li></ul>',4)),a("details",u,[a("summary",null,[e[0]||(e[0]=a("a",{id:"SargassumBOMB.Examples.QuickRaftParameters-Tuple{Tuple{Integer, Integer, Integer}, Tuple{Integer, Integer, Integer}}",href:"#SargassumBOMB.Examples.QuickRaftParameters-Tuple{Tuple{Integer, Integer, Integer}, Tuple{Integer, Integer, Integer}}"},[a("span",{class:"jlbinding"},"SargassumBOMB.Examples.QuickRaftParameters")],-1)),e[1]||(e[1]=i()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[2]||(e[2]=s('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">QuickRaftParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ymw_initial, ymw_final; kwargs</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Generate a <a href="/Sargassum.jl.git/dev/s-bomb-api#SargassumBOMB.RaftParameters"><code>RaftParameters</code></a> object to integrate from <code>(year, month, week)</code> inital to final. The raft is initialized at the Sargassum distribution at <code>ymw_initial</code>.</p><p><strong>Optional Arguments</strong></p><ul><li><p><code>use_biology</code>: If <code>true</code>, include biological effects in the simulation. Default <code>false</code>.</p></li><li><p><code>n_levels</code>: This controls the number of initial clumps (higher is more clumps). See <a href="/Sargassum.jl.git/dev/s-bomb-api#SargassumBOMB.InitialConditions"><code>InitialConditions</code></a> for more detail. Default <code>5</code>.</p></li><li><p><code>n_connections</code>: The number of inter-clump nearest neighbor connectionsto form. Default <code>2</code>.</p></li><li><p><code>delta</code>: The bouyancy of the particle. Default: <code>1.14</code>.</p></li><li><p><code>tau</code>: The inertial response time, measured in days. Default <code>0.0103</code>.</p></li><li><p><code>sigma</code>: The Stokes drift coefficient. Default <code>1.20</code>.</p></li><li><p><code>A_spring</code>: The magnitude of the eBOMB spring stiffness. Default <code>15.1</code>.</p></li><li><p><code>lambda_spring</code>: A factor multiplying the springs&#39; natural lengths. Default <code>2.97</code>.</p></li><li><p><code>mu_max</code>: Sargassum maximum growth rate, measured in inverse days. Default <code>0.00542</code>.</p></li><li><p><code>m</code>: Sargassum mortality rate, measured in inverse days. Default <code>0.00403</code>.</p></li><li><p><code>k_N</code>: Sargassum nutrient (N) uptake half saturation, measured in mmol N/m^3. Default <code>0.000129</code>.</p></li><li><p><code>S_min</code>: A clump dies when it&#39;s &quot;amount&quot; drops below this value. Default <code>-0.00481</code>.</p></li><li><p><code>S_max</code>: A clump dies when it&#39;s &quot;amount&quot; grows above this value. Default <code>0.001</code>.</p></li><li><p><code>seed</code>: A seed for reproducible randomness, passed to <a href="/Sargassum.jl.git/dev/s-bomb-api#SargassumBOMB.InitialConditions"><code>InitialConditions</code></a>. Default <code>1234</code>.</p></li></ul><p><a href="https://github.com/70Gage70/SargassumBOMB.jl/blob/v0.7.9/examples/examples.jl#L42-L64" target="_blank" rel="noreferrer">source</a></p>',5))]),a("details",m,[a("summary",null,[e[3]||(e[3]=a("a",{id:"SargassumBOMB.Examples.QuickRaftParameters-Tuple{}",href:"#SargassumBOMB.Examples.QuickRaftParameters-Tuple{}"},[a("span",{class:"jlbinding"},"SargassumBOMB.Examples.QuickRaftParameters")],-1)),e[4]||(e[4]=i()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[5]||(e[5]=s('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">QuickRaftParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>Return a simple <a href="/Sargassum.jl.git/dev/s-bomb-api#SargassumBOMB.RaftParameters"><code>RaftParameters</code></a> suitable for testing purposes.</p><p><a href="https://github.com/70Gage70/SargassumBOMB.jl/blob/v0.7.9/examples/examples.jl#L8-L12" target="_blank" rel="noreferrer">source</a></p>',3))]),e[7]||(e[7]=s('<div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span></span></span></code></pre></div>',1))])}const S=o(p,[["render",c]]);export{x as __pageData,S as default};