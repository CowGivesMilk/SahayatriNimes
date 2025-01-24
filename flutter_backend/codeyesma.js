const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const multer = require('multer');

const app = express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true })); // For form data



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

// Sign Up Endpoint
app.post('/signup', (req, res) => {
  const { name, email, password } = req.body;
  const query = 'INSERT INTO users (name, email, password) VALUES (?, ?, ?)';
  db.query(query, [name, email, password], (err) => {
    if (err) return res.status(500).json({ error: 'Sign Up Failed' });
    res.json({ message: 'Sign Up Successful' });
  });
});

//Admin panel for Parking Space
app.post('/add-parking', (req, res) => {
  console.log(req.body);  // Log the received data
  const { parking_name, parking_space, used_parking_space, latitude, longitude, location } = req.body;

  // Validate data before inserting into the database
  if (!parking_name || !parking_space || !used_parking_space || !latitude || !longitude || !location) {
    return res.status(400).send('All fields are required');
  }

  // Insert data into the database
  const query = 'INSERT INTO vehicle_parking (parking_name, parking_space, used_parking_space, latitude, longitude, location) VALUES (?, ?, ?, ?, ?, ?)';

  db.query(query, [parking_name, parking_space, used_parking_space, latitude, longitude, location], (err, results) => {
    if (err) {
      console.error('Error inserting data:', err);
      return res.status(500).send('Failed to add parking data');
    }
    res.send('Parking data added successfully');
  });
});

app.get('/get-parking-data', (req, res) => {
  const query = 'SELECT * FROM vehicle_parking'; // Adjust query if needed
  db.query(query, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).json({ message: 'Error fetching data' });
      return;
    }
    res.json(results); // Send the data as JSON
  });
});



// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));
