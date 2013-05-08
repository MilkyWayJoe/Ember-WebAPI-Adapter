
get = Em.get

DS.WebAPISerializer = DS.RESTSerializer.extend
  keyForAttributeName: (type, name) ->
    name

  extractMany: (loader, json, type, records) ->
    root = @rootForType(type)
    root = @pluralize(root)

    if(json instanceof Array)
      objects = json
    else
      @sideload(loader, type, json, root)
      @extractMeta(loader, type, json)
      objects = json[root]

    if objects
      references = []
      if records
        records = records.toArray()
        for i in [0..objects.length-1] by 1
          if (records) 
            loader.updateId(records[i], objects[i])

          reference = @extractRecordRepresentation(loader, type, objects[i])
          references.push reference

        loader.populateArray(references)
        return
  extract: (loader, json, type, record) ->
    if (record)
      loader.updateId(record, json)
    this.extractRecordRepresentation(loader, type, json)

  rootForType: (type) ->
    typeString = type.toString()
    Ember.assert("Your model must not be anonymous. It was " + type, typeString.charAt(0) != '(')
    parts = typeString.split(".")
    name = parts[parts.length - 1]
    name.toLowerCase()