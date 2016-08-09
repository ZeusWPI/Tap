{ div, span, h1, h2, h3, img, i, input } = React.DOM
{ connect } = require 'react-redux'
moment      = require 'moment'
range       = require 'moment-range'

CalendarGraph  = React.createFactory require './calendar_graph'
OrderHere      = React.createFactory require './order_here'
zero           = require '../utils/zero'
{ formatDate } = require '../actions/action_creators'

Avatar = React.createFactory React.createClass
  render: ->
    { src, name } = @props
    div className: 'card-box avatar',
      h1 null, name
      img src: src, className: 'img-square'

OrdersCount = React.createFactory React.createClass
  render: ->
    { count } = @props
    div className: 'pure-u-1-2',
      div className: 'card-box fact',
        h3 null, count || 0
        'Orders placed'

Balance = React.createFactory React.createClass
  render: ->
    { balance } = @props
    balance ||= 0
    div className: 'pure-u-1-2',
      div className: 'card-box fact',
        h3 null, '€', (balance/100).toFixed(2)
        'Balance'

Notify = React.createFactory React.createClass
  render: ->
    div className: 'card-box',
      h3 null, 'Notify me!'
      div className: 'input-group',
        i className: 'fa fa-slack'
        input placeholder: 'Username'
        i className: 'fa fa-floppy-o'

User = React.createClass
  weekRange: ->
    today = new Date()
    today.setDate today.getDate() - 6
    moment.range(today, new Date())
  render: ->
    { user, orders } = @props
    div className: 'pure-g',
      div className: 'pure-u-1 pure-u-lg-1-3',
        div className: 'pure-g',
          div className: 'pure-u-1 pure-u-md-1-2 pure-u-lg-1',
            Avatar src: user?.avatar, name: user?.name
            div className: 'pure-g',
              OrdersCount count: user?.orders_count
              Balance balance: user?.balance
          div className: 'pure-u-1 pure-u-md-1-2 pure-u-lg-1',
            OrderHere name: 'hallo'
            Notify null
      div className: 'pure-u-1 pure-u-lg-2-3',
        div className: 'card-box text-center',
          h2 null, 'Contributions (to the Zeus kassa)'
          CalendarGraph null
        div className: 'card-box',
          @weekRange().toArray('days').reverse().map (m, i) ->
            date = m._d
            div key: i, className: 'orders-overview',
              div className: 'date',
                span className: 'day', zero(date.getDate())
                span className: 'month', date.toLocaleString('en-us', { month: 'short' })
              div className: 'orders-thumbnails',
                (orders[formatDate(date)] || []).map (o, i) ->
                  img key: i, src: o.product.avatar, className: 'img-circle img-thumbnail', style: { zIndex: 100 - i }

mapStateToProps = (state) ->
  user: state.user,
  orders: state.orders
module.exports = connect(mapStateToProps)(User)
