const express = require('express');
const router = express.Router();

const upload = require('../hooks/multerConfig');

const { setQueryController, getQueriesController, getQueriesCount } = require('../controllers/queryController');

router.post('/set', setQueryController);
router.get('/get', getQueriesController);
router.get('/count', getQueriesCount);

module.exports = router;
