import 'package:flutter/material.dart';
import 'package:corona_2019ncov_tracker/models/attributes_data.dart';
import 'models/attributes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmedScreen extends StatefulWidget {
  static String id = 'confirmed_screen';

  @override
  _ConfirmedScreenState createState() => _ConfirmedScreenState();
}

class _ConfirmedScreenState extends State<ConfirmedScreen> {
  List<Attributes> myList = new List();

  Future<AttributesData> getAllItems() async {
    AttributesData allData = new AttributesData();

    http.Response response = await http.get(
        'https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=Recovered%3E=0&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Confirmed%20desc%2CCountry_Region%20asc%2CProvince_State%20asc&outSR=102100&resultOffset=0&resultRecordCount=250&cacheHint=true');
    if (response.statusCode == 200) {
      String data = response.body;

      Map<String, dynamic> myMap = json.decode(data);
      List<dynamic> attributes = myMap['features'];

      attributes.forEach((attribute) {
        Attributes tempAtt = new Attributes();
        (attribute as Map<String, dynamic>).forEach((key, value) {
          (value as Map<String, dynamic>).forEach((key2, value2) {
            //populate each property of the class
            if (key2 == 'OBJECTID') {
              tempAtt.objectId = value2;
            } else if (key2 == 'Province_State') {
              if (value2 != null) {
                tempAtt.provinceState = value2;
              } else {
                tempAtt.provinceState = 'None';
              }
            } else if (key2 == 'Country_Region') {
              tempAtt.countryRegion = value2;
            } else if (key2 == 'Last_Update') {
              tempAtt.lastUpdate = value2;
            } else if (key2 == 'Lat') {
              tempAtt.latitude = value2.toDouble();
            } else if (key2 == 'Long_') {
              tempAtt.longitude = value2.toDouble();
            } else if (key2 == 'Confirmed') {
              tempAtt.confirmed = value2;
            } else if (key2 == 'Deaths') {
              tempAtt.deaths = value2;
            } else if (key2 == 'Recovered') {
              tempAtt.recovered = value2;
            }
          });
        });
        allData.addAttribute(tempAtt);
      });
    }
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Confirmed Breakdown'),
        ),
        body: Container(
          child: FutureBuilder(
            future: getAllItems(),
            builder:
                (BuildContext context, AsyncSnapshot<AttributesData> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  snapshot.data.totalConfirmedCases.toString() +
                                      ' - Total Confirmed Cases',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                subtitle: Text(
                                    'Confirmed Cases breakdown by Country, State/Province'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        child: Flexible(
                      child: ListView.builder(
                        itemCount: snapshot.data.getAttributes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  snapshot.data.getAttributes[index].confirmed
                                          .toString() +
                                      ' - ' +
                                      snapshot.data.getAttributes[index]
                                          .countryRegion +
                                      ', ' +
                                      snapshot.data.getAttributes[index]
                                          .provinceState,
                                  style: TextStyle(fontSize: 19.0),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Loading...',
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        bottomNavigationBar: SizedBox(height: 100.0,),
      ),
    );
  }
}
