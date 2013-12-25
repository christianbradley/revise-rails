revise-rails
================================================================================

Revision Storage Server for Event Sourcing (Event Store) - Rails Implementation

* Support the [Event Sourcing][event-sourcing] pattern
* JSON REST API
* rails 4.x / ruby 2.x
* support for optimistic concurrency control via revision resource descriptors
* currently supports only ActiveRecord relational DBs (MySQL, PostgreSQL, SQLite...)

Overview
--------------------------------------------------------------------------------

*Revise* serves as a repository of Events which have occurred during a Revision 
of a Resource.

For most cases, you may only need to pass a single Event along with a Revision. However,
there may be times when a single Revision must contain multiple Events in order to provide
atomicity for the commit. 

*Revise* supports optimistic concurrency by requiring a Resource Description for each commit. 
The Resource Description must contain the following values:

* resourceType: The type, or class of resource (User, Post, etc)
* resourceUUID: The uuid of the resource
* resourceVersion: The expected version of the resource (0 for new)

If two commits containing the same Resource Description are attempted, the first will
succeed, and the second will fail with a Conflict error.

Each Event for the Revision must contain the following values:

* type: The type, or class of event (UserRegistered, PostUpdated, etc)
* occurredAt: An [RFC3339][rfc3339] compliant time string
* payload: Any valid JSON, containing the information about the event

The data contained within the payload can be used to reconstruct your domain objects.


API Basics
--------------------------------------------------------------------------------

The server currently supports a simple JSON REST API:


### Making Requests

* All requests must contain the HTTP header `Accept:application/json`.
* As Authorization is currently limited to HTTP Tokens, use of SSL/TLS is advised.

### POST Parameters

* POST parameters must be sent via JSON
* Parameter names are expected to follow JSON conventions (ie: _camelCaseKeys_)
* Requests must contain the HTTP header `Content-Type:application/json`.

### Authorization

* The server currently supports only HTTP Token Authorization
* All requests must be authenticated
* Requests must contain the HTTP header `Authorization: Token token="your-access-token-here"`
* To create an authorization token: `RAILS_ENV=development rake token:create` (for development)


Storing a Revision
--------------------------------------------------------------------------------

*POST* to `/revisions`

### Sending the Request

Simply pass along the JSON data with your POST request. Use JSON conventions for your
keys:

```json
{ 
  "revision": {
    "resourceType": "User",
    "resourceUUID": "b66a20ed-5776-4787-9f1b-530a352d4c7b",
    "resourceVersion": 0,
    "events": [
      {
        "type": "UserRegistered",
        "occurredAt": "2013-05-25T05:32:00.123456Z",
        "payload": {
          "username": "user1",
          "email": "user1@example.com"
        }
      }
    ]
  }
}
```


### A Successful Response

If your request was successful, you should receive the following response:

* Status: HTTP 201 CREATED
* Content-Type:application/json
* Location: http://example.com/revisions/1

```json
{
  "revision": {
    "id": 1,
    "url": "http://example.com/revisions/1",
    "resourceType": "User",
    "resourceUUID": "b66a20ed-5776-4787-9f1b-530a352d4c7b",
    "resourceVersion": 0,
    "events": [
      {
        "type": "UserRegistered",
        "occurredAt": "2013-05-25T05:32:00.123456Z",
        "payload": {
          "username": "user1",
          "email": "user1@example.com"
        }
      }
    ]
  }
}
```

### Conflicting Revisions

A conflict may occur while saving a Revision. This means another Revision used the 
same Resource Description and was saved prior to your request. In this case, you will
receive the following response:

* Status: HTTP 409 CONFLICT
* Content-Type:application/json

```json
{ 
  "error": {
    "type": "RevisionConflictError",
    "message": "Could not create this revision due to a conflict with an existing revision.",
    "revision": {
      //... your revision request here
    },
    "conflicting": {
      //... conflicting revision here
    }
  }
}
```

### Validation Errors

If the JSON you passed was invalid, you will receive the following response:

* Status: HTTP 422 UNPROCESSABLE ENTITY
* Content-Type:application/json

```json
{
  "error": {
    "type": "ValidationError",
    "message": "Could not create this revision due to invalid parameters.",
    "revision": {
      "resourceType": null,
      "resourceUUID": null,
      "resourceVersion": -1,
      "events": [
        { 
          "type": null,
          "occurredAt": null,
          "payload": null,
          "errors": {
            "type": [ "can't be blank" ],
            "occurredAt": [ "can't be blank" ],
            "payload": [ "can't be blank" ]
          }
        }
      ]

      "errors": {
        "events": [ "is invalid" ],
        "resourceType": [ "can't be blank" ],
        "resourceUUID": [ "can't be blank" ],
        "resourceVersion": [ "can't be blank", "must be a number", "must be greater than 0" ]
      }
    }
  }
}
```

As you can see, you will find an "errors" object on the Revision and/or any of the Event
objects it contains. This object will contain a field for each key in the original object that has an error, and
the value of that field is an Array of messages.

---

[event-sourcing]: http://martinfowler.com/eaaDev/EventSourcing.html

[rfc3339]: http://www.ietf.org/rfc/rfc3339.txt
