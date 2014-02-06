from pandas import read_csv
from pygeocoder import Geocoder
import json


df =  read_csv("citypop.csv")

latitude = []
longitude = []

for a in df.city:
    result = Geocoder.geocode(a)
    latitude.append(result[0].coordinates[0])
    longitude.append(result[0].coordinates[1])

df['latitude'] = latitude
df['longitude'] = longitude

with open("citypop_with_lat_long.json",'w') as outfile:
    json.dump(df.to_json(orient='records'), outfile)

df.to_csv("citypop_with_lat_long.csv")
