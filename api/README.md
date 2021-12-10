# Query an API

> Application that allows a user to query and show details for a given UK postcode

## Dependencies

`requests==2.25.1`
`unittest`

## Usage

```python
from request_api import RequestAPI
```

Create a new instance

```python
postcode = RequestAPI('CB3 0FA')
```

Check if the postcode is valid

```python
postcode.is_valid()
```

## Requirements

- Console output
- Application accepts a postcode as argument to the `RequestAPI` class.
- It should query the API to:

  - Validate the postcode parameter – invalid postcodes should produce an error message
  - Print the country and region for that postcode.
  - Print a list of the nearest postcodes, and their countries and regions.

- API methods used:

  - `GET /postcodes/{POSTCODE}`
  - `GET /postcodes/{POSTCODE}/validate`
  - `GET /postcodes/{POSTCODE}/nearest`
  - `GET /postcodes/{POSTCODE}/autocomplete`

- Basic unit tests, doctests