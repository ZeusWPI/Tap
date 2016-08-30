module.exports.user_channel = =>
  (dispatch) =>
    App.cable.subscriptions.create 'UserChannel',
      received: (action) ->
        dispatch action
