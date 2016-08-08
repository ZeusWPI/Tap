{ ADD_ORDER, SET_ORDERS } = require '../constants/action_types'
{ formatDate } = require '../actions/action_creators'

processOrder = (state, order) ->
  date = formatDate order.created_at
  if state[date]
    state[date].push order
  else
    state[date] = [ order ]

module.exports = (state = {}, action) ->
  switch action.type
    when ADD_ORDER
      { order } = action
      newState = Object.assign {}, state
      processOrder newState, order
      newState
    when SET_ORDERS
      { orders } = action
      newState = Object.assign {}, state
      for order in orders
        processOrder newState, order
      newState
    else
      state
