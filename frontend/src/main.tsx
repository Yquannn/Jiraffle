import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';

import App from './app/App';

const rootElement = document.getElementById('root');

if (!rootElement) {
  throw new Error('Root element with id "root" was not found.');
}

document.body.style.margin = '0';
document.body.style.fontFamily =
  '"Space Grotesk", "Avenir Next", "Segoe UI", sans-serif';
document.body.style.backgroundColor = '#020617';

createRoot(rootElement).render(
  <StrictMode>
    <App />
  </StrictMode>
);
