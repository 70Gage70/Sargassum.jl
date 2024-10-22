import{_ as n,c as o,j as a,a as t,G as i,a4 as l,B as r,o as p}from"./chunks/framework.CsgBfYqC.js";const I=JSON.parse('{"title":"Interface API","description":"","frontmatter":{},"headers":[],"relativePath":"extra-api.md","filePath":"extra-api.md","lastUpdated":null}'),d={name:"extra-api.md"},u={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},S={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""};function y(v,s,A,E,T,_){const e=r("Badge");return p(),o("div",null,[s[33]||(s[33]=a("h1",{id:"Interface-API",tabindex:"-1"},[t("Interface API "),a("a",{class:"header-anchor",href:"#Interface-API","aria-label":'Permalink to "Interface API {#Interface-API}"'},"​")],-1)),s[34]||(s[34]=a("p",null,"These are the full docstrings for miscellaneous objects (generally not user-facing).",-1)),s[35]||(s[35]=a("h2",{id:"General-utilities",tabindex:"-1"},[t("General utilities "),a("a",{class:"header-anchor",href:"#General-utilities","aria-label":'Permalink to "General utilities {#General-utilities}"'},"​")],-1)),a("details",u,[a("summary",null,[s[0]||(s[0]=a("a",{id:"Sargassum.vec2range",href:"#Sargassum.vec2range"},[a("span",{class:"jlbinding"},"Sargassum.vec2range")],-1)),s[1]||(s[1]=t()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">vec2range</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(vector; force)</span></span></code></pre></div><p>Convert a <code>Vector</code> of linearly spaced values to a <code>StepRangeLen</code>.</p><p>If <code>force == true</code>, the range will be constructed even if the vector isn&#39;t linearly spaced by linear interpolation preserving the length. Default <code>false</code>.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Utilities/utils.jl#L112-L118" target="_blank" rel="noreferrer">source</a></p>',4))]),s[36]||(s[36]=a("h2",{id:"Clump-utilities",tabindex:"-1"},[t("Clump utilities "),a("a",{class:"header-anchor",href:"#Clump-utilities","aria-label":'Permalink to "Clump utilities {#Clump-utilities}"'},"​")],-1)),a("details",c,[a("summary",null,[s[3]||(s[3]=a("a",{id:"Sargassum.clump_i",href:"#Sargassum.clump_i"},[a("span",{class:"jlbinding"},"Sargassum.clump_i")],-1)),s[4]||(s[4]=t()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">clump_i</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(u, i)</span></span></code></pre></div><p>Return a view to the the <code>[x, y]</code> coordinates of the <code>i</code>th clump in the solution matrix <code>u</code>. This is <code>view(u :,i)</code>.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Utilities/utils.jl#L134-L138" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",g,[a("summary",null,[s[6]||(s[6]=a("a",{id:"Sargassum.com",href:"#Sargassum.com"},[a("span",{class:"jlbinding"},"Sargassum.com")],-1)),s[7]||(s[7]=t()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[8]||(s[8]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">com</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(u)</span></span></code></pre></div><p>Return the center of mass <code>[x, y]</code> coordinates of the solution matrix <code>u</code>.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Utilities/utils.jl#L143-L147" target="_blank" rel="noreferrer">source</a></p>',3))]),s[37]||(s[37]=a("h2",{id:"downloading",tabindex:"-1"},[t("Downloading "),a("a",{class:"header-anchor",href:"#downloading","aria-label":'Permalink to "Downloading"'},"​")],-1)),a("details",h,[a("summary",null,[s[9]||(s[9]=a("a",{id:"Sargassum._download_with_progress",href:"#Sargassum._download_with_progress"},[a("span",{class:"jlbinding"},"Sargassum._download_with_progress")],-1)),s[10]||(s[10]=t()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[11]||(s[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_download_with_progress</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(url, output_path)</span></span></code></pre></div><p>Download file from <code>url</code> to <code>output_path</code> with a progress bar.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Utilities/utils.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",b,[a("summary",null,[s[12]||(s[12]=a("a",{id:"Sargassum._download_with_progress_http",href:"#Sargassum._download_with_progress_http"},[a("span",{class:"jlbinding"},"Sargassum._download_with_progress_http")],-1)),s[13]||(s[13]=t()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[14]||(s[14]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_download_with_progress_http</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(url, [local_path], [headers]; update_period</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, kw</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Simular to <code>[_download_with_progress]</code>, but suitable for downloading <code>.nc</code> files from <code>https://cwcgom.aoml.noaa.gov/erddap/griddap</code>.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Utilities/utils.jl#L36-L40" target="_blank" rel="noreferrer">source</a></p>',3))]),s[38]||(s[38]=a("h2",{id:"Scratch-spaces",tabindex:"-1"},[t("Scratch spaces "),a("a",{class:"header-anchor",href:"#Scratch-spaces","aria-label":'Permalink to "Scratch spaces {#Scratch-spaces}"'},"​")],-1)),a("details",m,[a("summary",null,[s[15]||(s[15]=a("a",{id:"Sargassum._AFAI_RAW_SCRATCH",href:"#Sargassum._AFAI_RAW_SCRATCH"},[a("span",{class:"jlbinding"},"Sargassum._AFAI_RAW_SCRATCH")],-1)),s[16]||(s[16]=t()),i(e,{type:"info",class:"jlObjectType jlConstant",text:"Constant"})]),s[17]||(s[17]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _AFAI_RAW_SCRATCH</span></span></code></pre></div><p>A <code>Ref</code> whose field is the path to the location of the raw AFAI data.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Sargassum.jl#L5-L9" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",k,[a("summary",null,[s[18]||(s[18]=a("a",{id:"Sargassum._SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH",href:"#Sargassum._SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH"},[a("span",{class:"jlbinding"},"Sargassum._SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH")],-1)),s[19]||(s[19]=t()),i(e,{type:"info",class:"jlObjectType jlConstant",text:"Constant"})]),s[20]||(s[20]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH</span></span></code></pre></div><p>A <code>Ref</code> whose field is the path to the location of the precomputed [<code>SargassumDistribution</code>(@ref)s.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Sargassum.jl#L12-L16" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",C,[a("summary",null,[s[21]||(s[21]=a("a",{id:"Sargassum._ITPS_RAW_SCRATCH",href:"#Sargassum._ITPS_RAW_SCRATCH"},[a("span",{class:"jlbinding"},"Sargassum._ITPS_RAW_SCRATCH")],-1)),s[22]||(s[22]=t()),i(e,{type:"info",class:"jlObjectType jlConstant",text:"Constant"})]),s[23]||(s[23]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _ITPS_RAW_SCRATCH</span></span></code></pre></div><p>A <code>Ref</code> whose field is the path to the location of the raw data that generates default interpolants.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Sargassum.jl#L19-L23" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",f,[a("summary",null,[s[24]||(s[24]=a("a",{id:"Sargassum._ITPS_SCRATCH",href:"#Sargassum._ITPS_SCRATCH"},[a("span",{class:"jlbinding"},"Sargassum._ITPS_SCRATCH")],-1)),s[25]||(s[25]=t()),i(e,{type:"info",class:"jlObjectType jlConstant",text:"Constant"})]),s[26]||(s[26]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _ITPS_RAW_SCRATCH</span></span></code></pre></div><p>A <code>Ref</code> whose field is the path to the location of the raw data that generates default interpolants.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Sargassum.jl#L26-L30" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",S,[a("summary",null,[s[27]||(s[27]=a("a",{id:"Sargassum._INTERFACE_SCRATCH",href:"#Sargassum._INTERFACE_SCRATCH"},[a("span",{class:"jlbinding"},"Sargassum._INTERFACE_SCRATCH")],-1)),s[28]||(s[28]=t()),i(e,{type:"info",class:"jlObjectType jlConstant",text:"Constant"})]),s[29]||(s[29]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _INTERFACE_SCRATCH</span></span></code></pre></div><p>A <code>Ref</code> whose field is the path to the location of the editable interface notebook.</p><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/Sargassum.jl#L33-L37" target="_blank" rel="noreferrer">source</a></p>',3))]),s[39]||(s[39]=a("h2",{id:"geometry",tabindex:"-1"},[t("Geometry "),a("a",{class:"header-anchor",href:"#geometry","aria-label":'Permalink to "Geometry"'},"​")],-1)),a("details",j,[a("summary",null,[s[30]||(s[30]=a("a",{id:"Sargassum.geo2basic",href:"#Sargassum.geo2basic"},[a("span",{class:"jlbinding"},"Sargassum.geo2basic")],-1)),s[31]||(s[31]=t()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[32]||(s[32]=l(`<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">geo2basic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(input)</span></span></code></pre></div><p>Takes any GeoInterface-compatible structure, and returns its equivalent in the GeometryBasics.jl package, which Makie is built on.</p><p>Currently works for the following traits:</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>- PointTrait</span></span>
<span class="line"><span>- LineTrait</span></span>
<span class="line"><span>- LineStringTrait</span></span>
<span class="line"><span>- PolygonTrait</span></span>
<span class="line"><span>- MultiPolygonTrait</span></span></code></pre></div><p><a href="https://github.com/70Gage70/Sargassum.jl/blob/8a7b652a4b6d69be14824d31b34131c33a7d43c9/src/PlottingCore/geojson.jl#L13-L25" target="_blank" rel="noreferrer">source</a></p>`,5))])])}const F=n(d,[["render",y]]);export{I as __pageData,F as default};
