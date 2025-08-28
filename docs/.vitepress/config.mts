import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "REF Audio Engine",
  description: "REFramework 音频引擎插件文档",

  // 多语言配置
  locales: {
    root: {
      label: "中文",
      lang: "zh-CN",
      title: "REF Audio Engine",
      description: "REFramework 音频引擎插件文档",
      themeConfig: {
        nav: [
          { text: "首页", link: "/" },
          { text: "快速开始", link: "/guide/getting-started" },
          { text: "核心功能", link: "/api/core" },
          { text: "游戏适配", link: "/games/" },
        ],
        sidebar: {
          "/guide/": [
            {
              text: "快速开始",
              items: [
                { text: "快速开始", link: "/guide/getting-started" },
                { text: "安装配置", link: "/guide/installation" },
              ],
            },
          ],
          "/api/": [
            {
              text: "Core 核心",
              items: [
                { text: "核心 API", link: "/api/core" },
                { text: "音频引擎", link: "/api/engine" },
                { text: "简单 API", link: "/api/simple" },
                { text: "事件系统", link: "/api/events" },
              ],
            },
          ],
          "/games/": [
            {
              text: "Adapter 游戏适配",
              items: [{ text: "Monster Hunter Wilds", link: "/games/mhwilds/" }],
            },
          ],
          "/games/mhwilds/": [
            {
              text: "Monster Hunter Wilds",
              items: [
                { text: "概述", link: "/games/mhwilds/" },
                { text: "API 参考", link: "/games/mhwilds/api" },
                { text: "事件列表", link: "/games/mhwilds/events" },
              ],
            },
          ],
        },
        editLink: {
          pattern: "https://github.com/eigeen/ref-audio-engine/edit/main/docs/:path",
          text: "在 GitHub 上编辑此页",
        },
      },
    },
  },

  themeConfig: {
    socialLinks: [{ icon: "github", link: "https://github.com/eigeen/ref-audio-engine" }],

    // 搜索配置
    search: {
      provider: "local",
    },

    // 页脚
    footer: {
      message: "MIT License",
      copyright: "Copyright © 2025 Eigeen",
    },
  },
});
