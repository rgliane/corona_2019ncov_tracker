import 'package:corona_2019ncov_tracker/confirmed_screen.dart';
import 'package:corona_2019ncov_tracker/deaths_screen.dart';
import 'package:corona_2019ncov_tracker/recovered_screen.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:corona_2019ncov_tracker/models/attributes_data.dart';
import 'models/attributes.dart';

class DashboardScreen extends StatefulWidget {
  static String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Attributes> myList = new List();

  Future<AttributesData> getAllItems() async {
    AttributesData allData = new AttributesData();

    http.Response response = await http.get(
        'https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=Recovered%3E=0&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Recovered%20desc%2CCountry_Region%20asc%2CProvince_State%20asc&outSR=102100&resultOffset=0&resultRecordCount=250&cacheHint=true');
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

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    childDirected: false, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  @override
  void initState() {
    myBanner
      ..load()
      ..show(
      );
    super.initState();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getAllItems();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Coronavirus 2019-nCoV Global Cases'),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              FutureBuilder<AttributesData>(
                future: getAllItems(),
                builder:
                    (BuildContext context, AsyncSnapshot<AttributesData> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.orange.withAlpha(200),
                              onTap: () {
                                Navigator.pushNamed(context, ConfirmedScreen.id);
                              },
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        'Total Confirmed',
                                        style: TextStyle(fontSize: 40.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Text(
                                        snapshot.data.totalConfirmedCases
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 100, color: Colors.orange),
                                        textAlign: TextAlign.center,
                                      ),

                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text('MORE INFO'),
                                        Icon(Icons.arrow_forward)
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                    SizedBox(height: 5.0,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.green.withAlpha(200),
                              onTap: () {
                                Navigator.pushNamed(context, RecoveredScreen.id);
                              },
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        'Total Recovered',
                                        style: TextStyle(fontSize: 40.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Text(
                                        snapshot.data.totalRecovered.toString(),
                                        style: TextStyle(
                                            fontSize: 100, color: Colors.green),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text('MORE INFO'),
                                        Icon(Icons.arrow_forward)
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                    SizedBox(height: 5.0,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.red.withAlpha(100),
                              onTap: () {
                                Navigator.pushNamed(context, DeathsScreen.id);
                              },
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        'Total Deaths',
                                        style: TextStyle(fontSize: 40.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Text(
                                        snapshot.data.totalDeaths.toString(),
                                        style: TextStyle(
                                            fontSize: 100, color: Colors.red[300]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text('MORE INFO'),
                                        Icon(Icons.arrow_forward)
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                    SizedBox(height: 5.0,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
              SizedBox(height: 100.0,)
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton(
            child: Icon(Icons.refresh),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white70,
            onPressed: () {
              setState(() {
                getAllItems();
              });
            },
          ),
        ),
      ),
    );
  }
}
