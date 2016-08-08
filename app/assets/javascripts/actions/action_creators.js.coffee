moment = require 'moment'
credentials = require '../utils/credentials'
{ SET_CONTRIBUTIONS, SET_USER, SET_ORDERS } = require '../constants/action_types'

formatDate = (date) ->
  moment(date).format('YYYY-MM-DD')
module.exports.formatDate = formatDate

setContributions = (contributions) ->
  { type: SET_CONTRIBUTIONS, contributions }

setOrders = (orders) ->
  { type: SET_ORDERS, orders }

setUser = (user) ->
  { type: SET_USER, user }

loadData = (path, callback) ->
  (dispatch) ->
    fetch "#{@window.base_url}/#{path}", credentials
      .then (response) ->
        throw new Error('Bad response from server') if response.status >= 400
        return response.json()
      .then (data) ->
        console.log data
        dispatch callback data

module.exports.fetchUser = ->
  loadData 'user.json', setUser

module.exports.fetchOrders = ->
  loadData 'orders.json', setOrders

module.exports.fetchContributions = ->
  loadData 'stats/contributions.json', setContributions
