﻿get = Em.get

DS.WebAPIAdapter = DS.RESTAdapter.extend
  serializer: DS.WebAPISerializer
  antiForgeryTokenSelector: null

  shouldSave: (record) ->
    true

  dirtyRecordsForBelongsToChange: null

  createRecord: (store, type, record) ->
    root = @rootForType(type)

    data = @serialize(record, { includeId: false })

    config = get(@,'serializer').configurationForType(type)
    primaryKey = config && config.primaryKey;

    if (primaryKey) 
      delete data[primaryKey]

    @ajax(@buildURL(root), 'POST',  {
      data: data
      context: @
      success: (json) ->
        Ember.run(@, ->
          @didCreateRecord(store, type, record, json)
          return
        )
        return
      error: (xhr) ->
        @didError(store, type, record, xhr)
        return
    })
  
  updateRecord: (store, type, record) ->
    id = get(record, 'id')
    root = this.rootForType(type);

    data = @serialize(record, { includeId: true })

    @ajax(@buildURL(root, id), "PUT", {
      data: data
      context: this
      success: (json) ->
        Ember.run(@, ->
          @didSaveRecord(store, type, record, json)
          return
        )
        record.set("error", "")
        return
      error: (xhr) ->
        Ember.run(@, ->
          this.didSaveRecord(store, type, record)
          return
        )
        record.set("error", "Server update failed")
        return
    }, 'text')

  deleteRecord: (store, type, record) ->
    id = get(record, 'id')
    root = this.rootForType(type);

    config = get(@, 'serializer').configurationForType(type)
    primaryKey = config && config.primaryKey

  ajax: (url, type, hash, dataType) ->
    hash = hash || { data: null }
    hash.url = url
    hash.type = type
    hash.dataType = dataType || 'json'
    hash.contentType = 'application/json; charset=utf-8'
    hash.context = @

    if (hash.data && type != 'GET') 
      hash.data = JSON.stringify hash.data

    antiForgeryTokenElemSelector = get(this, 'antiForgeryTokenSelector')
    if antiForgeryTokenElemSelector 
      antiForgeryToken = $(antiForgeryTokenElemSelector).val()
      if(antiForgeryToken)
        hash = {
          'RequestVerificationToken': antiForgeryToken
        }
    jQuery.ajax(hash)