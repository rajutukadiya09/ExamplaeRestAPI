class TowDrivers {
  List<TowDriversModel>? data;
  int? count;

  TowDrivers({this.data, this.count});

  TowDrivers.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TowDriversModel>[];
      json['data'].forEach((v) {
        data!.add(new TowDriversModel.fromJson(v));
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

class TowDriversModel {
  int? id;
  String? name;
  String? street;
  String? city;
  String? stateName;
  String? zip;
  String? phone;
  String? email;

  TowDriversModel(
      {this.id,
        this.name,
        this.street,
        this.city,
        this.stateName,
        this.zip,
        this.phone,
        this.email});

  TowDriversModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    street = json['street'];
    city = json['city'];
    stateName = json['state_name'];
    zip = json['zip'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state_name'] = this.stateName;
    data['zip'] = this.zip;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}
