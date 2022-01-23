echo ""
Write-Host "Making Root directories (client and server)..." -ForegroundColor blue
echo ""
mkdir client
mkdir server
cd client

echo ""
Write-Host "Installing latest version of React..." -ForegroundColor blue
echo ""

npx create-react-app .

echo ""
Write-Host "Making API..." -ForegroundColor blue
echo ""
yarn add axios
cd src 
mkdir api



# ------------------------------------------------------------------------------------------------->
New-Item api/index.js
Set-Content api/index.js "import axios from 'axios'

const usersURL = 'http://localhost:5000/users'

export const fetchUsers = () => axios.get(usersURL)
export const fetchUser = (userName) => axios.get(usersURL + '/' + userName)
"
# ----------------------------------------------------------------------------------------------------->



cd ..
cd ..
cd server
echo ""
Write-Host "Creating Node server..." -ForegroundColor blue
echo ""
yarn init -y
yarn add express dotenv mongoose cors express-async-handler esm




# ----------------------------------------------------------------------------------------------------->
New-Item index.js
Set-Content index.js "require = require('esm')(module)
module.exports = require('./server.js')"
# -------------------------------------------------------------------------------------------------------->




# ----------------------------------------------------------------------------------------------------->
New-Item server.js
Set-Content server.js "import connectDB from './config/db.js'
import userRoutes from './routes/userRoute.js'
import express from 'express'
import dotenv  from 'dotenv'

//dotenv config
dotenv.config()

//connect database
const DB_URI = process.env.MONGO_URI
connectDB(DB_URI)

const app = express()

//Creating API for user
app.use('/users', userRoutes)

const PORT = process.env.PORT || 5000

//Express js listen method to run project on http://localhost:5000
app.listen(PORT, console.log('App is running in ' + process.env.NODE_ENV + ' mode on port ' + PORT))"
# -------------------------------------------------------------------------------------------------------->




echo ""
Write-Host "Creating basic backend..." -ForegroundColor blue
echo ""
mkdir controllers, models, routes, config




# --------------------------------------------------------------------------------------------------------->
New-Item config/db.js
Set-Content config/db.js "const mongoose = require('mongoose')

const connectDB = async (DB_URI) => {
   mongoose.connect(DB_URI, {
  useNewUrlParser: true,
  // useCreateIndex: true,
  useUnifiedTopology: true
})
.then(res => console.log('mongoDB connected...'))
.catch(err => console.log(err))
}

export default connectDB"
# -------------------------------------------------------------------------------------------------------->




# -------------------------------------------------------------------------------------------------------->
New-Item controllers/userController.js
Set-Content controllers/userController.js "import User from '../models/userModel.js'
import asyncHandler from 'express-async-handler'

//getUsers function to get all users
export const getUsers = asyncHandler(async(req, res) => {
    const users = await User.find({})
    res.json(users)
})

//getUserById function to retrieve user by id
export const getUserById  = asyncHandler(async(req, res) => {
    const user = await User.findById(req.params.id)

    //if user id match param id send user else throw error
    if(user){
        res.json(user)
    }else{
        res.status(404).json({message: 'User not found'})
        res.status(404)
        throw new Error('User not found')
    }
})"
# -------------------------------------------------------------------------------------------------------->




# -------------------------------------------------------------------------------------------------------->
New-Item models/userModel.js
Set-Content models/userModel.js "import mongoose from 'mongoose'

const userSchema = mongoose.Schema({
    firstName: {
        type: String,
    },
    secondName:{
        type: String,
    },
    userName: {
        type: String,
        required: true,
        unique:true
    },
    email: {
        type: String,
        required: true,
        unique:true
    },
    password: {
        type: String,
        required: true
    },
    isAdmin: {
        type: Boolean,
        required: true,
        defualt: false
    },
}, {
    timestamps: true
})

const User = mongoose.model('User', userSchema)

export default User"
# -------------------------------------------------------------------------------------------------------->




# -------------------------------------------------------------------------------------------------------->
New-Item routes/userRoute.js
Set-Content routes/userRoute.js "import { getUsers, getUserById } from '../controllers/userController.js';
import express from 'express'
const router = express.Router()

// express router method to create route for getting all users
router.route('/').get(getUsers)

// express router method to create route for getting users by id
router.route('/:id').get(getUserById)

export default router"
# -------------------------------------------------------------------------------------------------------->




# -------------------------------------------------------------------------------------------------------->
echo ""
Write-Host "Adding environment..." -ForegroundColor blue
echo ""

New-Item .env
Set-Content .env "NODE_ENV = development
PORT = 5000"

cd ..
echo ""
Write-Host "Basic MERN template generated successfully!"  -ForegroundColor green
echo ""
Write-Host "(Now you can add mongodb credentials in .env)"  -ForegroundColor green
Write-Host "Happy Coding!"  -ForegroundColor green
echo ""
Write-Host "(This script is made by SKJ)"  -ForegroundColor green

# -------------------------------------------------------------------------------------------------------->
