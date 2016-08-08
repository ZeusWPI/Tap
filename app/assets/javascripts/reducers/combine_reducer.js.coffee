{ combineReducers } = require 'redux'

user   = require './user'
orders = require './orders'
stats  = require './stats'

module.exports = combineReducers({
  user,
  orders,
  stats
})
