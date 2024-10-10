import{_ as o,c as d,a4 as n,G as e,w as s,j as a,a as g,B as r,o as u}from"./chunks/framework.DKuTLT2j.js";const y=JSON.parse('{"title":"Getting Started with Sargassum.jl","description":"","frontmatter":{},"headers":[],"relativePath":"getting-started.md","filePath":"getting-started.md","lastUpdated":null}'),h={name:"getting-started.md"};function p(c,t,m,k,b,f){const i=r("PluginTabsTab"),l=r("PluginTabs");return u(),d("div",null,[t[4]||(t[4]=n('<h1 id="Getting-Started-with-Sargassum.jl" tabindex="-1">Getting Started with Sargassum.jl <a class="header-anchor" href="#Getting-Started-with-Sargassum.jl" aria-label="Permalink to &quot;Getting Started with Sargassum.jl {#Getting-Started-with-Sargassum.jl}&quot;">​</a></h1><h2 id="introduction" tabindex="-1">Introduction <a class="header-anchor" href="#introduction" aria-label="Permalink to &quot;Introduction&quot;">​</a></h2><p><code>Sargassum.jl</code> is a meta package for the <a href="https://julialang.org/" target="_blank" rel="noreferrer">Julia</a> programming language that bundles the following component packages all in one location.</p><ul><li><p><a href="https://github.com/70Gage70/SargassumInterface.jl" target="_blank" rel="noreferrer"><code>SargassumInterface.jl</code></a>: High level, zero-code interface.</p></li><li><p><a href="https://github.com/70Gage70/SargassumBOMB.jl" target="_blank" rel="noreferrer"><code>SargassumBOMB.jl</code></a>: Main modelling and simulation tools.</p></li><li><p><a href="https://github.com/70Gage70/SargassumFromAFAI.jl" target="_blank" rel="noreferrer"><code>SargassumFromAFAI.jl</code></a>: Downloading raw AFAI data and generating Sargassum distribution maps.</p></li><li><p><a href="https://github.com/70Gage70/SargassumColors.jl" target="_blank" rel="noreferrer"><code>SargassumColors.jl</code></a>: Color maps and general plot styling.</p></li></ul><p>Each of these packages can be used individually, but most end-users will want to simply use <code>Sargassum.jl</code> to have all functionality in one location. Together, this represents a fully featured Sargassum analysis toolkit.</p><p>Sargassum.jl was developed by the <a href="https://nonlinear.earth.miami.edu/index.html" target="_blank" rel="noreferrer">Nonlinear Dynamics Group</a> at the University of Miami. Refer <a href="./cite">here</a> for citation information.</p><h2 id="installation" tabindex="-1">Installation <a class="header-anchor" href="#installation" aria-label="Permalink to &quot;Installation&quot;">​</a></h2><h3 id="Step-1:-Installing-Julia" tabindex="-1">Step 1: Installing Julia <a class="header-anchor" href="#Step-1:-Installing-Julia" aria-label="Permalink to &quot;Step 1: Installing Julia {#Step-1:-Installing-Julia}&quot;">​</a></h3><p>Julia 1.10 or later is required to use this package. For most users, it is enough to run the following command in a terminal. See <a href="https://github.com/JuliaLang/juliaup" target="_blank" rel="noreferrer">here</a> for installation instructions if this is not sufficient.</p>',9)),e(l,null,{default:s(()=>[e(i,{label:"Mac/Linux"},{default:s(()=>t[0]||(t[0]=[a("div",{class:"language-sh vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"sh"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#6F42C1","--shiki-dark":"#B392F0"}},"curl"),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," -fsSL"),a("span",{style:{"--shiki-light":"#032F62","--shiki-dark":"#9ECBFF"}}," https://install.julialang.org"),a("span",{style:{"--shiki-light":"#D73A49","--shiki-dark":"#F97583"}}," |"),a("span",{style:{"--shiki-light":"#6F42C1","--shiki-dark":"#B392F0"}}," sh")])])])],-1)])),_:1}),e(i,{label:"Windows"},{default:s(()=>t[1]||(t[1]=[a("div",{class:"language-sh vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"sh"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#6F42C1","--shiki-dark":"#B392F0"}},"winget"),a("span",{style:{"--shiki-light":"#032F62","--shiki-dark":"#9ECBFF"}}," install"),a("span",{style:{"--shiki-light":"#032F62","--shiki-dark":"#9ECBFF"}}," julia"),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," -s"),a("span",{style:{"--shiki-light":"#032F62","--shiki-dark":"#9ECBFF"}}," msstore")])])])],-1)])),_:1})]),_:1}),t[5]||(t[5]=a("h3",{id:"Step-2:-Installing-Sargassum.jl",tabindex:"-1"},[g("Step 2: Installing Sargassum.jl "),a("a",{class:"header-anchor",href:"#Step-2:-Installing-Sargassum.jl","aria-label":'Permalink to "Step 2: Installing Sargassum.jl {#Step-2:-Installing-Sargassum.jl}"'},"​")],-1)),t[6]||(t[6]=a("div",{class:"warning custom-block"},[a("p",{class:"custom-block-title"},"Warning"),a("p",null,"Sargassum.jl can be installed by running the following command in a terminal. Sargassum.jl is distributed without any raw data to keep the initial download size small. To run simulations, interpolants for ocean velocity, wind etc. are required. Default interpolants are provided for the year 2018 in the north Atlantic, but the raw data need to be downloaded (roughly 1.2 GB). The first command does this automatically and only needs to be run once. If you don't want to do this, e.g. because you have your own raw data or you don't need the simulation capabilities of the package, then run the second command.")],-1)),e(l,null,{default:s(()=>[e(i,{label:"Install with default interpolants (recommended)"},{default:s(()=>t[2]||(t[2]=[a("p",null,"Run in the terminal, not in Julia!",-1),a("div",{class:"language-sh vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"sh"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#6F42C1","--shiki-dark":"#B392F0"}},"julia"),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," -e"),a("span",{style:{"--shiki-light":"#032F62","--shiki-dark":"#9ECBFF"}},` 'import Pkg; Pkg.Registry.add(Pkg.RegistrySpec(url = "https://github.com/70Gage70/SargassumRegistry")); Pkg.add("Sargassum"); using Sargassum; itps_default_construct(download = true);'`)])])])],-1)])),_:1}),e(i,{label:"Install without default interpolants"},{default:s(()=>t[3]||(t[3]=[a("p",null,"Run in the terminal, not in Julia!",-1),a("div",{class:"language-sh vp-adaptive-theme"},[a("button",{title:"Copy Code",class:"copy"}),a("span",{class:"lang"},"sh"),a("pre",{class:"shiki shiki-themes github-light github-dark vp-code",tabindex:"0"},[a("code",null,[a("span",{class:"line"},[a("span",{style:{"--shiki-light":"#6F42C1","--shiki-dark":"#B392F0"}},"julia"),a("span",{style:{"--shiki-light":"#005CC5","--shiki-dark":"#79B8FF"}}," -e"),a("span",{style:{"--shiki-light":"#032F62","--shiki-dark":"#9ECBFF"}},` 'import Pkg; Pkg.Registry.add(Pkg.RegistrySpec(url = "https://github.com/70Gage70/SargassumRegistry")); Pkg.add("Sargassum"); using Sargassum; '`)])])])],-1)])),_:1})]),_:1}),t[7]||(t[7]=n('<p>Advanced Julia users can <a href="https://pkgdocs.julialang.org/v1/managing-packages/#Adding-unregistered-packages" target="_blank" rel="noreferrer">add the package</a> to their preferred environment.</p><h2 id="Next-Steps" tabindex="-1">Next Steps <a class="header-anchor" href="#Next-Steps" aria-label="Permalink to &quot;Next Steps {#Next-Steps}&quot;">​</a></h2><p>In general, this documentation can be read in order, but refer to the following for further direction.</p><div class="tip custom-block"><p class="custom-block-title">I want to get started as quickly as possible and/or do as little coding as possible.</p><p>See <a href="./s-interface">SargassumInterface</a>.</p></div><div class="tip custom-block"><p class="custom-block-title">I want to learn the core simulation tools of the package or create custom biology/physics functionality.</p><p>See <a href="./s-bomb">SargassumBOMB</a>.</p></div><div class="tip custom-block"><p class="custom-block-title">I want analyze satellite data or create Sargassum distribution maps.</p><p>See <a href="./s-afai">SargassumFromAFAI</a>.</p></div>',6))])}const F=o(h,[["render",p]]);export{y as __pageData,F as default};