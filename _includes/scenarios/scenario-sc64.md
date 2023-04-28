
<!-- This include inserts the table with the metadata  -->

{% include properties_list.html %}


Create the Relationship Template on the Templator's Connector. You can do so by calling the `POST /api/v2/RelationshipTemplates/Own` route. Use the following JSON in the Request body:

```jsonc
{
  "maxNumberOfAllocations": 1,
  "expiresAt": "2023-06-01T00:00:00.000Z",
  "content": {
    "@type": "RelationshipTemplateContent",
    "title": "Connector Demo Contact",
    "onNewRelationship": {
      // the content property of the payload in the step before
    }
  }
}
```

You will receive a response with the complete RelationshipTemplate.

{% include copy-notice description="Save the `truncatedReference` and the `id` of the RelationshipTemplate. You will need them in the next steps." %}

```jsonc
{
  "id": "RLT..",
  // ...
  "truncatedReference": "UkxU..."
}
```