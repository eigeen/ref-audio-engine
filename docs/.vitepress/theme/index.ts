import type { Theme } from "vitepress";
import DefaultTheme from "vitepress/theme";
import TranslationWarning from "../components/TranslationWarning.vue";

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    // 注册全局组件
    app.component("TranslationWarning", TranslationWarning);
  },
} satisfies Theme;
