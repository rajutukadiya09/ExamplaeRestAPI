/// A data model class representing a database list item
class DbListModel {
  /// The name of the database
  String dbname;

  /// Constructor for creating a DbListModel object
  DbListModel({
    required this.dbname,
  });

  /// Factory method for creating a DbListModel instance from a JSON map
  factory DbListModel.fromJson(Map<String, dynamic> json) => DbListModel(
        dbname: json["dbname"],
      );

  /// Method for converting a DbListModel instance into a JSON map
  Map<String, dynamic> toJson() => {
        "dbname": dbname,
      };
}
