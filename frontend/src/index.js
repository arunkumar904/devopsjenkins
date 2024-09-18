// frontend/src/index.js
import './index.css';
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css'; // If you have any global styles

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
