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
    { text: 'Tools',
      items: [
        { text: 'Interface', link: '/interface'},
        { text: 'AFAI', link: '/afai'},
        { text: 'Simulation', link: '/simulation'},
        { text: 'Plotting', link: '/plotting'},
      ],
    },
    { text: 'Cite', link: '/cite'}
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
      { text: 'Interface', link: '/interface',
        items: [
          { text: 'Tutorial', link: '/interface' },
          { text: 'API', link: '/interface-api' },
        ],
      },
      { text: 'Units and Time', link: '/units',
        items: [
          { text: 'Tutorial', link: '/units' },
          { text: 'API', link: '/units-api' },
        ],
      },
      { text: 'AFAI', link: '/afai',
        items: [
          { text: 'Tutorial', link: '/afai' },
          { text: 'API', link: '/afai-api' },
        ],
      },
      { text: 'Simulation', link: '/simulation',
        items: [
          { text: 'Tutorial', link: '/simulation' },
          { text: 'Interpolants', link: '/simulation-interpolants' },
          { text: 'Custom Physics', link: '/simulation-adv-physics' },
          { text: 'Custom Biology', link: '/simulation-adv-biology' },
          { text: 'API', link: '/simulation-api' },
        ],
      },
      { text: 'Plotting', link: '/plotting',
        items: [
          { text: 'Tutorial', link: '/plotting' },
          { text: 'API', link: '/plotting-api' },
        ],
      },
      { text: 'Extra API', link: '/extra-api',
      },
      { text: 'Cite', link: '/cite',
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
