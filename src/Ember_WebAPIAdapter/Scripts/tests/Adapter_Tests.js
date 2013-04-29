(function() {
  var Person, adapter, get, set, storeStub;

  get = Ember.get;

  set = Ember.set;

  adapter = null;

  Person = null;

  storeStub = null;

  module("DS.WebAPIAdapter", {
    setup: function() {
      adapter = DS.WebAPIAdapter.create();
      Person = Ember.Object.extend();
      storeStub = Ember.Object.create();
    },
    teardown: function() {
      adapter.destroy();
    }
  });

  test("the `commit` should call createRecord once per type", function() {
    var tom, yehuda;
    expect(2);
    adapter.createRecords = function(store, type, set) {
      equal(type, Person, "the passed type is Person");
      equal(get(set.toArray(), 'length'), 2, 'the array is has two items');
    };
    tom = Person.create({
      name: "Tom Dale",
      updatedAt: null
    });
    yehuda = Person.create({
      name: "Yehuda Katz"
    });
    return adapter.commit(storeStub, {
      updated: [],
      deleted: [],
      created: [tom, yehuda]
    });
  });

}).call(this);
