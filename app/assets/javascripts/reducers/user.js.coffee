{ SET_USER } = require '../constants/action_types'

module.exports = (state = {}, action) ->
  switch action.type
    when SET_USER
      return action.user
    else
      return state
