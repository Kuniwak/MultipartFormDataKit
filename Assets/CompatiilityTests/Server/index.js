'use strict';

const Path = require('path');
const Http = require('http');
const express = require('express');
const multer = require('multer');
const upload = multer();

const PORT = process.env.PORT || 8080;
const HOSTNAME = 'localhost';

const app = express();


app.post('/echo', upload.single("example", 2), (req, res, next) => {
  console.log(req.body);
  console.log(req.file);
  res.sendStatus(200).end();
})


Http.createServer(app).listen(PORT, HOSTNAME, () => {
  console.log(`Listening on http://${HOSTNAME}:${PORT}`)
});
