class Attributes{

   int objectId;
   String provinceState;
   String countryRegion;
   int lastUpdate;
   double latitude;
   double longitude;
   int confirmed;
   int deaths;
   int recovered;

  Attributes({this.objectId, this.provinceState, this.countryRegion, this.lastUpdate, this.latitude, this.longitude, this.confirmed, this.deaths, this.recovered});

  void printStuff() {
     print(this.objectId);
     print(this.provinceState);
     print(this.countryRegion);
     print(this.lastUpdate);
     print(this.latitude);
     print(this.longitude);
     print(this.confirmed);
     print(this.deaths);
     print(this.recovered);
  }

}