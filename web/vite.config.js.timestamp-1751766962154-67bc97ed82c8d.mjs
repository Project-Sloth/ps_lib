var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __commonJS = (cb, mod) => function __require() {
  return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));

// tailwind.config.cjs
var require_tailwind_config = __commonJS({
  "tailwind.config.cjs"(exports, module) {
    "use strict";
    module.exports = {
      darkmode: true,
      content: [
        "./index.html",
        "./src/**/*.{svelte,js,ts,jsx,tsx}"
      ],
      theme: {
        extend: {}
      },
      plugins: []
    };
  }
});

// vite.config.js
import { defineConfig } from "file:///C:/Users/Musta/OneDrive/Desktop/fresh%20test/qb%20apr%2029th/txData/QBCoreFramework_108357.base/resources/%5Bps%5D/ps-ui/web/node_modules/.pnpm/vite@5.0.11/node_modules/vite/dist/node/index.js";
import { svelte } from "file:///C:/Users/Musta/OneDrive/Desktop/fresh%20test/qb%20apr%2029th/txData/QBCoreFramework_108357.base/resources/%5Bps%5D/ps-ui/web/node_modules/.pnpm/@sveltejs+vite-plugin-svelte@3.0.1_svelte@4.2.8_vite@5.0.11/node_modules/@sveltejs/vite-plugin-svelte/src/index.js";

// postcss.config.js
var import_tailwind_config = __toESM(require_tailwind_config(), 1);
import tailwind from "file:///C:/Users/Musta/OneDrive/Desktop/fresh%20test/qb%20apr%2029th/txData/QBCoreFramework_108357.base/resources/%5Bps%5D/ps-ui/web/node_modules/.pnpm/tailwindcss@3.4.1/node_modules/tailwindcss/lib/index.js";
import autoprefixer from "file:///C:/Users/Musta/OneDrive/Desktop/fresh%20test/qb%20apr%2029th/txData/QBCoreFramework_108357.base/resources/%5Bps%5D/ps-ui/web/node_modules/.pnpm/autoprefixer@10.4.16_postcss@8.4.33/node_modules/autoprefixer/lib/autoprefixer.js";
var postcss_config_default = {
  plugins: [tailwind(import_tailwind_config.default), autoprefixer]
};

// vite.config.js
import { minify } from "file:///C:/Users/Musta/OneDrive/Desktop/fresh%20test/qb%20apr%2029th/txData/QBCoreFramework_108357.base/resources/%5Bps%5D/ps-ui/web/node_modules/.pnpm/html-minifier@4.0.0/node_modules/html-minifier/src/htmlminifier.js";
var minifyHtml = () => {
  return {
    name: "html-transform",
    transformIndexHtml(html) {
      return minify(html, {
        collapseWhitespace: true
      });
    }
  };
};
var vite_config_default = defineConfig({
  css: {
    postcss: postcss_config_default
  },
  plugins: [svelte(), minifyHtml()],
  test: {
    globals: true,
    environment: "jsdom"
  },
  base: "./",
  // fivem nui needs to have local dir reference
  build: {
    minify: true,
    emptyOutDir: true,
    outDir: "../web/build",
    assetsDir: "./",
    rollupOptions: {
      output: {
        // By not having hashes in the name, you don't have to update the manifest, yay!
        entryFileNames: `[name].js`,
        chunkFileNames: `[name].js`,
        assetFileNames: `[name].[ext]`
      }
    }
  }
});
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidGFpbHdpbmQuY29uZmlnLmNqcyIsICJ2aXRlLmNvbmZpZy5qcyIsICJwb3N0Y3NzLmNvbmZpZy5qcyJdLAogICJzb3VyY2VzQ29udGVudCI6IFsiY29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2Rpcm5hbWUgPSBcIkM6XFxcXFVzZXJzXFxcXE11c3RhXFxcXE9uZURyaXZlXFxcXERlc2t0b3BcXFxcZnJlc2ggdGVzdFxcXFxxYiBhcHIgMjl0aFxcXFx0eERhdGFcXFxcUUJDb3JlRnJhbWV3b3JrXzEwODM1Ny5iYXNlXFxcXHJlc291cmNlc1xcXFxbcHNdXFxcXHBzLXVpXFxcXHdlYlwiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9maWxlbmFtZSA9IFwiQzpcXFxcVXNlcnNcXFxcTXVzdGFcXFxcT25lRHJpdmVcXFxcRGVza3RvcFxcXFxmcmVzaCB0ZXN0XFxcXHFiIGFwciAyOXRoXFxcXHR4RGF0YVxcXFxRQkNvcmVGcmFtZXdvcmtfMTA4MzU3LmJhc2VcXFxccmVzb3VyY2VzXFxcXFtwc11cXFxccHMtdWlcXFxcd2ViXFxcXHRhaWx3aW5kLmNvbmZpZy5janNcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfaW1wb3J0X21ldGFfdXJsID0gXCJmaWxlOi8vL0M6L1VzZXJzL011c3RhL09uZURyaXZlL0Rlc2t0b3AvZnJlc2glMjB0ZXN0L3FiJTIwYXByJTIwMjl0aC90eERhdGEvUUJDb3JlRnJhbWV3b3JrXzEwODM1Ny5iYXNlL3Jlc291cmNlcy8lNUJwcyU1RC9wcy11aS93ZWIvdGFpbHdpbmQuY29uZmlnLmNqc1wiO21vZHVsZS5leHBvcnRzID0ge1xyXG4gIGRhcmttb2RlOiB0cnVlLFxyXG4gIGNvbnRlbnQ6IFtcclxuICAgIFwiLi9pbmRleC5odG1sXCIsXHJcbiAgICBcIi4vc3JjLyoqLyoue3N2ZWx0ZSxqcyx0cyxqc3gsdHN4fVwiLFxyXG4gIF0sXHJcbiAgdGhlbWU6IHtcclxuICAgIGV4dGVuZDoge30sXHJcbiAgfSxcclxuICBwbHVnaW5zOiBbXSxcclxufVxyXG4iLCAiY29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2Rpcm5hbWUgPSBcIkM6XFxcXFVzZXJzXFxcXE11c3RhXFxcXE9uZURyaXZlXFxcXERlc2t0b3BcXFxcZnJlc2ggdGVzdFxcXFxxYiBhcHIgMjl0aFxcXFx0eERhdGFcXFxcUUJDb3JlRnJhbWV3b3JrXzEwODM1Ny5iYXNlXFxcXHJlc291cmNlc1xcXFxbcHNdXFxcXHBzLXVpXFxcXHdlYlwiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9maWxlbmFtZSA9IFwiQzpcXFxcVXNlcnNcXFxcTXVzdGFcXFxcT25lRHJpdmVcXFxcRGVza3RvcFxcXFxmcmVzaCB0ZXN0XFxcXHFiIGFwciAyOXRoXFxcXHR4RGF0YVxcXFxRQkNvcmVGcmFtZXdvcmtfMTA4MzU3LmJhc2VcXFxccmVzb3VyY2VzXFxcXFtwc11cXFxccHMtdWlcXFxcd2ViXFxcXHZpdGUuY29uZmlnLmpzXCI7Y29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2ltcG9ydF9tZXRhX3VybCA9IFwiZmlsZTovLy9DOi9Vc2Vycy9NdXN0YS9PbmVEcml2ZS9EZXNrdG9wL2ZyZXNoJTIwdGVzdC9xYiUyMGFwciUyMDI5dGgvdHhEYXRhL1FCQ29yZUZyYW1ld29ya18xMDgzNTcuYmFzZS9yZXNvdXJjZXMvJTVCcHMlNUQvcHMtdWkvd2ViL3ZpdGUuY29uZmlnLmpzXCI7aW1wb3J0IHsgZGVmaW5lQ29uZmlnIH0gZnJvbSAndml0ZSc7XHJcbmltcG9ydCB7IHN2ZWx0ZSB9IGZyb20gJ0BzdmVsdGVqcy92aXRlLXBsdWdpbi1zdmVsdGUnO1xyXG5pbXBvcnQgcG9zdGNzcyBmcm9tICcuL3Bvc3Rjc3MuY29uZmlnLmpzJztcclxuaW1wb3J0IHsgbWluaWZ5IH0gZnJvbSAnaHRtbC1taW5pZmllcic7XHJcblxyXG5jb25zdCBtaW5pZnlIdG1sID0gKCkgPT4ge1xyXG5cdHJldHVybiB7XHJcblx0XHRuYW1lOiAnaHRtbC10cmFuc2Zvcm0nLFxyXG5cdFx0dHJhbnNmb3JtSW5kZXhIdG1sKGh0bWwpIHtcclxuXHRcdFx0cmV0dXJuIG1pbmlmeShodG1sLCB7XHJcblx0XHRcdFx0Y29sbGFwc2VXaGl0ZXNwYWNlOiB0cnVlLFxyXG5cdFx0XHR9KTtcclxuXHRcdH0sXHJcblx0fTtcclxufTtcclxuXHJcbi8vIGh0dHBzOi8vdml0ZWpzLmRldi9jb25maWcvXHJcbmV4cG9ydCBkZWZhdWx0IGRlZmluZUNvbmZpZyh7XHJcblx0Y3NzOiB7XHJcblx0XHRwb3N0Y3NzLFxyXG5cdH0sXHJcblx0cGx1Z2luczogW3N2ZWx0ZSgpLCBtaW5pZnlIdG1sKCldLFxyXG5cdHRlc3Q6IHtcclxuXHRcdGdsb2JhbHM6IHRydWUsXHJcblx0XHRlbnZpcm9ubWVudDogJ2pzZG9tJyxcclxuXHR9LFxyXG5cdGJhc2U6ICcuLycsIC8vIGZpdmVtIG51aSBuZWVkcyB0byBoYXZlIGxvY2FsIGRpciByZWZlcmVuY2VcclxuXHRidWlsZDoge1xyXG5cdFx0bWluaWZ5OiB0cnVlLFxyXG5cdFx0ZW1wdHlPdXREaXI6IHRydWUsXHJcblx0XHRvdXREaXI6ICcuLi93ZWIvYnVpbGQnLFxyXG5cdFx0YXNzZXRzRGlyOiAnLi8nLFxyXG5cdFx0cm9sbHVwT3B0aW9uczoge1xyXG5cdFx0XHRvdXRwdXQ6IHtcclxuXHRcdFx0XHQvLyBCeSBub3QgaGF2aW5nIGhhc2hlcyBpbiB0aGUgbmFtZSwgeW91IGRvbid0IGhhdmUgdG8gdXBkYXRlIHRoZSBtYW5pZmVzdCwgeWF5IVxyXG5cdFx0XHRcdGVudHJ5RmlsZU5hbWVzOiBgW25hbWVdLmpzYCxcclxuXHRcdFx0XHRjaHVua0ZpbGVOYW1lczogYFtuYW1lXS5qc2AsXHJcblx0XHRcdFx0YXNzZXRGaWxlTmFtZXM6IGBbbmFtZV0uW2V4dF1gLFxyXG5cdFx0XHR9LFxyXG5cdFx0fSxcclxuXHR9LFxyXG59KTtcclxuIiwgImNvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9kaXJuYW1lID0gXCJDOlxcXFxVc2Vyc1xcXFxNdXN0YVxcXFxPbmVEcml2ZVxcXFxEZXNrdG9wXFxcXGZyZXNoIHRlc3RcXFxccWIgYXByIDI5dGhcXFxcdHhEYXRhXFxcXFFCQ29yZUZyYW1ld29ya18xMDgzNTcuYmFzZVxcXFxyZXNvdXJjZXNcXFxcW3BzXVxcXFxwcy11aVxcXFx3ZWJcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZmlsZW5hbWUgPSBcIkM6XFxcXFVzZXJzXFxcXE11c3RhXFxcXE9uZURyaXZlXFxcXERlc2t0b3BcXFxcZnJlc2ggdGVzdFxcXFxxYiBhcHIgMjl0aFxcXFx0eERhdGFcXFxcUUJDb3JlRnJhbWV3b3JrXzEwODM1Ny5iYXNlXFxcXHJlc291cmNlc1xcXFxbcHNdXFxcXHBzLXVpXFxcXHdlYlxcXFxwb3N0Y3NzLmNvbmZpZy5qc1wiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9pbXBvcnRfbWV0YV91cmwgPSBcImZpbGU6Ly8vQzovVXNlcnMvTXVzdGEvT25lRHJpdmUvRGVza3RvcC9mcmVzaCUyMHRlc3QvcWIlMjBhcHIlMjAyOXRoL3R4RGF0YS9RQkNvcmVGcmFtZXdvcmtfMTA4MzU3LmJhc2UvcmVzb3VyY2VzLyU1QnBzJTVEL3BzLXVpL3dlYi9wb3N0Y3NzLmNvbmZpZy5qc1wiO2ltcG9ydCB0YWlsd2luZCBmcm9tICd0YWlsd2luZGNzcyc7XHJcbmltcG9ydCBhdXRvcHJlZml4ZXIgZnJvbSAnYXV0b3ByZWZpeGVyJztcclxuaW1wb3J0IHRhaWx3aW5kQ29uZmlnIGZyb20gJy4vdGFpbHdpbmQuY29uZmlnLmNqcyc7XHJcblxyXG5leHBvcnQgZGVmYXVsdCB7XHJcbiAgcGx1Z2luczogW3RhaWx3aW5kKHRhaWx3aW5kQ29uZmlnKSwgYXV0b3ByZWZpeGVyXSxcclxufVxyXG4iXSwKICAibWFwcGluZ3MiOiAiOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQTtBQUFBO0FBQUE7QUFBc2pCLFdBQU8sVUFBVTtBQUFBLE1BQ3JrQixVQUFVO0FBQUEsTUFDVixTQUFTO0FBQUEsUUFDUDtBQUFBLFFBQ0E7QUFBQSxNQUNGO0FBQUEsTUFDQSxPQUFPO0FBQUEsUUFDTCxRQUFRLENBQUM7QUFBQSxNQUNYO0FBQUEsTUFDQSxTQUFTLENBQUM7QUFBQSxJQUNaO0FBQUE7QUFBQTs7O0FDVjRpQixTQUFTLG9CQUFvQjtBQUN6a0IsU0FBUyxjQUFjOzs7QUNDdkIsNkJBQTJCO0FBRnVoQixPQUFPLGNBQWM7QUFDdmtCLE9BQU8sa0JBQWtCO0FBR3pCLElBQU8seUJBQVE7QUFBQSxFQUNiLFNBQVMsQ0FBQyxTQUFTLHVCQUFBQSxPQUFjLEdBQUcsWUFBWTtBQUNsRDs7O0FESEEsU0FBUyxjQUFjO0FBRXZCLElBQU0sYUFBYSxNQUFNO0FBQ3hCLFNBQU87QUFBQSxJQUNOLE1BQU07QUFBQSxJQUNOLG1CQUFtQixNQUFNO0FBQ3hCLGFBQU8sT0FBTyxNQUFNO0FBQUEsUUFDbkIsb0JBQW9CO0FBQUEsTUFDckIsQ0FBQztBQUFBLElBQ0Y7QUFBQSxFQUNEO0FBQ0Q7QUFHQSxJQUFPLHNCQUFRLGFBQWE7QUFBQSxFQUMzQixLQUFLO0FBQUEsSUFDSjtBQUFBLEVBQ0Q7QUFBQSxFQUNBLFNBQVMsQ0FBQyxPQUFPLEdBQUcsV0FBVyxDQUFDO0FBQUEsRUFDaEMsTUFBTTtBQUFBLElBQ0wsU0FBUztBQUFBLElBQ1QsYUFBYTtBQUFBLEVBQ2Q7QUFBQSxFQUNBLE1BQU07QUFBQTtBQUFBLEVBQ04sT0FBTztBQUFBLElBQ04sUUFBUTtBQUFBLElBQ1IsYUFBYTtBQUFBLElBQ2IsUUFBUTtBQUFBLElBQ1IsV0FBVztBQUFBLElBQ1gsZUFBZTtBQUFBLE1BQ2QsUUFBUTtBQUFBO0FBQUEsUUFFUCxnQkFBZ0I7QUFBQSxRQUNoQixnQkFBZ0I7QUFBQSxRQUNoQixnQkFBZ0I7QUFBQSxNQUNqQjtBQUFBLElBQ0Q7QUFBQSxFQUNEO0FBQ0QsQ0FBQzsiLAogICJuYW1lcyI6IFsidGFpbHdpbmRDb25maWciXQp9Cg==
