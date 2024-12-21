class TowVehicles {
  List<TowVehiclesModel>? data;
  int? count;

  TowVehicles({this.data, this.count});

  TowVehicles.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TowVehiclesModel>[];
      json['data'].forEach((v) {
        data!.add(new TowVehiclesModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class TowVehiclesModel {
  int? id;
  String? name;
  String? licensePlate;
  double? latitude;
  double? longitude;
  String? driverName;
  double? odometer;

  TowVehiclesModel(
      {this.id,
        this.name,
        this.licensePlate,
        this.latitude,
        this.longitude,
        this.driverName,
        this.odometer});

  TowVehiclesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licensePlate = json['license_plate'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    driverName = json['driver_name'];
    odometer = json['odometer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['license_plate'] = this.licensePlate;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['driver_name'] = this.driverName;
    data['odometer'] = this.odometer;
    return data;
  }
}

class TowVehicleClassModel {
  String? type;
  String? name;

  TowVehicleClassModel({this.type, this.name});

  TowVehicleClassModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}

class TowFacilitiesFetch {
  List<TowFacilitiesFetchModel>? data;
  int? count;

  TowFacilitiesFetch({this.data, this.count});

  TowFacilitiesFetch.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TowFacilitiesFetchModel>[];
      json['data'].forEach((v) {
        data!.add(new TowFacilitiesFetchModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class TowFacilitiesFetchModel {
  int? id;
  String? name;

  TowFacilitiesFetchModel({this.id, this.name});

  TowFacilitiesFetchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}


