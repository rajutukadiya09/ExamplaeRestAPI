class UploadImgModel {
  int? attachmentId;

  UploadImgModel({this.attachmentId});

  // Constructs an UploadImgModel object from a JSON map.
  UploadImgModel.fromJson(Map<String, dynamic> json) {
    attachmentId = json['attachment_id'];
  }

  // Converts an UploadImgModel object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachment_id'] = this.attachmentId;
    return data;
  }
}
