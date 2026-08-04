const express = require('express');
const path    = require('path');
const cors    = require('cors');

const app  = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Login page
app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

// App principal
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', app: 'Cashly', version: '2.0.0' });
});

app.listen(PORT, () => {
  console.log(`✅ Cashly v2.0 corriendo en http://localhost:${PORT}`);
});
