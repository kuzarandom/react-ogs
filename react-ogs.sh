#!/usr/bin/env bash
# ชื่อไฟล์: react-ogs
# ใช้งาน: ./react-ogs <project-name>
echo "🚀 Creating project: $1"
APP_NAME=$1

if [ -z "$APP_NAME" ]; then
  echo "❌ Usage: ./react-ogs <project-name>"
  exit 1
fi

# Libraries
LIBS="react-redux @reduxjs/toolkit react-router-dom antd @ant-design/icons"
DEV_LIBS="tailwindcss @tailwindcss/postcss postcss autoprefixer eslint prettier eslint-config-prettier eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-react-refresh @eslint/js typescript-eslint globals lefthook commitlint"

echo "🚀 Creating React Vite project: $APP_NAME"

# 1. สร้างโปรเจกต์ Vite + React + TS
npm create vite@6.0.5 $APP_NAME -- --template react-ts
cd $APP_NAME

# 2. ติดตั้ง dependencies
npm install $LIBS
npm install -D $DEV_LIBS

# 3. Tailwind + PostCSS
npx tailwindcss init -p
cat > tailwind.config.ts <<'EOF'
// tailwind.config.ts
import { Config } from "tailwindcss";

const config: Config = {
    content: ["./src/**/*.{html,ts,tsx}"],
    theme: {
        extend: {},
    },
    plugins: [],
};

export default config;

EOF

cat > postcss.config.js <<'EOF'
export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
}

EOF

cat > src/index.css <<'EOF'
@import 'tailwindcss';
@config '../tailwind.config.ts';
EOF

# 4. main.tsx
cat > src/main.tsx <<'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# 5. Folder structure
mkdir -p src/{assets,components,constants,hooks,layouts,pages,routes,services,store,utils,types}
mkdir -p public

# 6. routes placeholder
cat > src/routes/index.tsx <<'EOF'
// Route configuration placeholder
import { createBrowserRouter } from 'react-router-dom';

const route = createBrowserRouter([]);

export default route;

EOF

# 7. store setup
cat > src/store/index.ts <<'EOF'
import { configureStore } from '@reduxjs/toolkit';

export const store = configureStore({
  reducer: {
    // Add reducers here
  },
});

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
EOF

# 8. App.tsx
cat > src/App.tsx <<'EOF'
import { Provider } from "react-redux";
import { store } from "@store";
import { RouterProvider } from "react-router-dom";
import AppRoutes from "@routes";

function App() {
  return (
    <Provider store={store}>
      <RouterProvider router={AppRoutes} />
    </Provider>
  );
}

export default App;

EOF

# 9. Vite config alias
cat > vite.config.ts <<'EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

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
EOF

# 10. TSConfig
cat > tsconfig.app.json <<'EOF'
{
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
EOF

cat > tsconfig.node.json <<'EOF'
{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.node.tsbuildinfo",
    "target": "ES2022",
    "lib": ["ES2023"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedSideEffectImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

cat > tsconfig.json <<'EOF'
{
  "files": [],
  "references": [
    { "path": "./tsconfig.app.json" },
    { "path": "./tsconfig.node.json" }
  ]
}
EOF

# 11. ESLint ESM config
cat > .eslintrc.js <<'EOF'
import globals from "globals";
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
        plugins: { "react-refresh": ReactRefreshEslint },
        settings: { react: { version: "detect" } },
        rules: {
            "react-refresh/only-export-components": ["warn", { allowConstantExport: true }],
            "react/jsx-first-prop-new-line": [2, "multiline"],
            "react/jsx-max-props-per-line": [2, { maximum:1, when:"multiline" }],
            "react/jsx-closing-bracket-location": [2, "tag-aligned"],
            "@typescript-eslint/no-empty-function": ["error", { allow:["arrowFunctions"] }],
            "no-extra-boolean-cast": 0,
            "object-curly-newline": ["error",{ObjectExpression:{consistent:true,multiline:true,minProperties:2},ObjectPattern:{consistent:true,multiline:true}}],
            "@typescript-eslint/no-explicit-any": "off",
            "react/react-in-jsx-scope": "off",
            "@typescript-eslint/no-unused-vars": "off",
            "no-unused-vars": "off"
        }
    }
];
EOF

# 12. Prettier
cat > .prettierrc <<'EOF'
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100
}
EOF

# 13. .env
touch .env

# 14. Lefthook + commitlint.sh
mkdir -p .lefthook/commit-msg

cat > .lefthook/lefthook.yml <<'EOF'
pre-commit:
    parallel: true
    commands:
        lint:
            files: git diff --name-only @{push}
            glob: "*.{js,ts,jsx,tsx}"
            run: npx eslint {files} --quiet
        tsc:
            files: { all_files }
            tags: typescript
            run: npx tsc --noEmit --skipLibCheck
commit-msg:
    scripts:
        "commitlint.sh":
            runner: bash
EOF

cat > .lefthook/commit-msg/commitlint.sh <<'EOF'
#!/bin/bash
echo $(head -n1 $1) | npx commitlint --color
EOF

chmod +x .lefthook/commit-msg/commitlint.sh

echo "✅ Project $APP_NAME created successfully!"
echo "All ready: Tailwind, Redux, Router, Ant Design + @ant-design/icons, ESLint/Prettier (ESM), Lefthook + commitlint, folder structure (types/), TS Project References + alias paths."
