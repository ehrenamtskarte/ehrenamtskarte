# Map Editing

We are using the [osm-liberty](https://github.com/maputnik/osm-liberty ) base style.

## Adding icons

See [here](../map-icons/README.md)

# Styling the Map

You can use Maputnik to edit style the map:

1. Download Maputnik CLI from [github.com/maputnik/editor/releases](https://github.com/maputnik/editor/releases)
2. Run `~/Downloads/maputnik --file docker/reverse_proxy/www/style.json`
3. Commit the style.json after editing!

## Filling postgis with GeoJSON

If you need a GeoJSON file in a postgis database for testing you can use the following command:

```bash
ogr2ogr -f "PostgreSQL" PG:"dbname=ehrenamtskarte host='localhost' port='5432' user=postgres password=postgres" verguenstigungen.json
```
