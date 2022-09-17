const express = require('express')
const app = express()

app.use(express.json())

const usersRouter = require('./users.js')
app.use('/users', usersRouter)

const itemsRouter = require('./items.js')
app.use('/items', itemsRouter)

app.listen(3000, () => console.log('App listening on port 3000!'))

