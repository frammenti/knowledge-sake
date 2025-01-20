---
toc: false
---
```js
const eu = FileAttachment("map/eu-map.json").json()
```
```js
const countries = topojson.feature(eu, eu.objects.countries).features
const coast = topojson.feature(eu, eu.objects.coast).features
const circle = d3.geoCircle().center([14, 54]).radius(18)()
```

# Education and Career Fulfillment Atlas


<div class="grid grid-cols-3">
  <div class="card grid-colspan-2">
    ${
      resize((width) => Plot.plot({
          width,
          projection: {
            type: "azimuthal-equal-area",
            rotate: [-9, -34],
            domain: circle,
            inset: 0
          },
        marks: [
          Plot.geo(countries, {fill: "currentColor", fillOpacity: 0.05, tip: true, title: (d) => d.properties.NAME_ENGL}),
          Plot.geo(coast),
          Plot.geo(countries, {strokeOpacity: 0.2}),
        ]
      }))
    }
    © EuroGeographics for the administrative boundaries
  </div>
  <div class="card"></div>
</div>