require('dotenv').config()
const { MongoClient } = require('mongodb')
const express = require('express')
const usersRouter = express.Router()
const { ObjectID } = require('bson')

const uri = process.env.MONGODB_URI
const client = new MongoClient(uri)

async function openDatabase() {
    await client.connect()
    return client.db("running-total-db")
}

async function closeDatabase() {
    client.close()
}

// get all users
usersRouter.get('/', async (req, res) => {
    try {
        const database = await openDatabase()
        const users = await database.collection("User").find({}).toArray()
        res.json(users) // automatically set status code to 200
    } catch (error) {
        res.status(500).json({ message: error.message })
    } finally {
        await closeDatabase()
    }
})

// get one user
usersRouter.get('/:id', async (req, res) => {
    try {
        const database = await openDatabase()
        const user = await database.collection("User").findOne({
            "_id": ObjectID(req.params.id)
        })
        res.json(user) // automatically set status code to 200
    } catch (error) {
        res.status(500).json({ message: error.message })
    } finally {
        await closeDatabase()
    }
})

module.exports = usersRouter