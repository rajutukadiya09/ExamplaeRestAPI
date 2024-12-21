class TowAccount {
  List<TowAccountFetchModel>? data;
  int? count;

  TowAccount({this.data, this.count});

  // Converts a JSON map into a TowAccount instance.
  TowAccount.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TowAccountFetchModel>[];
      json['data'].forEach((v) {
        data!.add(TowAccountFetchModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  // Converts the TowAccount instance into a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class TowAccountFetchModel {
  int? id;
  String? name;
  String? accountStatus;
  String? email;
  String? phone;
  String? propertyType;
  String? street;
  String? city;
  String? zip;
  double? latitude;
  double? longitude;

  TowAccountFetchModel(
      {this.id,
      this.name,
      this.accountStatus,
      this.email,
      this.phone,
      this.propertyType,
      this.street,
      this.city,
      this.zip,
      this.latitude,
      this.longitude});

  // Converts a JSON map into a TowAccountFetchModel instance.
  TowAccountFetchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountStatus = json['account_status'];
    email = json['email'];
    phone = json['phone'];
    propertyType = json['property_type'];
    street = json['street'];
    city = json['city'];
    zip = json['zip'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  // Converts the TowAccountFetchModel instance into a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['account_status'] = accountStatus;
    data['email'] = email;
    data['phone'] = phone;
    data['property_type'] = propertyType;
    data['street'] = street;
    data['city'] = city;
    data['zip'] = zip;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
