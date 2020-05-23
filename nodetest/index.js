const express = require('express')
const app = express()
const port = 4000

app.get('/', (req, res) => res.send('this is testing...!'))

app.listen(port, () => console.log(`running on port 4000`))