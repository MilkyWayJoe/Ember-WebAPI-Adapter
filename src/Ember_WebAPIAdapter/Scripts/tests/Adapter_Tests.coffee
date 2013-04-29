## <reference path="../../../jquery-1.9.1.js" />
## <reference path="../../../handlebars.js" />
## <reference path="../../../ember-1.0.0-rc.3.js" />
## <reference path="../../../ember-data.js" />
## <reference path="../lib/WebAPI_Serializer.js" />
## <reference path="../lib/WebAPI_Adapter.js" />

get = Ember.get 
set = Ember.set

adapter = null
Person = null
storeStub = null

module "DS.WebAPIAdapter"
  setup: ->
    adapter = DS.WebAPIAdapter.create()
    Person = Ember.Object.extend()
    storeStub = Ember.Object.create()
    return
  
  teardown: ->
    adapter.destroy()
    return

#Test Example
test "the `commit` should call createRecord once per type", ->
  expect 2

  adapter.createRecords = (store, type, set) ->
    equal type, Person, "the passed type is Person"
    equal get(set.toArray(), 'length'), 2, 'the array is has two items'
    return
  
  tom = Person.create({ name: "Tom Dale", updatedAt: null });
  yehuda = Person.create({ name: "Yehuda Katz" });
  
  adapter.commit storeStub, 
    updated: [],
    deleted: [],
    created: [tom, yehuda]