import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  plugins: [react(), tsconfigPaths()],
  server: {
    host: process.env.VITE_HOST ?? '0.0.0.0',
    port: Number(process.env.VITE_PORT ?? 5173),
    strictPort: true,
    hmr: {
      host: process.env.VITE_HMR_HOST ?? 'localhost',
      port: Number(process.env.VITE_HMR_PORT ?? 5173),
      clientPort: Number(process.env.VITE_HMR_CLIENT_PORT ?? process.env.VITE_HMR_PORT ?? 5173),
    },
    watch: {
      usePolling: process.env.CHOKIDAR_USEPOLLING === 'true',
      interval: Number(process.env.CHOKIDAR_INTERVAL ?? 500),
    },
  },
})
