@echo off
REM ชื่อไฟล์: react-ogs.bat
REM ใช้งาน: react-ogs <project-name>
set APP_NAME=%1

if "%APP_NAME%"=="" (
    echo Usage: react-ogs ^<project-name^>
    exit /b 1
)

REM Libraries
set LIBS=react-redux @reduxjs/toolkit react-router-dom antd @ant-design/icons
set DEV_LIBS=tailwindcss @tailwindcss/postcss postcss autoprefixer eslint prettier eslint-config-prettier eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-react-refresh @eslint/js typescript-eslint globals lefthook commitlint

echo Creating React Vite project: %APP_NAME%

REM 1. สร้างโปรเจกต์ Vite + React + TS
npm create vite@latest %APP_NAME% -- --template react-ts
cd %APP_NAME%

REM 2. ติดตั้ง dependencies
npm install %LIBS%
npm install -D %DEV_LIBS%

REM 3. Tailwind + PostCSS
npx tailwindcss init -p
REM สร้าง tailwind.config.ts
(echo // tailwind.config.ts>tailwind.config.ts & \
 echo import ^{ Config ^} from "tailwindcss";>>tailwind.config.ts & \
 echo.>>tailwind.config.ts & \
 echo const config: Config = ^{>>tailwind.config.ts & \
 echo     content: ["./src/**/*.{html,ts,tsx}"],>>tailwind.config.ts & \
 echo     theme: ^{ extend: ^{} ^},>>tailwind.config.ts & \
 echo     plugins: [],>>tailwind.config.ts & \
 echo ^};>>tailwind.config.ts & \
 echo.>>tailwind.config.ts & \
 echo export default config;>>tailwind.config.ts)

REM สร้าง postcss.config.js
(echo export default ^{>postcss.config.js & \
 echo   plugins: ^{>>postcss.config.js & \
 echo     '@tailwindcss/postcss': ^{},>>postcss.config.js & \
 echo   ^},>>postcss.config.js & \
 echo ^}>>postcss.config.js)

REM สร้าง src/index.css
(echo @import 'tailwindcss';>src/index.css & \
 echo @config '../tailwind.config.ts';>>src/index.css)

REM 4. main.tsx
(echo import React from 'react'>src/main.tsx & \
 echo import ReactDOM from 'react-dom/client'>>src/main.tsx & \
 echo import App from './App.tsx'>>src/main.tsx & \
 echo import './index.css'>>src/main.tsx & \
 echo.>>src/main.tsx & \
 echo ReactDOM.createRoot(document.getElementById('root')!).render(^>>src/main.tsx & \
 echo   <React.StrictMode>^>>src/main.tsx & \
 echo     <App />^>>src/main.tsx & \
 echo   </React.StrictMode>,^>>src/main.tsx & \
 echo )>>src/main.tsx)

REM 5. Folder structure
mkdir src\assets src\components src\constants src\hooks src\layouts src\pages src\routes src\services src\store src\utils src\types
mkdir public

REM 6. routes placeholder
(echo // Route configuration placeholder>src/routes/route.tsx & \
 echo import { createBrowserRouter } from 'react-router-dom';>>src/routes/route.tsx & \
 echo.>>src/routes/route.tsx & \
 echo const route = createBrowserRouter([]);>>src/routes/route.tsx & \
 echo.>>src/routes/route.tsx & \
 echo export default route;>>src/routes/route.tsx)

REM 7. store setup
(echo import { configureStore } from '@reduxjs/toolkit';>src/store/index.ts & \
 echo.>>src/store/index.ts & \
 echo export const store = configureStore(^>>src/store/index.ts & \
 echo   ^{>>src/store/index.ts & \
 echo     reducer: ^{>>src/store/index.ts & \
 echo       // Add reducers here>>src/store/index.ts & \
 echo     ^},>>src/store/index.ts & \
 echo   ^}>>src/store/index.ts & \
 echo );>>src/store/index.ts & \
 echo.>>src/store/index.ts & \
 echo export type RootState = ReturnType<typeof store.getState>>src/store/index.ts & \
 echo export type AppDispatch = typeof store.dispatch>>src/store/index.ts)

REM 8. App.tsx
(echo import { Provider } from "react-redux";>src/App.tsx & \
 echo import { store } from "@store";>>src/App.tsx & \
 echo import { RouterProvider } from "react-router-dom";>>src/App.tsx & \
 echo import AppRoutes from "@routes";>>src/App.tsx & \
 echo.>>src/App.tsx & \
 echo function App() ^{>>src/App.tsx & \
 echo   return (^>>src/App.tsx & \
 echo     <Provider store={store}>^>>src/App.tsx & \
 echo       <RouterProvider router={AppRoutes} />^>>src/App.tsx & \
 echo     </Provider>^>>src/App.tsx & \
 echo   );^>>src/App.tsx & \
 echo ^}>>src/App.tsx & \
 echo.>>src/App.tsx & \
 echo export default App;>>src/App.tsx)

REM 9. Vite config alias
(echo import { defineConfig } from 'vite';>vite.config.ts & \
 echo import react from '@vitejs/plugin-react';>>vite.config.ts & \
 echo import path from 'path';>>vite.config.ts & \
 echo.>>vite.config.ts & \
 echo export default defineConfig(^>>vite.config.ts & \
 echo   ^{>>vite.config.ts & \
 echo     plugins: [react()],>>vite.config.ts & \
 echo     resolve: ^{>>vite.config.ts & \
 echo       alias: ^{>>vite.config.ts & \
 echo         '@assets': path.resolve(__dirname, './src/assets'),>>vite.config.ts & \
 echo         '@components': path.resolve(__dirname, './src/components'),>>vite.config.ts & \
 echo         '@constants': path.resolve(__dirname, './src/constants'),>>vite.config.ts & \
 echo         '@hooks': path.resolve(__dirname, './src/hooks'),>>vite.config.ts & \
 echo         '@layouts': path.resolve(__dirname, './src/layouts'),>>vite.config.ts & \
 echo         '@pages': path.resolve(__dirname, './src/pages'),>>vite.config.ts & \
 echo         '@routes': path.resolve(__dirname, './src/routes'),>>vite.config.ts & \
 echo         '@services': path.resolve(__dirname, './src/services'),>>vite.config.ts & \
 echo         '@store': path.resolve(__dirname, './src/store'),>>vite.config.ts & \
 echo         '@utils': path.resolve(__dirname, './src/utils'),>>vite.config.ts & \
 echo         '@types': path.resolve(__dirname, './src/types'),>>vite.config.ts & \
 echo       ^},>>vite.config.ts & \
 echo     ^},>>vite.config.ts & \
 echo   ^}>>vite.config.ts & \
 echo );>>vite.config.ts)

REM 10. TSConfig
(echo {>tsconfig.app.json & \
 echo   "compilerOptions": {>>tsconfig.app.json & \
 echo     "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",>>tsconfig.app.json & \
 echo     "target": "ES2020",>>tsconfig.app.json & \
 echo     "useDefineForClassFields": true,>>tsconfig.app.json & \
 echo     "lib": ["ES2020","DOM","DOM.Iterable"],>>tsconfig.app.json & \
 echo     "module": "ESNext",>>tsconfig.app.json & \
 echo     "skipLibCheck": true,>>tsconfig.app.json & \
 echo     "moduleResolution": "bundler",>>tsconfig.app.json & \
 echo     "allowImportingTsExtensions": true,>>tsconfig.app.json & \
 echo     "isolatedModules": true,>>tsconfig.app.json & \
 echo     "moduleDetection": "force",>>tsconfig.app.json & \
 echo     "noEmit": true,>>tsconfig.app.json & \
 echo     "jsx": "react-jsx",>>tsconfig.app.json & \
 echo     "baseUrl": "./src",>>tsconfig.app.json & \
 echo     "paths": {>>tsconfig.app.json & \
 echo       "@services/*": ["services/*"],>>tsconfig.app.json & \
 echo       "@components/*": ["components/*"],>>tsconfig.app.json & \
 echo       "@components": ["components"],>>tsconfig.app.json & \
 echo       "@store/*": ["store/*"],>>tsconfig.app.json & \
 echo       "@store": ["store"],>>tsconfig.app.json & \
 echo       "@layouts/*": ["layouts/*"],>>tsconfig.app.json & \
 echo       "@constants/*": ["constants/*"],>>tsconfig.app.json & \
 echo       "@assets/*": ["assets/*"],>>tsconfig.app.json & \
 echo       "@utils/*": ["utils/*"],>>tsconfig.app.json & \
 echo       "@routes/*": ["routes/*"],>>tsconfig.app.json & \
 echo       "@routes": ["routes"],>>tsconfig.app.json & \
 echo       "@pages/*": ["pages/*"],>>tsconfig.app.json & \
 echo       "@hooks/*": ["hooks/*"],>>tsconfig.app.json & \
 echo       "@type/*": ["types/*"]>>tsconfig.app.json & \
 echo     },>>tsconfig.app.json & \
 echo     "strict": true,>>tsconfig.app.json & \
 echo     "noUnusedLocals": true,>>tsconfig.app.json & \
 echo     "noUnusedParameters": true,>>tsconfig.app.json & \
 echo     "noFallthroughCasesInSwitch": true,>>tsconfig.app.json & \
 echo     "noUncheckedSideEffectImports": true>>tsconfig.app.json & \
 echo   },>>tsconfig.app.json & \
 echo   "include": ["src"]>>tsconfig.app.json & \
 echo }>>tsconfig.app.json)

REM ... (สามารถเพิ่มส่วนอื่น ๆ ตาม bash script ได้)

echo Project %APP_NAME% created successfully!
echo All ready: Tailwind, Redux, Router, Ant Design + @ant-design/icons, ESLint/Prettier (ESM), Lefthook + commitlint, folder structure (types/), TS Project References + alias paths.
