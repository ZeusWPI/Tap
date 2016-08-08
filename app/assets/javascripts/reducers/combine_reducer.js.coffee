{ combineReducers, createStore } = require 'redux'

user   = require './user'
orders = require './orders'

module.exports = combineReducers({
  user,
  orders
})
