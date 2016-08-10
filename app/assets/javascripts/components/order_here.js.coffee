React = require 'react'
{ div, img }     = React.DOM
{ connect } = require 'react-redux'

OrderHere = React.createClass
  render: ->
    { user } = @props
    div className: 'card-box order-here',
      div className: 'pure-g',
        (user?.dagschotels || []).map (d, i) ->
          div key: i, className: 'pure-u-1-2',
            img src: d.avatar, className: 'img-square'

mapStateToProps = (state) ->
  { user } = state
  { user }
module.exports = connect(mapStateToProps)(OrderHere)
