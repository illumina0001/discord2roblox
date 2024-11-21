const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

let lastCommand = null;

app.post('/execute', (req, res) => {
    const { command } = req.body;
    if (command) {
        lastCommand = command;
        console.log(`Received command: ${command}`);
        res.json({ status: "success", message: "Command received." });
    } else {
        res.status(400).json({ status: "error", message: "No command received." });
    }
});

app.get('/execute', (req, res) => {
    if (lastCommand) {
        res.json({ command: lastCommand });
        lastCommand = null;
    } else {
        res.json({ command: null });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
