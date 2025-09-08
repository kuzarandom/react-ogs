#!/usr/bin/env node
// react-ogs.js - Node.js CLI for cross-platform project creation
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const APP_NAME = process.argv[2];
const viteArg = process.argv.find(arg => arg.startsWith('--vite='));
const VITE_VERSION = viteArg ? viteArg.split('=')[1] : 'latest';

console.log(`🚀 Creating React Vite project: ${APP_NAME}`);

if (!APP_NAME) {
    console.error('❌ Usage: react-ogs <project-name> [--vite=version]');
    process.exit(1);
}

const viteSpecifier = VITE_VERSION ? `@${VITE_VERSION}` : '@latest';
console.log(`🚀 Creating React Vite project: ${APP_NAME} (Vite ${VITE_VERSION})`);

// 1. Create Vite + React + TS project
execSync(`npm create vite${viteSpecifier} ${APP_NAME} -- --template react-ts`, { stdio: 'inherit' });
process.chdir(APP_NAME);

// 2. Install dependencies
const LIBS = [
    'react-redux', '@reduxjs/toolkit', 'react-router-dom', 'antd', '@ant-design/icons', "clsx"
].join(' ');
const DEV_LIBS = [
    'tailwindcss', '@tailwindcss/postcss', 'postcss', 'autoprefixer',
    'eslint', 'prettier', 'eslint-config-prettier', 'eslint-plugin-react',
    'eslint-plugin-react-hooks', 'eslint-plugin-react-refresh', '@eslint/js',
    'typescript-eslint', 'globals', 'lefthook', 'commitlint'
].join(' ');
execSync(`npm install ${LIBS}`, { stdio: 'inherit' });
execSync(`npm install -D ${DEV_LIBS}`, { stdio: 'inherit' });

// 3. Tailwind + PostCSS
// execSync('npx tailwindcss init -p', { stdio: 'inherit' });
fs.writeFileSync('tailwind.config.ts', 
`import { Config } from "tailwindcss";

const config: Config = {
    content: ["./src/**/*.{html,ts,tsx}"],
    theme: {
        extend: {},
    },
    plugins: [],
};

export default config;`);

// Remove tailwind.config.js if exists
if (fs.existsSync('tailwind.config.js')) {
  fs.unlinkSync('tailwind.config.js');
}

fs.writeFileSync('postcss.config.js',
`export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
}`);
fs.writeFileSync('src/index.css', `@import 'tailwindcss';\n@config '../tailwind.config.ts';\n`);
console.log("✅ Tailwind CSS configured.");
// 4. main.tsx
fs.writeFileSync('src/main.tsx', `import React from 'react'\nimport ReactDOM from 'react-dom/client'\nimport App from './App.tsx'\nimport './index.css'\n\nReactDOM.createRoot(document.getElementById('root')!).render(\n  <React.StrictMode>\n    <App />\n  </React.StrictMode>,\n)\n`);
console.log("✅ main.tsx created.");
// 5. Folder structure
['assets','components','constants','hooks','layouts','pages','routes','services','store','utils','types'].forEach(dir => {
    fs.mkdirSync(path.join('src', dir), { recursive: true });
});
fs.mkdirSync('public', { recursive: true });
console.log("✅ Folder structure created.");

// 6. routes placeholder
fs.writeFileSync('src/routes/route.tsx', `// Route configuration placeholder\nimport { createBrowserRouter } from 'react-router-dom';\n\nconst route = createBrowserRouter([]);\n\nexport default route;\n`);
console.log("✅ routes created.");

// 7. store setup
fs.writeFileSync('src/store/index.ts', `import { configureStore } from '@reduxjs/toolkit';\n\nexport const store = configureStore({\n  reducer: {\n    // Add reducers here\n  },\n});\n\nexport type RootState = ReturnType<typeof store.getState>\nexport type AppDispatch = typeof store.dispatch\n`);
console.log("✅ Redux store configured.");

// 8. App.tsx
fs.writeFileSync('src/App.tsx', `import { Provider } from "react-redux";
import { store } from "@store";
import { RouterProvider } from "react-router-dom";
import AppRoutes from "@routes/route";

function App() {
  return (
    <Provider store={store}>
      <RouterProvider router={AppRoutes} />
    </Provider>
  );
}

export default App;
`);
console.log("✅ App.tsx created.");

// 9. Vite config alias
fs.writeFileSync('vite.config.ts', `import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path, { dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@assets': path.resolve(__dirname, './src/assets'),
      '@components': path.resolve(__dirname, './src/components'),
      '@constants': path.resolve(__dirname, './src/constants'),
      '@hooks': path.resolve(__dirname, './src/hooks'),
      '@layouts': path.resolve(__dirname, './src/layouts'),
      '@pages': path.resolve(__dirname, './src/pages'),
      '@routes': path.resolve(__dirname, './src/routes'),
      '@services': path.resolve(__dirname, './src/services'),
      '@store': path.resolve(__dirname, './src/store'),
      '@utils': path.resolve(__dirname, './src/utils'),
      '@types': path.resolve(__dirname, './src/types'),
    },
  },
});
`);
console.log("✅ Vite config with path aliases created.");

// 10. TSConfig
fs.writeFileSync('tsconfig.app.json', `{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020","DOM","DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "baseUrl": "./src",
    "paths": {
      "@services/*": ["services/*"],
      "@components/*": ["components/*"],
      "@components": ["components"],
      "@store/*": ["store/*"],
      "@store": ["store"],
      "@layouts/*": ["layouts/*"],
      "@constants/*": ["constants/*"],
      "@assets/*": ["assets/*"],
      "@utils/*": ["utils/*"],
      "@routes/*": ["routes/*"],
      "@routes": ["routes"],
      "@pages/*": ["pages/*"],
      "@hooks/*": ["hooks/*"],
      "@type/*": ["types/*"]
    },
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedSideEffectImports": true
  },
  "include": ["src"]
}
`);
console.log("✅ tsconfig.app.json created.");

// 11. ESLint + Prettier config
fs.writeFileSync('eslint.config.js', `import globals from "globals";
import ReactRefreshEslint from "eslint-plugin-react-refresh";
import ReactEslint from "eslint-plugin-react";
import TsEslint from "typescript-eslint";
import Eslint from "@eslint/js";

export default [
    { languageOptions: { globals: globals.browser } },
    ReactEslint.configs.flat.recommended,
    ...TsEslint.configs.recommended,
    Eslint.configs.recommended,

    {
        files: ["**/*.{js,mjs,cjs,ts,jsx,tsx}"],
        plugins: {
            "react-refresh": ReactRefreshEslint,
        },
        settings: {
            react: {
                version: "detect",  //React version
            },
        },

        rules: {
            "react-refresh/only-export-components": ["warn", { allowConstantExport: true }],
            "react/jsx-first-prop-new-line": [2, "multiline"],
            "react/jsx-max-props-per-line": [
                2,
                {
                    maximum: 1,
                    when: "multiline",
                },
            ],
            "react/jsx-closing-bracket-location": [2, "tag-aligned"],
            "@typescript-eslint/no-empty-function": ["error", { allow: ["arrowFunctions"] }],
            "no-extra-boolean-cast": 0,
            "object-curly-newline": [
                "error",
                {
                    ObjectExpression: {
                        consistent: true,
                        multiline: true,
                        minProperties: 2,
                    },
                    ObjectPattern: {
                        consistent: true,
                        multiline: true,
                    },
                },
            ],
            "@typescript-eslint/no-explicit-any": "off",
            "react/react-in-jsx-scope": "off",
            "@typescript-eslint/no-unused-vars": "off",
            "no-unused-vars": "off",
        },
    },
];

`)
console.log("✅ ESLint config created.");

fs.writeFileSync('.prettierrc', `{
  "arrowParens": "always",
  "bracketSameLine": false,
  "bracketSpacing": true,
  "embeddedLanguageFormatting": "auto",
  "htmlWhitespaceSensitivity": "css",
  "insertPragma": false,
  "jsxSingleQuote": false,
  "printWidth": 130,
  "proseWrap": "preserve",
  "quoteProps": "as-needed",
  "requirePragma": false,
  "semi": true,
  "singleAttributePerLine": false,
  "singleQuote": false,
  "tabWidth": 4,
  "trailingComma": "es5",
  "useTabs": false,
  "vueIndentScriptAndStyle": false
};
`);
console.log("✅ Prettier config created.");

// 12. Lefthook + commitlint
fs.writeFileSync('lefthook.yml', `pre-commit:
    parallel: true
    commands:
        lint:
            files: git diff --name-only @{push} # กำหนดให้รัน lint เฉพาะไฟล์ที่มีการเปลี่ยนแปลงจากการ push ล่าสุด
            glob: "*.{js,ts,jsx,tsx}" # กำหนดประเภทไฟล์ที่ต้องการให้ lint
            run: npx eslint {files} --quiet # รัน eslint กับไฟล์ที่เปลี่ยนแปลง โดยไม่แสดง warning
        tsc:
            files: { all_files }
            tags: typescript # ตั้งค่า tag สำหรับแสดงว่าคำสั่งนี้เกี่ยวกับ TypeScript
            run: npx tsc --noEmit --skipLibCheck # รัน TypeScript compiler โดยไม่ต้องสร้าง output (เช็ค type เท่านั้น)

commit-msg:
    scripts:
        "commitlint.sh":
            runner: bash
`)

fs.mkdirSync('.lefthook/commit-msg', { recursive: true });
fs.writeFileSync('.lefthook/commit-msg/commitlint.sh', `echo $(head -n1 $1) | npx commitlint --color`)

console.log("✅ Lefthook and commitlint configured.");

console.log('✅ Project %s created successfully!', APP_NAME);
console.log('All ready: Tailwind, Redux, Router, Ant Design + @ant-design/icons, ESLint/Prettier (ESM), Lefthook + commitlint, folder structure (types/), TS Project References + alias paths.');
