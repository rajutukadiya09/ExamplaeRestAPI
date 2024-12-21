class NotificationModel {
  const NotificationModel({
    this.id,
    this.goto,
    this.title,
    this.approvalId,
    this.message,
    this.status,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String?,
      goto: json['goto'] as String?,
      title: json['title'] as String?,
      approvalId: json['approval_id'] as String?,
      message: json['message'] as String?,
      status: json['approval_status'] as String?,
    );
  }

  final String? id;
  final String? goto;
  final String? title;
  final String? approvalId;
  final String? message;
  final String? status;
}
