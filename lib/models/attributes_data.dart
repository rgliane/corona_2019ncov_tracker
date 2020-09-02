import 'attributes.dart';

class AttributesData {
  List<Attributes> _list = [];

  int get attributesCount {
    return _list.length;
  }

  void addAttribute(Attributes att){
    _list.add(att);
  }

  List<Attributes> get getAttributes {
    return _list;
  }

  List<Attributes> get getDeathsList {
    List<Attributes> _listDeaths = [];
    for(int i = 0; i < getAttributes.length; i++) {
      if (getAttributes[i].deaths > 0) {
        getAttributes.add(_list[i]);
      }
    }
    return _listDeaths;
  }

  List<Attributes> get getRecoveredList {
    List<Attributes> _listRecovered = [];
    for(int i = 0; i < getAttributes.length; i++) {
      if(getAttributes[i].recovered > 0) {
        getAttributes.add(_list[i]);
      }
    }
    return _listRecovered;
  }

  int get totalConfirmedCases {
    int total = 0;
    for(int i = 0; i < getAttributes.length; i++){
      total += getAttributes[i].confirmed;
    }
    return total;
  }

  int get totalDeaths {
    int total = 0;
    for(int i = 0; i < getAttributes.length; i++){
      total += getAttributes[i].deaths;
    }
    return total;
  }

  int get totalRecovered {
    int total = 0;
    for(int i = 0; i < getAttributes.length; i++){
      total += getAttributes[i].recovered;
    }
    return total;
  }

}