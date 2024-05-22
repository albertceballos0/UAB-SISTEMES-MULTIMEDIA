const express = require('express');
const router = express.Router();

const upload = require('../hooks/multerConfig');

const { uploadImage } = require('../controllers/queryController');

router.post('/upload', upload.single('image'), uploadImage);

module.exports = router;
