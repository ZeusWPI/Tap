React                            = require 'react'
{ button, div, h1, i, img, input, span } = React.DOM
{ connect }                      = require 'react-redux'

credentials      = require '../utils/credentials'
{ updateAvatar } = require '../actions/action_creators'

Avatar = React.createClass
  getInitialState: ->
    src: @props.src, changed: false
  componentWillReceiveProps: (props) ->
    @setState src: props.src
  trigger: ->
    @refs.input.click()
  filechange: (e) ->
    reader = new FileReader()
    reader.onload = (e) =>
      @setState src: e.target.result, changed: true
    reader.readAsDataURL @refs.input.files[0]
  reset: ->
    @refs.input.value = null
  discard: ->
    @setState src: @props.src, changed: false
    @reset()
  save: ->
    updateAvatar(@state.src)
      .then (response) =>
        throw new Error('Bad response from server') if response.status >= 400
        @setState changed: false
        @reset()
        true
  render: ->
    { name } = @props
    { changed, src }   = @state
    div className: 'card-box avatar',
      h1 null, name
      div className: 'wrapper',
        div className: 'input-wrapper', onClick: @trigger,
          div className: 'img-square-wrapper',
            img src: src
          span null,
            i className: 'fa fa-edit'
          input type: 'file', ref: 'input', onChange: @filechange
        if changed
          div className: 'actions',
            button className: 'pure-button save', onClick: @save,
              i className: 'fa fa-check'
            button className: 'pure-button discard', onClick: @discard,
              i className: 'fa fa-times'

mapStateToProps = (state) ->
  { user } = state
  { user }
module.exports = connect(mapStateToProps)(Avatar)
