(function() {
  var get;

  get = Em.get;

  DS.WebAPISerializer = DS.RESTSerializer.extend({
    keyForAttributeName: function(type, name) {
      return name;
    },
    extractMany: function(loader, json, type, records) {
      var i, objects, reference, references, root, _i, _ref;
      root = this.rootForType(type);
      root = this.pluralize(root);
      if (json instanceof Array) {
        objects = json;
      } else {
        this.sideload(loader, type, json, root);
        this.extractMeta(loader, type, json);
        objects = json[root];
      }
      if (objects) {
        references = [];
        if (records) {
          records = records.toArray();
          for (i = _i = 0, _ref = objects.length - 1; _i <= _ref; i = _i += 1) {
            if (records) {
              loader.updateId(records[i], objects[i]);
            }
            reference = this.extractRecordRepresentation(loader, type, objects[i]);
            references.push(reference);
          }
          loader.populateArray(references);
        }
      }
    },
    extract: function(loader, json, type, record) {
      if (record) {
        loader.updateId(record, json);
      }
      return this.extractRecordRepresentation(loader, type, json);
    },
    rootForType: function(type) {
      var name, parts, typeString;
      typeString = type.toString();
      Ember.assert("Your model must not be anonymous. It was " + type, typeString.charAt(0) !== '(');
      parts = typeString.split(".");
      name = parts[parts.length - 1];
      return name.toLowerCase();
    }
  });

}).call(this);
