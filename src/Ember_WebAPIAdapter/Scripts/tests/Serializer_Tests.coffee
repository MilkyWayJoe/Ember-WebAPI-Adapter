## <reference path="../jquery-1.9.1.js" />
## <reference path="../handlebars.js" />
## <reference path="../ember-1.0.0-rc.3.js" />
## <reference path="../ember-data.js" />
## <reference path="../lib/WebAPI_Serializer.js" />
## <reference path="../lib/WebAPI_Adapter.js" />

get = Ember.get 
set = Ember.set

serializer = null
collection = []
storeStub = null

module "DS.WebAPISerializer",
  setup: ->
    serializer = DS.WebAPISerializer.create()
    return
  teardown: ->
    serializer.destroy()
    return

test "Can serialize a single object from JSON payload", ->

  expect 2
  
  App = Ember.Namespace.create
    toString: -> 
      "App"

  App.Show = DS.Model.extend 
    title: DS.attr 'string'

  serializer.configure App.Show, {
    sideloadAs: 'shows'
  }

  payload = {
    id: 1,
    title: 'MacGyver'
  }

  loadCallCount = 0
  updateIdCount = 0

  loader = {
    load: (type, data, prematerialized) ->
      loadCallCount++
      return
    prematerialize: Ember.K
    populateArray: Ember.K,
    updateId: (r, o) ->
      updateIdCount++
      return
  }

  serializer.extract(loader, payload, App.Show, payload);

  equal(loadCallCount, 1, "Loads all records from JSON payload");
  equal(updateIdCount, 1, "Calls updateId for each individual record in JSON payload");

  return
  
test "Can serialize an Array from a rootless JSON payload", ->
  expect 2

  App = Ember.Namespace.create
    toString: -> 
      "App"

  App.Show = DS.Model.extend 
    title: DS.attr 'string'

  serializer.configure App.Show, {
    sideloadAs: 'shows'
  }

  payload = [
    {
      id: 1,
      title: 'MacGyver'
    },
    {
      id: 2,
      title: 'Thundercats'
    },
    {
      id: 3,
      title: 'Magnum, P.I.'
    }
  ]

  loadCallCount = 0
  updateIdCount = 0

  loader = {
    load: (type, data, prematerialized) ->
      loadCallCount++
      return
    prematerialize: Ember.K
    populateArray: Ember.K,
    updateId: ->
      updateIdCount++
      return
  }

  serializer.extractMany(loader, payload, App.Show, payload);

  equal(loadCallCount, 3, "Loads all records from JSON payload");
  equal(updateIdCount, 3, "Calls updateId for each individual record in JSON payload");

  return

test "Can serialize an Array from a rootless JSON payload with hasMany", ->
  ### 
  not yet implemented 
  ###
  expect 0