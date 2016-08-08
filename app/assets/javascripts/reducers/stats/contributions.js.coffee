{ ADD_CONTRIBUTION, SET_CONTRIBUTIONS } = require '../../constants/action_types'

module.exports = (state = {}, action) ->
  switch action.type
    when ADD_CONTRIBUTION
      { contribution: { date, count } } = action
      newState = Object.assign {}, state
      newState[date] = count
      newState
    when SET_CONTRIBUTIONS
      { contributions } = action
      contributions
    else
      state
