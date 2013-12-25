revise-rails
============

Revision Storage for Event Sourcing (Event Store) - Rails Implementation


### Storing a Revision

A Revision contains a resource description and an array of events. 

The resource description contains the type of object, its UUID, and the expected version
of the object at the time of the revision. 

If two revisions contain the same resource description, the first will succeed, and
the second will fail with a conflict.

Events must contain a type, the time of occurrence, and a payload.

The payload may contain information that can be used to rebuild the object specified in the resource description.


```
POST /revisions
Content-Type:application/json
Accept:application/json
Authorization: Token token="{your app token here}"

{ 
  "revision": {
    "resourceType": "User",
    "resourceUUID": "9884bb97-c356-4ab7-8051-31638d440d02",
    "resourceVersion": 0,
    "events": [
      {
        "type": "UserRegistered",
        "occurredAt": "2013-12-25T00:00:00Z",
        "payload": {
          "username": "user1",
          "domain": "example.com"
        }
      }
    ]
  }
}

```
