moment = require 'moment'
credentials = require '../utils/credentials'
{ SET_USER, SET_ORDERS } = require '../constants/action_types'

formatDate = (date) ->
  moment(date).format('YYYY-MM-DD')
module.exports.formatDate = formatDate

setOrders = (orders) ->
  { type: SET_ORDERS, orders }

setUser = (user) ->
  { type: SET_USER, user }

module.exports.fetchUser = ->
  (dispatch) ->
    fetch '/user.json', credentials
      .then (response) ->
        throw new Error('Bad response from server') if response.status >= 400
        return response.json()
      .then (data) ->
        dispatch setUser data

module.exports.fetchOrders = ->
  (dispatch) ->
    fetch '/orders.json', credentials
      .then (response) ->
        throw new Error('Bad response from server') if response.status >= 400
        return response.json()
      .then (data) ->
        dispatch setOrders data
