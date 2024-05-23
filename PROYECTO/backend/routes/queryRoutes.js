const express = require('express');
const router = express.Router();

const upload = require('../hooks/multerConfig');

const { setQueryController, getQueriesController } = require('../controllers/queryController');

router.post('/set', upload.single('image'), setQueryController);
router.get('/get', getQueriesController);

module.exports = router;
