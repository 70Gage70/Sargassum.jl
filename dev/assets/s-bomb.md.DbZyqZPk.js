import{_ as h,c as p,a4 as n,G as i,w as t,B as o,o as d,j as a,a as s}from"./chunks/framework.CIT3Sm_W.js";const c="/Sargassum.jl/dev/assets/sdnizxa.Q8_hRXfm.png",v=JSON.parse('{"title":"SargassumBOMB.jl","description":"","frontmatter":{},"headers":[],"relativePath":"s-bomb.md","filePath":"s-bomb.md","lastUpdated":null}'),u={name:"s-bomb.md"};function g(k,e,m,b,y,f){const l=o("PluginTabsTab"),r=o("PluginTabs");return d(),p("div",null,[e[6]||(e[6]=n(`<h1 id="sargassumbomb-jl" tabindex="-1">SargassumBOMB.jl <a class="header-anchor" href="#sargassumbomb-jl" aria-label="Permalink to &quot;SargassumBOMB.jl&quot;">​</a></h1><p><a href="https://github.com/70Gage70/SargassumBOMB.jl" target="_blank" rel="noreferrer"><code>SargassumBOMB.jl</code></a> contains all of the core simulation functionality in Sargassum.jl and is the largest package in the ecosystem. To follow along with this tutorial, ensure that Sargassum.jl has been installed with the default interpolants as described in <a href="./getting-started">Getting Started</a>.</p><h1 id="First-Steps" tabindex="-1">First Steps <a class="header-anchor" href="#First-Steps" aria-label="Permalink to &quot;First Steps {#First-Steps}&quot;">​</a></h1><p>Before doing anything else, ensure that the package is loaded into your Julia session,</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Sargassum</span></span></code></pre></div><p>The highest level function in the package is <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.simulate-Tuple{RaftParameters}"><code>simulate</code></a>, which takes one mandatory argument, a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.RaftParameters"><code>RaftParameters</code></a> object. The general plan is therefore to build the <code>RaftParameters</code> object that defines the problem we want to solve. Then, we will simply invoke <code>simulate</code>.</p><p>To get up and running as fast as possible, we can use the built-in <a href="./s-bomb-examples-api"><code>Examples</code></a> module to generate our <code>RaftParameters</code>.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">rp </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Examples</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">QuickRaftParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span> RaftParameters</span></span>
<span class="line"><span>ICS = InitialConditions[time ∈ (2018-04-13T00:00:00, 2018-04-15T00:00:00), n_clumps = 25, lon/lat ∈ (-55.0, -50.0) × (5.0, 10.0)]</span></span>
<span class="line"><span>Clumps = ClumpParameters[α = 0.005427, τ = 0.01864, R = 0.7883, Ω = 6.283, σ = 0.0]</span></span>
<span class="line"><span>Springs = BOMBSpring[A = 1.0, L = 151.9592522325231]</span></span>
<span class="line"><span>Connections = ConnectionsNearest</span></span>
<span class="line"><span>GrowthDeath = ImmortalModel</span></span></code></pre></div><p>Observe that <code>RaftParameters</code> prints out information about its contents, which we will discuss further later. For now, note that the initial conditions inform us that we are simulating from April 13, 2018 to April 15, 2018 with 25 clumps. A &quot;clump&quot; is a discrete chunk of Sargassum. In the language of Sargassum.jl, a &quot;Raft&quot; is a collection of any number of clumps (including a single clump). Each clump in a raft shares a number of physics parameters via <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ClumpParameters"><code>ClumpParameters</code></a>. For now, we will proceed with the simulation.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">rtr </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> simulate</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rp)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>RaftTrajectory[25 trajectories, 21 times]</span></span></code></pre></div><p>The output of <code>simulate</code> is a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.RaftTrajectory"><code>RaftTrajectory</code></a> object. This holds all of the information about each clump&#39;s trajectory during the simulation. The easiest way to interpret the results of the simulation is to create a plot. We can use the <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.trajectory-Tuple{RaftTrajectory}"><code>trajectory</code></a> function to get a plot with some default arguments already chosen for us.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">trajectory</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rtr, limits </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">60</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">45</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">15</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)) </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># limits = (lon_min, lon_max, lat_min, lat_max)</span></span></code></pre></div><p><img src="`+c+'" alt=""></p><p>We see a small amount of movement off the coast of Brazil. Suppose we want to save this data for future analysis; for this we can use the <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.rtr2mat-Tuple{RaftTrajectory, String}"><code>rtr2mat</code></a> function to generate a <code>.mat</code> file which can be read in <a href="https://www.mathworks.com/help/matlab/ref/load.html" target="_blank" rel="noreferrer">MATLAB</a>, <a href="https://github.com/skjerns/mat7.3" target="_blank" rel="noreferrer">Python</a>, <a href="https://github.com/JuliaIO/MAT.jl" target="_blank" rel="noreferrer">Julia</a> and other languages with the appropriate package.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">rtr2mat</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rtr, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;first_steps.mat&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Check <code>pwd()</code> to see your current working directory, and find the file <code>first_steps.mat</code>.</p><h1 id="Building-your-own-RaftParameters" tabindex="-1">Building your own RaftParameters <a class="header-anchor" href="#Building-your-own-RaftParameters" aria-label="Permalink to &quot;Building your own RaftParameters {#Building-your-own-RaftParameters}&quot;">​</a></h1><h2 id="Introduction-to-RaftParameters" tabindex="-1">Introduction to RaftParameters <a class="header-anchor" href="#Introduction-to-RaftParameters" aria-label="Permalink to &quot;Introduction to RaftParameters {#Introduction-to-RaftParameters}&quot;">​</a></h2><p>We now provide a walkthrough of the construction of a <code>RaftParameters</code> object. We will essentially recreate <code>Examples.QuickRaftParameters()</code> to show how this is done. The signature of the basic <code>RaftParameters</code> constructor is</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">RaftParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; ics, clumps, springs, connections, gd_model, land, n_clumps_max, geometry </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> true</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, fast_raft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Each of this kwargs is defined as follows. We describe the fields with minimal jargon here, see <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.RaftParameters"><code>RaftParameters</code></a> for the full documentation.</p><ul><li><p><code>ics</code>: The initial conditions of the simulation, including coordinates and simulation time span. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.InitialConditions"><code>InitialConditions</code></a>.</p></li><li><p><code>clumps</code>: Physics parameters defining each (identical) clump; buoyancy, windage etc. Contained in a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ClumpParameters"><code>ClumpParameters</code></a> object.</p></li><li><p><code>springs</code>: Spring parameters defining each (identical) spring. Contained in a <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractSpring"><code>AbstractSpring</code></a> object.</p></li><li><p><code>connections</code>: Connections defining how the clumps are connected by the springs. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractConnections"><code>AbstractConnections</code></a> object.</p></li><li><p><code>gd_model</code>: A model controling how clumps grow and die due to biological effects. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractGrowthDeathModel"><code>AbstractGrowthDeathModel</code></a> object.</p></li><li><p><code>land</code>: A land model; how clumps should behave when reaching land. Contained in an <a href="/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractLand"><code>AbstractLand</code></a> object.</p></li><li><p><code>n_clumps_max</code>: The maximum number of clumps allowed to exist across the entire simulation. Should be a positive integer.</p></li><li><p><code>geometry</code>: A Boolean flag. If true, corrections are applied to account for the spherical geometry of the Earth. The default value of this is <code>true</code> and we will leave it alone for now.</p></li><li><p><code>fast_raft</code>: A Boolean flag that controls whether a &quot;total&quot; interpolant is created before the integration to save time on multiple evaluations. This is technical, and we omit the discussion for now. The default value of this flag is <code>false</code> and we leave this set as is.</p></li></ul><h2 id="Defining-each-argument" tabindex="-1">Defining each argument <a class="header-anchor" href="#Defining-each-argument" aria-label="Permalink to &quot;Defining each argument {#Defining-each-argument}&quot;">​</a></h2><p>Click the relevant tab to see how each argument is constructed.</p>',26)),i(r,null,{default:t(()=>[i(l,{label:"ics and n_clumps_max"},{default:t(()=>e[0]||(e[0]=[a("p",null,[s("We construct "),a("code",null,"ics"),s(", an "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.InitialConditions"},[a("code",null,"InitialConditions")]),s(" object. There are several constructors for different situations, but to create a rectangular arrangement, the appropriate constructor is")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"InitialConditions"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(t_span, x_range, y_range; to_xy)")])])])],-1),a("p",null,[s("The integration time span is controlled by "),a("code",null,"t_span"),s(", of the form "),a("code",null,"(t_initial, t_final)"),s(" and we want to integrate from April 13, 2018 to April 15, 2018. We can use Julia's built-in "),a("a",{href:"https://docs.julialang.org/en/v1/stdlib/Dates/",target:"_blank",rel:"noreferrer"},[a("code",null,"Dates")]),s(" module to easily define times as "),a("code",null,"DateTime(year, month, day)"),s(":")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"using"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}}," Dates")]),s(`
`),a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"t_initial "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," DateTime"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"2018"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"4"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"13"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")]),s(`
`),a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"t_final "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," DateTime"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"2018"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"4"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"15"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")]),s(`
`),a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"t_span "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}}," (t_initial, t_final)")])])])],-1),a("p",null,[s("Next, we need "),a("code",null,"x_range"),s(" and "),a("code",null,"y_range"),s(" which can be created quickly using "),a("code",null,"range(start, stop; length)"),s(". Our example consisted of a 5 x 5 grid of clumps off the coast of Brazil. We can recreate this via")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"x_range "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," range"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"-"),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"55.0"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"-"),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"50.0"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", length "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," 5"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")]),s(`
`),a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"y_range "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," range"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"("),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"5.0"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", "),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"10.0"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},", length "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," 5"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")])])])],-1),a("p",null,[s("Note that we have defined our ranges in terms of longitude/latitude. The optional argument "),a("code",null,"to_xy"),s(" of "),a("code",null,"InitialConditions"),s(" should therefore be set to "),a("code",null,"true"),s(" to automatically convert these spherical coordinates to equirectangular coordinates.")],-1),a("div",{class:"language-@example vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"@example"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",null,"ics = InitialConditions(t_span, x_range, y_range, to_xy = true)")])])])],-1),a("p",null,"While we're here, we can define the maximum number of clumps we want to allow. This example contains no biological effects, so the maximum number of clumps will simply be equal to the initial number of clumps, 25.",-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"n_clumps_max "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," 25")])])])],-1)])),_:1}),i(l,{label:"clumps"},{default:t(()=>e[1]||(e[1]=[a("p",null,[s("We construct "),a("code",null,"clumps"),s(", a "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ClumpParameters"},[a("code",null,"ClumpParameters")]),s(" object. Various physics constants can be set as desired e.g. the buoyancy of the clumps. For now, we will use the defaults and therefore simply have")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"clumps "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," ClumpParameters"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"()")])])])],-1),a("div",{class:"language- vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"}),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",null,"ClumpParameters[α = 0.005427, τ = 0.01864, R = 0.7883, Ω = 6.283, σ = 0.0]")])])])],-1)])),_:1}),i(l,{label:"springs"},{default:t(()=>e[2]||(e[2]=[a("p",null,[s("We construct "),a("code",null,"springs"),s(", a "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractSpring"},[a("code",null,"AbstractSpring")]),s(" object. Built in to Sargassum.jl are two basic spring types, "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.HookeSpring"},[a("code",null,"HookeSpring")]),s(" with a traditional Hookian stiffness and "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.BOMBSpring"},[a("code",null,"BOMBSpring")]),s(" with an adaptive stiffness. We will use the "),a("code",null,"BOMBSpring"),s(" here. Its constructor is")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"BOMBSpring"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(A, L)")])])])],-1),a("p",null,[s("Here, "),a("code",null,"A"),s(" represents the amplitude of the stiffness, and "),a("code",null,"L"),s(" represents the natural length of the spring. We will take the amplitude to be "),a("code",null,"A = 1"),s(". A convenient way to obtain "),a("code",null,"L"),s(" is using the function "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ΔL-Tuple{AbstractRange, AbstractRange}"},[a("code",null,"ΔL")]),s(", which takes an "),a("code",null,"InitialConditions"),s(" as its only argument and computes an appropriate natural spring length based on the average separation of clumps in their initial state. Recall that "),a("code",null,"Δ"),s(" can be entered by typing "),a("code",null,"\\Delta"),s(" and then pressing "),a("code",null,"TAB"),s(" on your keyboard. We therefore have")],-1),a("div",{class:"language-@example vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"@example"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",null,"springs = BOMBSpring(1.0, ΔL(ics))")])])])],-1)])),_:1}),i(l,{label:"connections"},{default:t(()=>e[3]||(e[3]=[a("p",null,[s("We construct "),a("code",null,"connections"),s(", a "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractConnections"},[a("code",null,"AbstractConnections")]),s(" object. Several connections types are available, here will will use "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ConnectionsNearest"},[a("code",null,"ConnectionsNearest")]),s(" to connect each clump to its 2 nearest neighbors. The signature of "),a("code",null,"ConnectionsNearest"),s(" is")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"ConnectionsNearest"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(n_clumps_max, neighbors)")])])])],-1),a("p",null,"Hence, we have",-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"connections "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," ConnectionsNearest"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(n_clumps_max, "),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}},"2"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},")")])])])],-1),a("div",{class:"language- vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"}),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",null,"ConnectionsNearest([Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[]  …  Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[], Int64[]], 2)")])])])],-1)])),_:1}),i(l,{label:"gd_model"},{default:t(()=>e[4]||(e[4]=[a("p",null,[s("We construct "),a("code",null,"gd_model"),s(", an "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractGrowthDeathModel"},[a("code",null,"AbstractGrowthDeathModel")]),s(" object. Built in to Sargassum.jl are two basic biological model types, "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.ImmortalModel"},[a("code",null,"ImmortalModel")]),s(" where clumps do not grow or die by biological effects and "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.BrooksModel"},[a("code",null,"BrooksModel")]),s(" with a full model based on "),a("a",{href:"https://www.int-res.com/abstracts/meps/v599/p1-18/",target:"_blank",rel:"noreferrer"},"Brooks et. al. (2018)"),s(". We will use the "),a("code",null,"ImmortalModel"),s(" here, which has a constructor with "),a("code",null,"n_clumps_max"),s(" as its only argument. Hence, we have")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"gd_model "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," ImmortalModel"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"(n_clumps_max)")])])])],-1),a("div",{class:"language- vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"}),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",null,"ImmortalModel")])])])],-1)])),_:1}),i(l,{label:"land"},{default:t(()=>e[5]||(e[5]=[a("p",null,[s("We construct "),a("code",null,"land"),s(", an "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.AbstractLand"},[a("code",null,"AbstractLand")]),s(" object. Built in to Sargassum.jl are two basic land model types, "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.NoLand"},[a("code",null,"NoLand")]),s(" where clumps do not interact with land and "),a("a",{href:"/Sargassum.jl/dev/s-bomb-api#SargassumBOMB.Land"},[a("code",null,"Land")]),s(" where clumps die when their position is within a polygon that defines land locations. We will use the "),a("code",null,"Land"),s(" here, which has a constructor with no arguments. Hence, we have")],-1),a("div",{class:"language-julia vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"julia"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"land "),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}},"="),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," Land"),a("span",{style:{"--shiki-light":"#24292E","--shiki-dark":"#E1E4E8"}},"()")])])])],-1),a("div",{class:"language- vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"}),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",null,"Land[land_itp = LAND_ITP.x]")])])])],-1)])),_:1})]),_:1}),e[7]||(e[7]=n(`<h2 id="application" tabindex="-1">Application <a class="header-anchor" href="#application" aria-label="Permalink to &quot;Application&quot;">​</a></h2><p>Now that all the appropriate arguments are defined, we simply use the <code>RaftParameters</code> constructor.</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>rp = RaftParameters(</span></span>
<span class="line"><span>    ics = ics,</span></span>
<span class="line"><span>    clumps = clumps,</span></span>
<span class="line"><span>    springs = springs,</span></span>
<span class="line"><span>    connections = connections,</span></span>
<span class="line"><span>    gd_model = gd_model,</span></span>
<span class="line"><span>    land = land,</span></span>
<span class="line"><span>    n_clumps_max = n_clumps_max</span></span>
<span class="line"><span>)</span></span></code></pre></div><p>And now we can simulate and plot as earlier:</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>rtr = simulate(rp)</span></span>
<span class="line"><span>trajectory(rtr, limits = (-60, -45, 0, 15))</span></span></code></pre></div><p>Comparing this to our earlier example, we see that they are indeed identical.</p>`,6))])}const C=h(u,[["render",g]]);export{v as __pageData,C as default};
