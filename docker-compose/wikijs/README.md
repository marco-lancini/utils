# Wikijs

Wekan is an open-source Wiki.


## Usage

* Edit `docker-compose.yml`:
    * Replace the `volume` locations, from `/docker/data/wekan/...` to the folder on your filesystem where you want to persist data
    * Change the default password
* Start the service: `docker-compose up`
* Access WikiJS: `127.0.0.1:3000`
