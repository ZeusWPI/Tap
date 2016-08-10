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

fetchUrl = (path) ->
  "#{@window.base_url}/#{path}"

loadData = (path, callback) ->
  (dispatch) ->
    fetch fetchUrl(path), credentials
      .then (response) ->
        throw new Error('Bad response from server') if response.status >= 400
        return response.json()
      .then (data) ->
        dispatch callback data

module.exports.fetchUser = ->
  loadData 'user.json', setUser

module.exports.fetchOrders = ->
  loadData 'orders.json', setOrders

module.exports.fetchContributions = ->
  loadData 'stats/contributions.json', setContributions

module.exports.updateAvatar = (avatar) ->
  fetch fetchUrl('user'), Object.assign {}, credentials, {
    method: 'PUT'
    headers:
      'Accept':       'application/json'
      'Content-Type': 'application/json'
    body: JSON.stringify {
      authenticity_token: document.querySelector('meta[name=csrf-token]').content
      user:
        avatar: avatar
    }
  }
