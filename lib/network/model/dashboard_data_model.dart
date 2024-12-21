import 'dart:ffi';

class DashboardDataModel {
  // List of DashboardDataModelRes objects representing the data entries
  List<DashboardDataModelRes>? data;

  // Count of the data entries
  int? count;

  // Constructor for initializing with optional data and count
  DashboardDataModel({this.data, this.count});

  // Factory constructor for creating an instance from JSON
  DashboardDataModel.fromJson(Map<String, dynamic> json) {
    // Check if 'data' key exists and is not null
    if (json['data'] != null) {
      // Initialize data list and parse each entry into DashboardDataModelRes objects
      data = <DashboardDataModelRes>[];
      json['data'].forEach((v) {
        data!.add(DashboardDataModelRes.fromJson(v));
      });
    }
    // Set the count value if available
    count = json['count'];
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // Convert each DashboardDataModelRes object in the data list to JSON
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    // Add count to the JSON map
    data['count'] = count;
    return data;
  }
}

class DashboardDataModelRes {
  // ID of the data entry
  int? id;

  String? name;

  bool isstarred=false;

  String? password;

  String? path;

  String? par_path;

  var fileSize;

  var aTime;

  var cTime;

  var dir;

  var mTime;

  var time;

  // List of Lines objects associated with this entry
  List<Lines>? lines;

  // Constructor for initializing with optional id, name, and lines
  DashboardDataModelRes({this.id,
    this.name,
    this.lines,
    this.dir,
    this.password,
    this.time,
    this.mTime,
    this.cTime,
    this.aTime,
    this.fileSize,
    this.par_path,
    this.path,
  });

  // Factory constructor for creating an instance from JSON
  DashboardDataModelRes.fromJson(Map<String, dynamic> json) {
    // Set id and name values if available
    id = json['id'];
    name = json['name'];
    dir = json['dir'];
    password = json['password'];
    time = json['time'];
    mTime = json['mTime'];
    cTime = json['cTime'];
    aTime = json['aTime'];
    fileSize = json['fileSize'];
    par_path = json['par_path'];
    path = json['path'];

    isstarred=false;
    // Check if 'lines' key exists and is not null
    if (json['lines'] != null) {
      // Initialize lines list and parse each entry into Lines objects
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines!.add(Lines.fromJson(v));
      });
    }
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // Add id and name to the JSON map
    data['id'] = id;
    data['name'] = name;
    data['dir'] = dir;
    data['isstarred'] = isstarred;
    data['password'] = password;
    data['time'] = time;
    data['mTime'] = mTime;
    data['cTime'] = cTime;
    data['cTime'] = cTime;
    data['aTime'] = aTime;
    data['fileSize'] = fileSize;
    data['par_path'] = par_path;
    data['path'] = path;
    // Convert each Lines object in the lines list to JSON
    if (lines != null) {
      data['lines'] = lines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lines {
  // Name of the line
  String? used_percent;

  // Icon associated with the line
  LongLong? used;

  // URL associated with the line
  LongLong? free;

  // Constructor for initializing with optional name, icon, and url
  Lines({this.used_percent, this.used, this.free});

  // Factory constructor for creating an instance from JSON
  Lines.fromJson(Map<String, dynamic> json) {
    // Set name, icon, and url values if available
    used_percent = json['used_percent'];
    used = json['used'];
    free = json['free'];
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // Add name, icon, and url to the JSON map
    data['used_percent'] = used_percent;
    data['used'] = used;
    data['free'] = free;
    return data;
  }
}

class Root {
  String? name;
  String? path;
  String? parPath;
  int? driveSize;
  int? used;
  int? free;
  String? usedPercent;

  Root({
    this.name,
    this.path,
    this.parPath,
    this.driveSize,
    this.used,
    this.free,
    this.usedPercent,
  });

  // Factory constructor to create a Root object from JSON
  factory Root.fromJson(Map<String, dynamic> json) {
    return Root(
      name: json['name'],
      path: json['path'],
      parPath: json['par_path'],
      driveSize: json['driveSize'],
      used: json['used'],
      free: json['free'],
      usedPercent: json['used_percent'],
    );
  }

  // Method to convert Root object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'par_path': parPath,
      'driveSize': driveSize,
      'used': used,
      'free': free,
      'used_percent': usedPercent,
    };
  }
  // Convert 'used' from bytes to gigabytes (GB)
  String get usedInGB {
    if (used != null) {
      return (used! / 1024 / 1024 / 1024).toStringAsFixed(3).toString(); // Divide by 1024^3 to convert bytes to GB
    }
    return "0.0";
  }
  // Convert 'used' from bytes to gigabytes (GB)
  String get freeInGB {
    if (free != null) {
      return (free! / 1024 / 1024 / 1024).toStringAsFixed(3).toString(); // Divide by 1024^3 to convert bytes to GB
    }
    return "0.0";
  }
  // Convert 'used' from bytes to gigabytes (GB)
  double get usedGB {
    if (used != null) {
      return (used! / 1024 / 1024 / 1024); // Divide by 1024^3 to convert bytes to GB
    }
    return 0.0;
  }
  // Convert 'used' from bytes to gigabytes (GB)
  double get freeGB {
    if (free != null) {
      return (free! / 1024 / 1024 / 1024); // Divide by 1024^3 to convert bytes to GB
    }

    return 0.0;
  }
}
