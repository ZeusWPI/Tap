#= require action_cable

@App ||= {}
App.cable = ActionCable.createConsumer()
