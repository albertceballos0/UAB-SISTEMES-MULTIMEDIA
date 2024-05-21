const functions = require('@google-cloud/functions-framework');
const express = require('express');
const fs = require('fs');
const path = require('path');
const admin = require("firebase-admin");
const jsonData = require("./sistemes-multimedia-d08f240b9131.json");


admin.initializeApp({
    credential: admin.credential.cert(jsonData),

});
const db = admin.firestore();

const app = express();

app.use(express.json());


app.post('/registro', async (req, res) => {
  try {
    const { userId, email, name } = req.body;
    await db.collection('users').doc(userId).set({ email, name });
    res.send('Usuario registrado exitosamente');
  } catch (error) {
    console.error('Error al registrar usuario:', error);
    res.status(500).send('Error interno del servidor');
  }
});

app.get('/querys', async (req, res) => {
  try {
    const snapshot = await db.collection('querys').get();
    const querys = snapshot.docs.map(doc => doc.data());
    res.json(querys);
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    res.status(500).send('Error interno del servidor');
  }
});


app.get('/users', async (req, res) => {
  try {
    const snapshot = await db.collection('users').get();
    const usuarios = snapshot.docs.map(doc => doc.data());
    res.json(usuarios);
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    res.status(500).send('Error interno del servidor');
  }
});

functions.http('myFunction', app);