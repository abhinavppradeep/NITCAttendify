const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
const port = process.env.PORT || 3000;

// Replace with your actual database credentials
const pool = mysql.createPool({
  host: 'add your host name',
  user: 'add your username',
  password: 'your password',
  database: 'defaultdb',
  port: 15035,
});

app.use(express.json()); // Parse incoming JSON data

app.post('/api/data', async (req, res) => {
  const { name } = req.body; // Removed id field

  if (!name) {
    return res.status(400).send({ message: 'Please provide a name' }); // Updated error message
  }

  const singaporeDate = new Date(); // Assuming Singapore server time

  // Convert to IST using getTimezoneOffset() and adjust accordingly (IST is +2:30 ahead of SGT)
  singaporeDate.setHours(singaporeDate.getHours() + 5 + 30); // Adjust for IST

  const formattedDate = singaporeDate.toISOString().slice(0, 19).replace('T', ' ');

  try {
    const [rows, fields] = await pool.query('INSERT INTO tab (name, date, time) VALUES (?, ?, ?)', [name, formattedDate.slice(0, 10), formattedDate.slice(11, 16)]); // Removed id field from query

    res.status(201).send({ message: 'Data inserted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).send({ message: 'Error inserting data' });
  }
});

app.post('/api/tag-events', async (req, res) => {
  try {
    const { tagId, eventType, timestamp } = req.body;

    // Insert the tag event into the database
    await pool.query('INSERT INTO tag_events (tag_id, event_type, timestamp) VALUES (?, ?, ?)', [tagId, eventType, timestamp]);

    res.status(201).json({ message: 'Tag event added successfully' });
  } catch (error) {
    console.error('Error adding tag event:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/tag-event', async (req, res) => {
  try {
    const [rows, fields] = await pool.query('SELECT * FROM tag_events');
    
    // Transforming the data to a custom JSON format
    const events = rows.map(row => ({
      id: row.id,
      tag_id: row.tag_id,
      event_type: row.event_type,
      timestamp: row.timestamp.toLocaleString(), // Convert timestamp to a readable format
    }));
    
    res.json({ events });
  } catch (error) {
    console.error('Error fetching tag events:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint to get the last 10 tag events based on ID
app.get('/api/last-10-tag-events', async (req, res) => {
  try {
    const [rows, fields] = await pool.query('SELECT * FROM tag_events ORDER BY id DESC LIMIT 10');
    res.json(rows);
  } catch (error) {
    console.error('Error fetching last 10 tag events:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});



// Change the server to listen on the specified IP address and port
app.listen(port, '192.168.1.37', () => {
  console.log(`Server listening on port ${port}`);
});
