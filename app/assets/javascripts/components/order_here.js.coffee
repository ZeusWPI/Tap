React = require 'react'
{ div, i, img }     = React.DOM
{ connect } = require 'react-redux'

{ createOrder } = require '../actions/action_creators'

Product = React.createFactory React.createClass
  handleClick: ->
    createOrder @props.p.order
  render: ->
    { p: { avatar } } = @props
    div className: 'img-square-wrapper', onClick: @handleClick,
      img src: avatar

OrderHere = React.createClass
  render: ->
    { user } = @props
    div className: 'card-box order-here',
      div className: 'pure-g',
        div className: 'pure-u-1-3'
        div className: 'pure-u-2-3',
          div className: 'pure-g',
            (user?.dagschotels || []).map (p, i) ->
              div key: i, className: 'pure-u-1-2',
                Product p: p
            if user?.dagschotels?.length < 4
              div className: 'pure-u-1-2',
                div className: 'img-square-wrapper',
                  i className: 'fa fa-plus'

mapStateToProps = (state) ->
  { user } = state
  { user }
module.exports = connect(mapStateToProps)(OrderHere)
