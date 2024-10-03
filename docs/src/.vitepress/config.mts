import { defineConfig } from 'vitepress'
import { tabsMarkdownPlugin } from 'vitepress-plugin-tabs'
import mathjax3 from "markdown-it-mathjax3";
import footnote from "markdown-it-footnote";
// import del from 'rollup-plugin-delete';
function getBaseRepository(base: string): string {
  if (!base) return '/';
  // I guess if deploy_url is available. From where do I check this ?
  const parts = base.split('/').filter(Boolean);
  return parts.length > 0 ? `/${parts[0]}/` : '/';
}

const baseTemp = {
  base: 'REPLACE_ME_DOCUMENTER_VITEPRESS',// TODO: replace this in makedocs!
}

const navTemp = {
  nav: [
    { text: 'Home', link: '/index' },
    { text: 'Getting Started', link: '/getting-started' },
    { text: 'Packages',
      items: [
        { text: 'SargassumInterface.jl', link: '/s-interface'},
        { text: 'SargassumBOMB.jl', link: '/s-bomb'},
        { text: 'SargassumFromAFAI.jl', link: '/s-afai'},
        { text: 'SargassumColors.jl', link: '/s-colors'},
      ],
    },
    { text: 'Cite', link: '/index'}
  ],
}

const nav = [
  ...navTemp.nav,
  // {
    // component: 'VersionPicker'
  // }
]

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
  title: 'Sargassum.jl',
  description: "Sargassum data analysis and modeling.",
  lastUpdated: true,
  cleanUrls: true,
  outDir: 'REPLACE_ME_DOCUMENTER_VITEPRESS', // This is required for MarkdownVitepress to work correctly...
  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    ['script', {src: `${getBaseRepository(baseTemp.base)}versions.js`}],
    ['script', {src: `${baseTemp.base}siteinfo.js`}]
  ],

  markdown: {
    math: true,
    config(md) {
      md.use(tabsMarkdownPlugin),
      md.use(mathjax3),
      md.use(footnote)
    },
    // https://shiki.style/themes
    theme: {
      light: "github-light",
      dark: "github-dark"}
  },
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    logo: { src: '/logo.png', width: 24, height: 24 },
    search: {
      provider: 'local',
      options: {
        detailedView: true
      }
    },
    nav,
    sidebar: [
      {
        text: 'Getting Started', link: '/getting-started',
      },
      { text: 'SargassumInterface', link: '/s-interface',
        items: [
          { text: 'Tutorial', link: '/s-interface' },
          { text: 'API', link: '/s-interface-api' },
        ],
      },
      { text: 'SargassumBOMB', link: '/s-bomb',
        items: [
          { text: 'Tutorial', link: '/s-bomb' },
          { text: 'API', link: '/s-bomb-api' },
        ],
      },
      { text: 'SargassumFromAFAI', link: '/s-afai',
        items: [
          { text: 'Tutorial', link: '/s-afai' },
          { text: 'API', link: '/s-afai-api' },
        ],
      },
      { text: 'SargassumColors', link: '/s-colors',
        items: [
          { text: 'Tutorial', link: '/s-colors' },
          { text: 'API', link: '/s-colors-api' },
        ],
      },
    ],
    editLink: {
      pattern: 'https://github.com/70Gage70/Sargassum.jl/edit/master/docs/src/:path'
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/70Gage70/Sargassum.jl'},
    ],
    footer: {
      message: 'Made with <a href="https://github.com/LuxDL/DocumenterVitepress.jl" target="_blank"><strong>DocumenterVitepress.jl</strong></a>',
      copyright: `© Copyright ${new Date().getUTCFullYear()}. Released under the MIT License.`
    }
  }
})
