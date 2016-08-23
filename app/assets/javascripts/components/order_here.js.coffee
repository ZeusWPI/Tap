React = require 'react'
{ div, i, img }     = React.DOM
{ connect } = require 'react-redux'

OrderHere = React.createClass
  render: ->
    { user } = @props
    div className: 'card-box order-here',
      div className: 'pure-g',
        div className: 'pure-u-1-3'
        div className: 'pure-u-2-3',
          div className: 'pure-g',
            (user?.dagschotels || []).map (d, i) ->
              div key: i, className: 'pure-u-1-2',
                div className: 'img-square-wrapper',
                  img src: d.avatar
            if user?.dagschotels?.length < 4
              div className: 'pure-u-1-2',
                div className: 'img-square-wrapper',
                  i className: 'fa fa-plus'

mapStateToProps = (state) ->
  { user } = state
  { user }
module.exports = connect(mapStateToProps)(OrderHere)
