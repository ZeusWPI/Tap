React = require 'react'
{ div, span, i, img } = React.DOM
{ connect } = require 'react-redux'
moment      = require 'moment'
range       = require 'moment-range'
Link        = React.createFactory require('react-router').Link

{ formatDate } = require '../actions/action_creators'
zero           = require '../utils/zero'

Page = React.createFactory React.createClass
  render: ->
    { date } = @props
    Link to: { pathname: '/', query: { end: date } },
      @props.children

Pagination = React.createFactory React.createClass
  date: (d) ->
    if d
      date = new Date d
      '' + date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()
    else
      undefined
  render: ->
    m = moment()
    div className: 'pagination-wrapper',
      div className: 'pagination',
        Page null,
          i className: 'fa fa-long-arrow-left'
        Page null, 1
        [2..6].map (i) =>
          m.subtract(7, 'days')
          Page key: i, date: @date(m._d), i
        Page date: '2016-2-2',
          i className: 'fa fa-long-arrow-right'

Orders = React.createClass
  weekRange: ->
    { end } = @props.query
    end ||= new Date()
    moment.range moment(end, 'YYYY-MM-DD').subtract(6, 'days'), moment(end)
  render: ->
    { orders } = @props
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
      Pagination null

mapStateToProps = (state, ownProps) ->
  orders: state.orders
module.exports = connect(mapStateToProps)(Orders)
