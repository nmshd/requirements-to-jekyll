<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}

To create the Request you have to call the `POST /api/v2/Requests/Outgoing` route on the Sender Connector. Use the following JSON in the Request body:

```jsonc
{
  "content": {
    // the content property of the payload in the step before
  },
  "peer": "<the address of the Recipient Connector>"
}
```

Note that the Request is currently in status `Draft`.

{% include copy-notice description="Save the complete `content` of the response. You will need it in the next step." %}

**Example response:**

```jsonc
{
  "id": "REQ...",
  "status": "Draft",
  // ...
  "content": {
    "@type": "Request",
    "id": "REQ...",
    "items": [
      {
        "@type": "AuthenticationRequestItem",
        "mustBeAccepted": true,
        "title": "The Sender is asking for an authentication"
      }
    ]
  }
}
```
