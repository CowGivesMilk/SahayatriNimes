const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const multer = require('multer');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Configure file upload with multer
const storage = multer.memoryStorage(); // Store file in memory
const upload = multer({ storage });

// MySQL Connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '1234',
  database: 'Sahayatri',
});

db.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL');
});

// Sign Up Endpoint
app.post('/signup', (req, res) => {
  const { name, email, password } = req.body;
  const query = 'INSERT INTO users (name, email, password) VALUES (?, ?, ?)';
  db.query(query, [name, email, password], (err) => {
    if (err) return res.status(500).json({ error: 'Sign Up Failed' });
    res.json({ message: 'Sign Up Successful' });
  });
});

// Login Endpoint
app.post('/login', (req, res) => {
  const { email, password } = req.body;
  const query =
    'SELECT id, name, email, profile_picture FROM users WHERE email = ? AND password = ?';
  db.query(query, [email, password], (err, results) => {
    if (err || results.length === 0) {
      return res.status(401).json({ error: 'Invalid Credentials' });
    }
    const user = results[0];
    res.json({
      id: user.id,
      name: user.name,
      email: user.email,
      picture: user.profile_picture
        ? `data:image/jpeg;base64,${user.profile_picture.toString('base64')}`
        : null,
    });
  });
});

// Update Profile Picture Endpoint
app.post('/updateProfilePicture', upload.single('picture'), (req, res) => {
  const { userId } = req.body;
  const pictureData = req.file.buffer; // File buffer (binary data)
  const query = 'UPDATE users SET profile_picture = ? WHERE id = ?';
  db.query(query, [pictureData, userId], (err) => {
    if (err) return res.status(500).json({ error: 'Failed to update picture' });
    res.json({ message: 'Picture updated successfully' });
  });
});

// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));
