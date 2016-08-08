module.exports = (state = {}, action) ->
  switch action.type
    when 'SET_USER'
      return action.user
    else
      return state
