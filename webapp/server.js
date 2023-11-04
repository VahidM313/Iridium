// Import the necessary modules
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors'); // Import the cors module

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/mydatabase');

// Define a schema for the server data
const IridiumSchema = new mongoose.Schema({
  'Server Name': String,
  'IP Address': String,
  'CPU Model': String,
  'Architecture': String,
  'Memory Size': String,
  'Hard Disk Space': String,
  'Date and Time': String,
  'Linux Distribution': String // Add Linux Distribution to the schema
});

// Create a model from the schema
const Iridium = mongoose.model('Iridium', IridiumSchema);

// Create an Express application
const app = express();
app.use(cors()); // Use cors middleware
app.use(bodyParser.json());

const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*", // Allow all origins
    methods: ["GET", "POST"]
  }
});

// A POST endpoint to receive the data from the servers
app.post('/data', async (req, res) => {
    // Create a new document from the received data
    const iridium = new Iridium(req.body);

    // Save the document to MongoDB
    try {
        await iridium.save();
        io.emit('new data', iridium); // Emit an event with the new data
        res.sendStatus(200);
    } catch (err) {
        console.error(err);
        res.sendStatus(500);
    }
});

// A GET endpoint to send the data to the frontend
app.get('/data', async (req, res) => {
    // Query MongoDB for all server data
    try {
        const iridium = await Iridium.find();
        res.json(iridium);
    } catch (err) {
        console.error(err);
        res.sendStatus(500);
    }
});

// Start the server
const port = process.env.PORT || 5000;
server.listen(port, () => console.log(`Server is running on port ${port}`)); // Use server.listen instead of app.listen