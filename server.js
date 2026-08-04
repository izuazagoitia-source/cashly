const express = require('express');
const path    = require('path');
const cors    = require('cors');

const app  = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Servir archivos estáticos (index.html, PDF, etc.)
app.use(express.static(path.join(__dirname, 'public')));

// Ruta raíz
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Health check para el host
app.get('/health', (req, res) => {
  res.json({ status: 'ok', app: 'Cashly', version: '1.0.0' });
});

app.listen(PORT, () => {
  console.log(`✅ Cashly corriendo en http://localhost:${PORT}`);
});
