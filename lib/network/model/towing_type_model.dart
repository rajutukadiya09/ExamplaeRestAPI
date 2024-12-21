class TowingTypeModel {
  String? type;
  String? name;

  TowingTypeModel({this.type, this.name});

  // Constructs a TowingTypeModel object from a JSON map.
  TowingTypeModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
  }

  // Converts a TowingTypeModel object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}
