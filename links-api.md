# Links Director API

Links are typically provided in the ERB templates for job to share information. In some cases it's necessary to obtain that information via the API to share it with others.

Following endpoints would be exposed:

```
GET /links?from=link-name&deployment=my-dep&[network=my-net]&include_properties=false

200 OK
{
  "instances": [
    {
      "address": "ipv4|ipv6|dns-rec",
      "az": 
      "index":
      "id":
    },{
      "address": "ipv4|ipv6|dns-rec",
      "az": 
      "index":
      "id":
    }
  ]
}

404 Not Found
```

- expects link to be marked as `shared: true` in the deployment
- expects deployment to succeed for the link to be exposed via the API
- `include_properties=false` is required to avoid exposing sensitive information
- depending on confiugration of the deployment addresses would be ip or dns

```
GET /link_address?link[from]=link-name&link[deployment]=my-dep&[link[network]=my-net]

200 OK
"q-iusawf..."

404 Not Found
```

- allows to provide `azs: []` and potentially other address filters
