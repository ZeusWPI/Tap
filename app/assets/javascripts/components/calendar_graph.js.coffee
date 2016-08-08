{ svg, g, rect, text, span } = React.DOM

COLORS = { 0: '#eee', 1: '#d6e685', 2: '#8cc665', 3: '#44a340', 4: '#1e6823' }
MONTHS = { 0: 'Jan', 1: 'Feb', 2: 'Mar', 3: 'Apr', 4: 'May', 5: 'Jun', 6: 'Jul', 7: 'Aug', 8: 'Sep', 9: 'Oct', 10: 'Nov', 11: 'Dec' }

getColor = (v) ->
  COLORS[v] || COLORS[4]

getMonday = ->
  today = new Date()
  day = today.getDay() || 7
  today.setHours(-24 * (day - 1)) if day != 1
  today

zero = (number) ->
  ('0' + number).slice -2

formatDate = (date) ->
  '' + date.getFullYear() + '-' + zero(date.getMonth() + 1) + '-' + zero(date.getDate())

incrementDate = (date) ->
  date.setDate date.getDate() + 1

Rect = React.createFactory React.createClass
  render: ->
    { count, date, index } = @props
    rect className: 'day', width:'11', height:'11', y: 13 * index, fill: getColor(count), 'data-count': count, 'data-date': new Date(date)

Month = React.createFactory React.createClass
  render: ->

Months = React.createFactory React.createClass
  render: ->
    monday = getMonday()
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
    { data } = @props
    data[formatDate(date)] || 0
  render: ->
    { data } = @props
    date = getMonday()
    date.setHours -24 * 7 * 51 - 24
    svg height: 110, width: 721, className: 'calendar-graph',
      g transform: 'translate(20, 20)',
        [0..50].map (i) =>
          g key: i, transform: 'translate(' + 13 * i + ', 0)',
            [0..6].map (i) =>
              incrementDate(date)
              count = @count(date)
              Rect key: i, index: i, count: count, date: date
        g transform: 'translate(' + 13 * 51 + ', 0)',
          [0..(new Date().getDay() || 7)-1].map (i) =>
            console.log i
            incrementDate(date)
            count = @count(date)
            Rect key: i, index: i, count: count, date: date
        Months null
        Text x: -10, y: 9,  t: 'M'
        Text x: -10, y: 35, t: 'W'
        Text x: -10, y: 61, t: 'F'
        Text x: -10, y: 87, t: 'S'

module.exports = React.createClass
  render: ->
    span null, 'hallo'
