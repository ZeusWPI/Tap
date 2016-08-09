{ div, h1, i, img, input, span }     = React.DOM
{ connect } = require 'react-redux'

Avatar = React.createClass
  render: ->
    { src, name } = @props
    div className: 'card-box avatar',
      h1 null, name
      div className: 'input-wrapper',
        img src: src, className: 'img-square'
        span null,
          i className: 'fa fa-edit'
        input type: 'file', ref: 'input'

mapStateToProps = (state) ->
  { user } = state
  { user }
module.exports = connect(mapStateToProps)(Avatar)
