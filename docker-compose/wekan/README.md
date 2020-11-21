# Wekan

Wekan is an open-source alternative to Trello.


## Usage

* Edit `docker-compose.yml`:
    * Replace the `volume` locations, from `/docker/data/wekan/...` to the folder on your filesystem where you want to persist data
    * Change the default password
* Start the service: `docker-compose up`
* Access Wekan: `127.0.0.1:9001`
* *[Optional]* Add aliases to quickly spin this up/down:
```bash
alias wekan_up="docker-compose -f /Users/x/wekan/docker-compose.yml up"
alias wekan_down="docker-compose -f /Users/x/wekan/docker-compose.yml down"
```


## Wekan JSON -> CSV Converter

In addition, the `json-to-csv.py` script will parse a JSON export of a Wekan board and produce a CSV file containing, for every card:
* swimlane
* list
* title
* description (with checklists)
* labels
* user
* members
* created_at
* last_activity

Usage: `convert.py -i <input json file>`
