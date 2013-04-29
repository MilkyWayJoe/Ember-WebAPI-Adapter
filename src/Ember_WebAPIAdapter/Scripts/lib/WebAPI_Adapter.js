(function() {
  var get;

  get = Em.get;

  DS.WebAPIAdapter = DS.RESTAdapter.extend({
    serializer: DS.WebAPISerializer,
    antiForgeryTokenSelector: null,
    shouldSave: function(record) {
      return true;
    },
    dirtyRecordsForBelongsToChange: null,
    createRecord: function(store, type, record) {
      var config, data, primaryKey, root;
      root = this.rootForType(type);
      data = this.serialize(record, {
        includeId: false
      });
      config = get(this, 'serializer').configurationForType(type);
      primaryKey = config && config.primaryKey;
      if (primaryKey) {
        delete data[primaryKey];
      }
      return this.ajax(this.buildURL(root), 'POST', {
        data: data,
        context: this,
        success: function(json) {
          Ember.run(this, function() {
            this.didCreateRecord(store, type, record, json);
          });
        },
        error: function(xhr) {
          this.didError(store, type, record, xhr);
        }
      });
    },
    updateRecord: function(store, type, record) {
      var data, id, root;
      id = get(record, 'id');
      root = this.rootForType(type);
      data = this.serialize(record, {
        includeId: true
      });
      return this.ajax(this.buildURL(root, id), "PUT", {
        data: data,
        context: this,
        success: function(json) {
          Ember.run(this, function() {
            this.didSaveRecord(store, type, record, json);
          });
          record.set("error", "");
        },
        error: function(xhr) {
          Ember.run(this, function() {
            this.didSaveRecord(store, type, record);
          });
          record.set("error", "Server update failed");
        }
      }, 'text');
    },
    deleteRecord: function(store, type, record) {
      var config, id, primaryKey, root;
      id = get(record, 'id');
      root = this.rootForType(type);
      config = get(this, 'serializer').configurationForType(type);
      return primaryKey = config && config.primaryKey;
    }
  });

}).call(this);
