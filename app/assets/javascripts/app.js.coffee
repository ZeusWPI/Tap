React = require 'react'
{ IndexRoute, Router, Route, browserHistory } = require 'react-router'

# STORE

{ createStore, applyMiddleware }           = require 'redux'
reducer                                    = require './reducers/combine_reducer'

store   = createStore reducer

# RENDER PAGE

{ render }   = require 'react-dom'
{ Provider } = require 'react-redux'

User = require './components/user'

render(
  React.createElement Provider, store: store,
    React.createElement Router, history: browserHistory,
      React.createElement Route, path: '/', component: User
  document.getElementById 'content'
)

# FETCH DATA

{ fetchUser, fetchOrders, fetchContributions } = require './actions/action_creators'
fetchUser()(store.dispatch)
fetchOrders()(store.dispatch)
fetchContributions()(store.dispatch)
