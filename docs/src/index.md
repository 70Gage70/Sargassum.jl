```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "Sargassum.jl"
  text: "Seaweed in Julia."
  tagline: Simulate Sargassum models, analyze satellite data, plot the results.
  image:
    src: /logo.png
    alt: Sargassum
  actions:
    - theme: brand
      text: Getting Started
      link: /getting_started
    - theme: alt
      text: View on Github
      link: https://github.com/70Gage70/Sargassum.jl
    - theme: alt
      text: Cite
      link: /cite


features:
  - title: Interface
    details: Simulate full physics models with your own environment data in a zero-code interface.
    link: /s-interface.md
  - title: Customize
    details: Write your own biology models on top of state of the art physics simulations.
    link: /s-bomb.md
  - title: Observe
    details: Download raw satellite data and convert to Sargassum density maps.
    link: /s-afai.md
---
```

```@raw html
<p style="margin-bottom:2cm"></p>

<div class="vp-doc" style="width:80%; margin:auto">

<h1> What is DocumenterVitepress.jl? </h1>

DocumenterVitepress is a Markdown backend for Documenter.jl which is designed to work with the [`VitePress`](https://vitepress.dev/) site generator, which is built off `Vue.js`.

It is meant to be used in conjunction with the `vitepress` Node.js package, which is why so much customization is required!

<h2> Basic usage </h2>

If you copy the contents of the `template/` directory into your `docs/` and the `.github/Documenter.yml` file to your repo, you should be good to go and edit docs as usual!

Just remember to edit the navbar in `docs/src/.vitepress/config.mts`, if you want it to be different from the sidebar.

To install a logo or favicon, you can put `logo.png` and `favicon.ico` in `docs/src/assets`, and they will be automatically detected.

</div>
```
