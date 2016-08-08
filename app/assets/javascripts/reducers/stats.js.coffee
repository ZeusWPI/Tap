{ combineReducers } = require 'redux'

contributions = require './stats/contributions'

module.exports = combineReducers({
  contributions
})
