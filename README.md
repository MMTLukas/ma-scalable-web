# Final Challenge

This documents describes how to start and test the four services of this repository. The services are:
  * item tracking system: holds 
  * location management system:
  * report system:
  * user management:

All commands in these document should be executed in the root directory.

## Item Tracking System

Start:  bundle exec rackup -o 0.0.0.0 -p 9292 config_item_tracking_system.ru
Test:   httparty -v -u paul:thepanther http://localhost:9292/items
        httparty -v -u paul:thepanther -a post '{"name":"PC","location":"1"}' http://localhost:9292/items
        httparty -v -u paul:thepanther -a delete http://localhost:9292/items/1


## Location Management System

Start:  bundle exec rackup -o 0.0.0.0 -p 9393 config_location_management_system.ru
Test:   httparty -v -u paul:thepanther http://localhost:9393/locations
        httparty -v -u paul:thepanther -a post '{"name":"FH","address":"urstein"}' http://localhost:9393/locations
        httparty -v -u paul:thepanther -a delete http://localhost:9393/locations/1


## Report System

**Start
```shell
  bundle exec rackup -o 0.0.0.0 -p 9494 config_report_system.ru
```

**Test
```shell
httparty -v -u paul:thepanther http://localhost:9494/reports/by-location
```

## User Management System

Start:  bundle exec rackup -o 0.0.0.0 -p 9595 config_user_management_system.ru
Test:   httparty -v -u paul:thepanther "http://localhost:9595/user











# Final Challenge
## Intro
* A user management system
## The Systems
### User Management
**GET /user**

User  | Password
----- | -------------
wanda | partyhard2000
paul  | thepanther
anne  | flytothemoon

```json
{
  "name" => "Office Alexanderstraße",
  "address" => "Alexanderstraße 45, 33853 Bielefeld, Germany",
  "id" => 562
}
```

```json
[
  {
    "name": "Johannas PC",
    "location": 123,
    "id": 456
  },
  {
    "name": "Johannas desk",
    "location": 123,
    "id": 457
  },
  {
    "name": "Lobby chair #1",
    "location": 729,
    "id": 501
  }
]
```

```json
[
  {
    "name": "Office Alexanderstraße",
    "address": "Alexanderstraße 45, 33853 Bielefeld, Germany",
    "id": 562,
    "items": [
      {
        "name": "Johannas PC",
        "location": 562,
        "id": 456
      },
      {
        "name": "Johannas desk",
        "location": 562,
        "id": 457
      }
    ]
  },
  {
    "name": "Warehouse Hamburg",
    "address": "Gewerbestraße 1, 21035 Hamburg, Germany",
    "id": 563,
    "items": [
      {
        "name": "Lobby chair #1",
        "location": 563,
        "id": 501
      }
    ]
  }
]
