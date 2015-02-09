Ruby sinatra app using linkedin API.

Usage
1. Authorize

```
/auth
```
This will take you to linkedin authorize page

2. Query for profile

```
/profile?url=https://www.linkedin.com/in/williamhgates
```

Response:
```
{"first_name":"Bill","headline":"Co-chair, Bill & Melinda Gates Foundation","id":"hGcQSnSuOO","last_name":"Gates","site_standard_profile_request":{"url":"https://www.linkedin.com/profile/view?id=251749025&authType=name&authToken=sSHS&trk=api*a4268961*s4330191*"}}
```

3. Query for companies
```
http://localhost:4567/company?keywords=filepicker.io
```

Response:
```
{"companies":{"total":3,"all":[{"id":3127235,"name":"Filepicker.io"},{"id":3292129,"name":"Ink"},{"id":3200454,"name":"Ink Mobility"}]},"facets":{"total":1,"all":[{"buckets":{"total":2,"all":[{"code":"us:0","count":3,"name":"United States","selected":false},{"code":"us:84","count":3,"name":"San Francisco Bay Area","selected":false}]},"code":"location","name":"Location"}]},"total_results":3}
```
