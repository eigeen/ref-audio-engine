import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "REF Audio Engine",
  description: "REFramework 音频引擎插件文档",
  
  // 多语言配置
  locales: {
    root: {
      label: '中文',
      lang: 'zh-CN',
      title: "REF Audio Engine",
      description: "REFramework 音频引擎插件文档",
      themeConfig: {
        nav: [
          { text: '首页', link: '/' },
          { text: '快速开始', link: '/guide/getting-started' },
          { text: '通用 API', link: '/api/core' },
          { text: 'MHWilds', link: '/games/mhwilds/' }
        ],
        sidebar: {
          '/guide/': [
            {
              text: '指南',
              items: [
                { text: '快速开始', link: '/guide/getting-started' },
                { text: '安装配置', link: '/guide/installation' },
                { text: '基本概念', link: '/guide/concepts' }
              ]
            }
          ],
          '/api/': [
            {
              text: '通用 API',
              items: [
                { text: '核心 API', link: '/api/core' },
                { text: '音频引擎', link: '/api/engine' },
                { text: '简单 API', link: '/api/simple' },
                { text: '事件系统', link: '/api/events' }
              ]
            }
          ],
          '/games/mhwilds/': [
            {
              text: 'Monster Hunter Wilds',
              items: [
                { text: '概述', link: '/games/mhwilds/' },
                { text: '快速开始', link: '/games/mhwilds/getting-started' },
                { text: 'API 参考', link: '/games/mhwilds/api' },
                { text: '事件系统', link: '/games/mhwilds/events' },
              ]
            }
          ]
        },
        editLink: {
          pattern: 'https://github.com/eigeen/ref-audio-engine/edit/main/docs/:path',
          text: '在 GitHub 上编辑此页'
        }
      }
    },
    en: {
      label: 'English',
      lang: 'en-US',
      title: "REF Audio Engine",
      description: "Documentation for REFramework Audio Engine Plugin",
      themeConfig: {
        nav: [
          { text: 'Home', link: '/en/' },
          { text: 'Getting Started', link: '/en/guide/getting-started' },
          { text: 'Core API', link: '/en/api/core' },
          { text: 'MHWilds', link: '/en/games/mhwilds/' }
        ],
        sidebar: {
          '/en/guide/': [
            {
              text: 'Guide',
              items: [
                { text: 'Getting Started', link: '/en/guide/getting-started' },
                { text: 'Installation', link: '/en/guide/installation' },
                { text: 'Core Concepts', link: '/en/guide/concepts' }
              ]
            }
          ],
          '/en/api/': [
            {
              text: 'Core API',
              items: [
                { text: 'Core API', link: '/en/api/core' },
                { text: 'Audio Engine', link: '/en/api/engine' },
                { text: 'Simple API', link: '/en/api/simple' },
                { text: 'Event System', link: '/en/api/events' }
              ]
            }
          ],
          '/en/games/mhwilds/': [
            {
              text: 'Monster Hunter Wilds',
              items: [
                { text: 'Overview', link: '/en/games/mhwilds/' },
                { text: 'Getting Started', link: '/en/games/mhwilds/getting-started' },
                { text: 'API Reference', link: '/en/games/mhwilds/api' },
                { text: 'Event System', link: '/en/games/mhwilds/events' },
              ]
            }
          ]
        },
        editLink: {
          pattern: 'https://github.com/eigeen/ref-audio-engine/edit/main/docs/:path',
          text: 'Edit this page on GitHub'
        }
      }
    }
  },



  themeConfig: {

    socialLinks: [
      { icon: 'github', link: 'https://github.com/eigeen/ref-audio-engine' }
    ],

    // 搜索配置
    search: {
      provider: 'local'
    },

    // 页脚
    footer: {
      message: 'MIT License',
      copyright: 'Copyright © 2025 Eigeen'
    }
  }
})
