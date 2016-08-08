{ svg, g, rect, text, span } = React.DOM
moment      = require 'moment'
{ connect } = require 'react-redux'

chunk          = require '../utils/chunk'
{ formatDate } = require '../actions/action_creators'

COLORS = { 0: '#eee', 1: '#d6e685', 2: '#8cc665', 3: '#44a340', 4: '#1e6823' }
MONTHS = { 0: 'Jan', 1: 'Feb', 2: 'Mar', 3: 'Apr', 4: 'May', 5: 'Jun', 6: 'Jul', 7: 'Aug', 8: 'Sep', 9: 'Oct', 10: 'Nov', 11: 'Dec' }

getColor = (v) ->
  COLORS[v] || COLORS[4]

Rect = React.createFactory React.createClass
  render: ->
    { count, date, index } = @props
    rect className: 'day', width:'11', height:'11', y: 13 * index, fill: getColor(count), 'data-count': count, 'data-date': date

# Feel free to rewrite this component
Months = React.createFactory React.createClass
  render: ->
    monday = moment().startOf('isoweek')._d
    month = monday.getMonth()
    g null,
      [0..month].map (i) ->
        x = ( 52 - Math.floor( Math.floor( ( monday - new Date(monday.getFullYear(), i, 1)) / (1000 * 60 * 60 * 24)) / 7)) * 13
        Text key: i, x: x, y: -5, t: MONTHS[i]
      [month+1..11].map (i) ->
        x = ( 52 - Math.floor( Math.floor( ( monday - new Date(monday.getFullYear()-1, i, 1)) / (1000 * 60 * 60 * 24)) / 7)) * 13
        Text key: i, x: x, y: -5, t: MONTHS[i]

Text = React.createFactory React.createClass
  render: ->
    { x, y, t } = @props
    text textAnchor: 'middle', className: 'wday', dx: x, dy: y, t

CalendarGraph = React.createClass
  count: (date) ->
    @props.contributions[formatDate(date)] || 0
  render: ->
    dates = chunk moment.range(moment().startOf('isoweek').subtract(51, 'weeks'), moment()).toArray('days'), 7
    svg height: 110, width: 721, className: 'calendar-graph',
      g transform: 'translate(20, 20)',
        dates.map (d, i) =>
          g key: i, transform: "translate(#{13 * i}, 0)",
            d.map (day, i) =>
              dd = day._d
              Rect key: i, index: i, count: @count(dd), date: dd
        Months null
        Text x: -10, y: 9,  t: 'M'
        Text x: -10, y: 35, t: 'W'
        Text x: -10, y: 61, t: 'F'
        Text x: -10, y: 87, t: 'S'

mapStateToProps = (state) ->
  { stats: { contributions } } = state
  { contributions }
module.exports = connect(mapStateToProps)(CalendarGraph)
