const functions = require('@google-cloud/functions-framework');
const express = require('express');
require('dotenv').config();
const userRoutes = require('./routes/userRoutes');
const queryRoutes = require('./routes/queryRoutes');

const app = express();

app.use(express.json());


app.use('/users', userRoutes);
app.use('/images', queryRoutes);




const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

