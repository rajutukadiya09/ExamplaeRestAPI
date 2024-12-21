class TowServices {
  List<TowServicesModel>? data;
  int? count;

  TowServices({this.data, this.count});

  TowServices.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TowServicesModel>[];
      json['data'].forEach((v) {
        data!.add(new TowServicesModel.fromJson(v));
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

class TowServicesModel {
  int? id;
  String? name;
  String? rateType;
  String? towingCompany;
  double? lightDutyHours;
  double? mediumDutyHours;
  double? heavyDutyHours;
  double? specialtyDutyHours;

  TowServicesModel(
      {this.id,
        this.name,
        this.rateType,
        this.towingCompany,
        this.lightDutyHours,
        this.mediumDutyHours,
        this.heavyDutyHours,
        this.specialtyDutyHours});

  TowServicesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rateType = json['rate_type'];
    towingCompany = json['towing_company'];
    lightDutyHours = json['light_duty_hours'];
    mediumDutyHours = json['medium_duty_hours'];
    heavyDutyHours = json['heavy_duty_hours'];
    specialtyDutyHours = json['specialty_duty_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rate_type'] = this.rateType;
    data['towing_company'] = this.towingCompany;
    data['light_duty_hours'] = this.lightDutyHours;
    data['medium_duty_hours'] = this.mediumDutyHours;
    data['heavy_duty_hours'] = this.heavyDutyHours;
    data['specialty_duty_hours'] = this.specialtyDutyHours;
    return data;
  }
}

class TowMethod {
  List<TowMethodModel>? data;
  int? count;

  TowMethod({this.data, this.count});

  TowMethod.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TowMethodModel>[];
      json['data'].forEach((v) {
        data!.add(new TowMethodModel.fromJson(v));
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

class TowMethodModel {
  int? id;
  String? name;

  TowMethodModel({this.id, this.name});

  TowMethodModel.fromJson(Map<String, dynamic> json) {
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

