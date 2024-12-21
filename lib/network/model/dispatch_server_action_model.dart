class DispatchServerActionModel {
  String? name;
  int? id;
  String? bindingModel;

  DispatchServerActionModel({this.name, this.id, this.bindingModel});

  DispatchServerActionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    bindingModel = json['binding_model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['binding_model'] = this.bindingModel;
    return data;
  }
}
