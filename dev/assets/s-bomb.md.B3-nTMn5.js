import{_ as r,c as p,a4 as n,G as e,w as t,B as h,o as d,j as s,a}from"./chunks/framework.CIT3Sm_W.js";const c="/Sargassum.jl/dev/assets/htdepqp.Q8_hRXfm.png",k="/Sargassum.jl/dev/assets/ulwbfmi.CheBV7Kp.png",v=JSON.parse('{"title":"SargassumBOMB.jl","description":"","frontmatter":{},"headers":[],"relativePath":"s-bomb.md","filePath":"s-bomb.md","lastUpdated":null}'),u={name:"s-bomb.md"};function g(m,i,E,b,y,f){const l=h("PluginTabsTab"),o=h("PluginTabs");return d(),p("div",null,[i[6]||(i[6]=n(`<h1 id="sargassumbomb-jl" tabindex="-1">SargassumBOMB.jl <a class="header-anchor" href="#sargassumbomb-jl" aria-label="Permalink to &quot;SargassumBOMB.jl&quot;">​</a></h1><p><a href="https://github.com/70Gage70/SargassumBOMB.jl" target="_blank" rel="noreferrer"><code>SargassumBOMB.jl</code></a> contains all of the core simulation functionality in Sargassum.jl and is the largest package in the ecosystem. To follow along with this tutorial, ensure that Sargassum.jl has been installed with the default interpolants as described in <a href="./getting-started">Getting Started</a>.</p><h1 id="First-Steps" tabindex="-1">First Steps <a class="header-anchor" href="#First-Steps" aria-label="Permalink to &quot;First Steps {#First-Steps}&quot;">​</a></h1><p>Before doing anything else, ensure that the package is loaded into your Julia session,</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Sargassum</span></span></code></pre></div><p>The highest level function in the package is <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.simulate-Tuple{RaftParameters}"><code>simulate</code></a>, which takes one mandatory argument, a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.RaftParameters"><code>RaftParameters</code></a> object. The general plan is therefore to build the <code>RaftParameters</code> object that defines the problem we want to solve. Then, we will simply invoke <code>simulate</code>.</p><p>To get up and running as fast as possible, we can use the built-in <a href="./s-bomb-examples-api"><code>Examples</code></a> module to generate our <code>RaftParameters</code>.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">rp </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Examples</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">QuickRaftParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span> RaftParameters</span></span>
<span class="line"><span>ICS = InitialConditions[time ∈ (2018-04-13T00:00:00, 2018-04-15T00:00:00), n_clumps = 25, lon/lat ∈ (-55.0, -50.0) × (5.0, 10.0)]</span></span>
<span class="line"><span>Clumps = ClumpParameters[α = 0.005427, τ = 0.01864, R = 0.7883, Ω = 6.283, σ = 0.0]</span></span>
<span class="line"><span>Springs = BOMBSpring[A = 1.0, L = 151.9592522325231]</span></span>
<span class="line"><span>Connections = ConnectionsNearest</span></span>
<span class="line"><span>GrowthDeath = ImmortalModel</span></span></code></pre></div><p>Observe that <code>RaftParameters</code> prints out information about its contents, which we will discuss further later. For now, note that the initial conditions inform us that we are simulating from April 13, 2018 to April 15, 2018 with 25 clumps. A &quot;clump&quot; is a discrete chunk of Sargassum. In the language of Sargassum.jl, a &quot;Raft&quot; is a collection of any number of clumps (including a single clump). Each clump in a raft shares a number of physics parameters via <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ClumpParameters"><code>ClumpParameters</code></a>. For now, we will proceed with the simulation.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">rtr </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> simulate</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rp)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>RaftTrajectory[25 trajectories, 21 times]</span></span></code></pre></div><p>The output of <code>simulate</code> is a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.RaftTrajectory"><code>RaftTrajectory</code></a> object. This holds all of the information about each clump&#39;s trajectory during the simulation. The easiest way to interpret the results of the simulation is to create a plot. We can use the <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.trajectory-Tuple{RaftTrajectory}"><code>trajectory</code></a> function to get a plot with some default arguments already chosen for us.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">trajectory</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rtr, limits </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">60</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">45</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">15</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)) </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># limits = (lon_min, lon_max, lat_min, lat_max)</span></span></code></pre></div><p><img src="`+c+'" alt=""></p><p>We see a small amount of movement off the coast of Brazil. Suppose we want to save this data for future analysis; for this we can use the <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.rtr2mat-Tuple{RaftTrajectory, String}"><code>rtr2mat</code></a> function to generate a <code>.mat</code> file which can be read in <a href="https://www.mathworks.com/help/matlab/ref/load.html" target="_blank" rel="noreferrer">MATLAB</a>, <a href="https://github.com/skjerns/mat7.3" target="_blank" rel="noreferrer">Python</a>, <a href="https://github.com/JuliaIO/MAT.jl" target="_blank" rel="noreferrer">Julia</a> and other languages with the appropriate package.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">rtr2mat</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rtr, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;first_steps.mat&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Check <code>pwd()</code> to see your current working directory, and find the file <code>first_steps.mat</code>.</p><h1 id="Building-your-own-RaftParameters" tabindex="-1">Building your own RaftParameters <a class="header-anchor" href="#Building-your-own-RaftParameters" aria-label="Permalink to &quot;Building your own RaftParameters {#Building-your-own-RaftParameters}&quot;">​</a></h1><h2 id="Introduction-to-RaftParameters" tabindex="-1">Introduction to RaftParameters <a class="header-anchor" href="#Introduction-to-RaftParameters" aria-label="Permalink to &quot;Introduction to RaftParameters {#Introduction-to-RaftParameters}&quot;">​</a></h2><p>We now provide a walkthrough of the construction of a <code>RaftParameters</code> object. We will essentially recreate <code>Examples.QuickRaftParameters()</code> to show how this is done. The signature of the basic <code>RaftParameters</code> constructor is</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">RaftParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; ics, clumps, springs, connections, gd_model, land, n_clumps_max, geometry </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> true</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, fast_raft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Each of this kwargs is defined as follows. We describe the fields with minimal jargon here, see <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.RaftParameters"><code>RaftParameters</code></a> for the full documentation.</p><ul><li><p><code>ics</code>: The initial conditions of the simulation, including coordinates and simulation time span. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.InitialConditions"><code>InitialConditions</code></a>.</p></li><li><p><code>clumps</code>: Physics parameters defining each (identical) clump; buoyancy, windage etc. Contained in a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ClumpParameters"><code>ClumpParameters</code></a> object.</p></li><li><p><code>springs</code>: Spring parameters defining each (identical) spring. Contained in a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractSpring"><code>AbstractSpring</code></a> object.</p></li><li><p><code>connections</code>: Connections defining how the clumps are connected by the springs. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractConnections"><code>AbstractConnections</code></a> object.</p></li><li><p><code>gd_model</code>: A model controling how clumps grow and die due to biological effects. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractGrowthDeathModel"><code>AbstractGrowthDeathModel</code></a> object.</p></li><li><p><code>land</code>: A land model; how clumps should behave when reaching land. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractLand"><code>AbstractLand</code></a> object.</p></li><li><p><code>n_clumps_max</code>: The maximum number of clumps allowed to exist across the entire simulation. Should be a positive integer.</p></li><li><p><code>geometry</code>: A Boolean flag. If true, corrections are applied to account for the spherical geometry of the Earth. The default value of this is <code>true</code> and we will leave it alone for now.</p></li><li><p><code>fast_raft</code>: A Boolean flag that controls whether a &quot;total&quot; interpolant is created before the integration to save time on multiple evaluations. This is technical, and we omit the discussion for now. The default value of this flag is <code>false</code> and we leave this set as is.</p></li></ul><h2 id="Defining-each-argument" tabindex="-1">Defining each argument <a class="header-anchor" href="#Defining-each-argument" aria-label="Permalink to &quot;Defining each argument {#Defining-each-argument}&quot;">​</a></h2><p>Click the relevant tab to see how each argument is constructed.</p>',26)),e(o,null,{default:t(()=>[e(l,{label:"ics and n_clumps_max"},{default:t(()=>i[0]||(i[0]=[s("p",null,[a("We construct "),s("code",null,"ics"),a(", an "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.InitialConditions"},[s("code",null,"InitialConditions")]),a(" object. There are several constructors for different situations, but to create a rectangular arrangement, the appropriate constructor is")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"InitialConditions"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(t_span, x_range, y_range; to_xy)")])])])],-1),s("p",null,[a("The integration time span is controlled by "),s("code",null,"t_span"),a(", of the form "),s("code",null,"(t_initial, t_final)"),a(" and we want to integrate from April 13, 2018 to April 15, 2018. We can use Julia's built-in "),s("a",{href:"https://docs.julialang.org/en/v1/stdlib/Dates/",target:"_blank",rel:"noreferrer"},[s("code",null,"Dates")]),a(" module to easily define times as "),s("code",null,"DateTime(year, month, day)"),a(":")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"using"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}}," Dates")]),a(`
`),s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"t_initial "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," DateTime"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"2018"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"4"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"13"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")]),a(`
`),s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"t_final "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," DateTime"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"2018"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"4"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"15"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")]),a(`
`),s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"t_span "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}}," (t_initial, t_final)")])])])],-1),s("p",null,[a("Next, we need "),s("code",null,"x_range"),a(" and "),s("code",null,"y_range"),a(" which can be created quickly using "),s("code",null,"range(start, stop; length)"),a(". Our example consisted of a 5 x 5 grid of clumps off the coast of Brazil. We can recreate this via")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"x_range "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," range"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"-"),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"55.0"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"-"),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"50.0"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", length "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," 5"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")]),a(`
`),s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"y_range "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," range"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"5.0"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"10.0"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", length "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," 5"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")])])])],-1),s("p",null,[a("Note that we have defined our ranges in terms of longitude/latitude. The optional argument "),s("code",null,"to_xy"),a(" of "),s("code",null,"InitialConditions"),a(" should therefore be set to "),s("code",null,"true"),a(" to automatically convert these spherical coordinates to equirectangular coordinates.")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"ics "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," InitialConditions"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(t_span, x_range, y_range, to_xy "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," true"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")])])])],-1),s("div",{class:"language- vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"}),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",null,"InitialConditions[time ∈ (2018-04-13T00:00:00, 2018-04-15T00:00:00), n_clumps = 25, lon/lat ∈ (-55.0, -50.0) × (5.0, 10.0)]")])])])],-1),s("p",null,"While we're here, we can define the maximum number of clumps we want to allow. This example contains no biological effects, so the maximum number of clumps will simply be equal to the initial number of clumps, 25.",-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"n_clumps_max "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," 25")])])])],-1)])),_:1}),e(l,{label:"clumps"},{default:t(()=>i[1]||(i[1]=[s("p",null,[a("We construct "),s("code",null,"clumps"),a(", a "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ClumpParameters"},[s("code",null,"ClumpParameters")]),a(" object. Various physics constants can be set as desired e.g. the buoyancy of the clumps. For now, we will use the defaults and therefore simply have")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"clumps "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," ClumpParameters"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"()")])])])],-1),s("div",{class:"language- vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"}),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",null,"ClumpParameters[α = 0.005427, τ = 0.01864, R = 0.7883, Ω = 6.283, σ = 0.0]")])])])],-1)])),_:1}),e(l,{label:"springs"},{default:t(()=>i[2]||(i[2]=[s("p",null,[a("We construct "),s("code",null,"springs"),a(", a "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractSpring"},[s("code",null,"AbstractSpring")]),a(" object. Built in to Sargassum.jl are two basic spring types, "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.HookeSpring"},[s("code",null,"HookeSpring")]),a(" with a traditional Hookian stiffness and "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.BOMBSpring"},[s("code",null,"BOMBSpring")]),a(" with an adaptive stiffness. We will use the "),s("code",null,"BOMBSpring"),a(" here. Its constructor is")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"BOMBSpring"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(A, L)")])])])],-1),s("p",null,[a("Here, "),s("code",null,"A"),a(" represents the amplitude of the stiffness, and "),s("code",null,"L"),a(" represents the natural length of the spring. We will take the amplitude to be "),s("code",null,"A = 1"),a(". A convenient way to obtain "),s("code",null,"L"),a(" is using the function "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ΔL-Tuple{AbstractRange, AbstractRange}"},[s("code",null,"ΔL")]),a(", which takes an "),s("code",null,"InitialConditions"),a(" as its only argument and computes an appropriate natural spring length based on the average separation of clumps in their initial state. Recall that "),s("code",null,"Δ"),a(" can be entered by typing "),s("code",null,"\\Delta"),a(" and then pressing "),s("code",null,"TAB"),a(" on your keyboard. We therefore have")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"springs "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," BOMBSpring"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"1.0"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"ΔL"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(ics))")])])])],-1),s("div",{class:"language- vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"}),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",null,"BOMBSpring[A = 1.0, L = 151.9592522325231]")])])])],-1)])),_:1}),e(l,{label:"connections"},{default:t(()=>i[3]||(i[3]=[s("p",null,[a("We construct "),s("code",null,"connections"),a(", a "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractConnections"},[s("code",null,"AbstractConnections")]),a(" object. Several connections types are available, here will will use "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ConnectionsNearest"},[s("code",null,"ConnectionsNearest")]),a(" to connect each clump to its 2 nearest neighbors. The signature of "),s("code",null,"ConnectionsNearest"),a(" is")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"ConnectionsNearest"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(n_clumps_max, neighbors)")])])])],-1),s("p",null,"Hence, we have",-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"connections "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," ConnectionsNearest"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(n_clumps_max, "),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"2"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")])])])],-1),s("div",{class:"language- vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"}),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",null,"ConnectionsNearest([Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[]  …  Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[]], 2)")])])])],-1)])),_:1}),e(l,{label:"gd_model"},{default:t(()=>i[4]||(i[4]=[s("p",null,[a("We construct "),s("code",null,"gd_model"),a(", an "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractGrowthDeathModel"},[s("code",null,"AbstractGrowthDeathModel")]),a(" object. Built in to Sargassum.jl are two basic biological model types, "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ImmortalModel"},[s("code",null,"ImmortalModel")]),a(" where clumps do not grow or die by biological effects and "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.BrooksModel"},[s("code",null,"BrooksModel")]),a(" with a full model based on "),s("a",{href:"https://www.int-res.com/abstracts/meps/v599/p1-18/",target:"_blank",rel:"noreferrer"},"Brooks et. al. (2018)"),a(". We will use the "),s("code",null,"ImmortalModel"),a(" here, which has a constructor with "),s("code",null,"n_clumps_max"),a(" as its only argument. Hence, we have")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"gd_model "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," ImmortalModel"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(n_clumps_max)")])])])],-1),s("div",{class:"language- vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"}),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",null,"ImmortalModel")])])])],-1)])),_:1}),e(l,{label:"land"},{default:t(()=>i[5]||(i[5]=[s("p",null,[a("We construct "),s("code",null,"land"),a(", an "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractLand"},[s("code",null,"AbstractLand")]),a(" object. Built in to Sargassum.jl are two basic land model types, "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.NoLand"},[s("code",null,"NoLand")]),a(" where clumps do not interact with land and "),s("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.Land"},[s("code",null,"Land")]),a(" where clumps die when their position is within a polygon that defines land locations. We will use the "),s("code",null,"Land"),a(" here, which has a constructor with no arguments. Hence, we have")],-1),s("div",{class:"language-julia vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"},"julia"),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"land "),s("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),s("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," Land"),s("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"()")])])])],-1),s("div",{class:"language- vp-adaptive-theme"},[s("button",{title:"Copy Code",class:"copy"}),s("span",{class:"lang"}),s("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[s("code",null,[s("span",{class:"line"},[s("span",null,"Land[land_itp = LAND_ITP.x]")])])])],-1)])),_:1})]),_:1}),i[7]||(i[7]=n(`<h2 id="application" tabindex="-1">Application <a class="header-anchor" href="#application" aria-label="Permalink to &quot;Application&quot;">​</a></h2><p>Now that all the appropriate arguments are defined, we simply use the <code>RaftParameters</code> constructor.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">rp </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> RaftParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    ics </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ics,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    clumps </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> clumps,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    springs </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> springs,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    connections </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> connections,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    gd_model </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> gd_model,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    land </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> land,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    n_clumps_max </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> n_clumps_max</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span> RaftParameters</span></span>
<span class="line"><span>ICS = InitialConditions[time ∈ (2018-04-13T00:00:00, 2018-04-15T00:00:00), n_clumps = 25, lon/lat ∈ (-55.0, -50.0) × (5.0, 10.0)]</span></span>
<span class="line"><span>Clumps = ClumpParameters[α = 0.005427, τ = 0.01864, R = 0.7883, Ω = 6.283, σ = 0.0]</span></span>
<span class="line"><span>Springs = BOMBSpring[A = 1.0, L = 151.9592522325231]</span></span>
<span class="line"><span>Connections = ConnectionsNearest</span></span>
<span class="line"><span>GrowthDeath = ImmortalModel</span></span></code></pre></div><p>And now we can simulate and plot as earlier:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">rtr </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> simulate</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rp)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">trajectory</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rtr, limits </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">60</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">45</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">15</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">))</span></span></code></pre></div><p><img src="`+k+'" alt=""></p><p>Comparing this to our earlier example, we see that they are indeed identical.</p>',8))])}const B=r(u,[["render",g]]);export{v as __pageData,B as default};
