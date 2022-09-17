require('dotenv').config()
const { MongoClient } = require('mongodb')
const express = require('express')
const itemsRouter = express.Router()

const uri = process.env.MONGODB_URI
const client = new MongoClient(uri)

async function openDatabase() {
    await client.connect()
    return client.db("running-total-db")
}

async function closeDatabase() {
    client.close()
}

// get all items
itemsRouter.get('/', async (req, res) => {
    try {
        const database = await openDatabase()
        const users = await database.collection("User").find({}).toArray()

        let items = []
        users.forEach(user => {
            user.shoppingLists.forEach(shoppingList => {
                shoppingList.items.forEach(item => {
                    items.push(item)
                })
            })
        });
        res.json(items) // automatically set status code to 200
    } catch (error) {
        res.status(500).json({ message: error.message })
    } finally {
        await closeDatabase()
    }
})

// get all items at a certain store by name (ex: searching Target will return items scanned at every Target)
itemsRouter.get('/:store', async (req, res) => {
    try {
        const database = await openDatabase()
        const users = await database.collection("User").find({}).toArray()

        let items = []
        users.forEach(user => {
            user.shoppingLists.forEach(shoppingList => {
                if (shoppingList.location.toLowerCase().includes(req.params.store.toLowerCase())) {
                    shoppingList.items.forEach(item => {
                        items.push(item)
                    })
                }
            })
        });
        res.json(items) // automatically set status code to 200
    } catch (error) {
        res.status(500).json({ message: error.message })
    } finally {
        await closeDatabase()
    }
})

// get all items at a particular store location (by address)
itemsRouter.get('/:address', async (req, res) => {
    try {
        const database = await openDatabase()
        const users = await database.collection("User").find({}).toArray()

        let items = []
        users.forEach(user => {
            user.shoppingLists.forEach(shoppingList => {
                if (shoppingList.address.toLowerCase().includes(req.params.address.toLowerCase())) {
                    shoppingList.items.forEach(item => {
                        items.push(item)
                    })
                }
            })
        });
        res.json(items) // automatically set status code to 200
    } catch (error) {
        res.status(500).json({ message: error.message })
    } finally {
        await closeDatabase()
    }
})

module.exports = itemsRouter