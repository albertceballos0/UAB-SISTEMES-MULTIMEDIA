const functions = require('@google-cloud/functions-framework');
const express = require('express');
require('dotenv').config();
const userRoutes = require('./routes/userRoutes');
const queryRoutes = require('./routes/queryRoutes');

const app = express();

app.use(express.json());


app.use('/users', userRoutes);
app.use('/queries', queryRoutes);


app.listen(3000, () => {
  console.log('Server running on port 3000');
});


functions.http('myFunction', app);
