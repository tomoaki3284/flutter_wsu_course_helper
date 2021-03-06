class Hours {

  final int startHour, startMinute, endHour, endMinute;
  String militaryTime;

  Hours({this.startHour, this.startMinute, this.endHour, this.endMinute});

  factory Hours.fromJson(Map<String, dynamic> json) {
    return Hours(
      startHour: json["startHour"],
      startMinute: json["startMinute"],
      endHour: json["endHour"],
      endMinute: json["endMinute"],
    );
  }

  factory Hours.fromDatabase(Map<dynamic, dynamic> data) {
    return Hours(
      startHour: data["startHours"],
      startMinute: data["startMinute"],
      endHour: data["endHours"],
      endMinute: data["endMinute"],
    );
  }

  Map<String, dynamic> toJson() => {
        'startHours': startHour,
        'startMinute': startMinute,
        'endHours': endHour,
        'endMinute': endMinute,
      };

  Map<dynamic, dynamic> getDataMap() {
    return {
      'startHours': startHour,
      'startMinute': startMinute,
      'endHours': endHour,
      'endMinute': endMinute,
    };
  }

  /// Get the interval from of open hours
  ///
  /// @return the interval form of int[] {startHour*60 + startMin, endHour*60 + endMin}
  /// which is equivalent of int[] {starting hour in minute, ending hour in minute}
  List<int> getInIntervalForm() {
    List<int> result = [];
    result.add(startHour * 60 + startMinute);
    result.add(endHour * 60 + endMinute);
    return result;
  }

  double getHourLength() {
    if (startMinute > endMinute) {
      return endHour - startHour - 1.0;
    } else {
      return endHour - startHour + 0.0;
    }
  }

  double getMinuteLength() {
    if (startMinute == endMinute) {
      return 0.0;
    }

    // if within same hour
    if (endHour - startHour == 0) {
      return endMinute - startMinute + 0.0;
    } else {
      if (startMinute > endMinute) {
        int gap = 60 - startMinute;
        return endMinute + gap + 0.0;
      }
      return endMinute - startMinute + 0.0;
    }
  }

  double getInHourFloatFormat() {
    double res = getHourLength() / 1.0 + getMinuteLength() / 60.0;
    return res;
  }

  String getMilitaryTime() {
    if (militaryTime != null) {
      return militaryTime;
    }

    // start military hour
    String sMilHour = "";
    String sMilMin = "";
    String eMilHour = "";
    String eMilMin = "";

    if (startHour < 10) {
      sMilHour = "0$startHour";
    } else {
      sMilHour = "$startHour";
    }
    if (startMinute < 10) {
      sMilMin = "0$startMinute";
    } else {
      sMilMin = "$startMinute";
    }

    if (endHour < 10) {
      eMilHour = "0$endHour";
    } else {
      eMilHour = "$endHour";
    }
    if (endMinute < 10) {
      eMilMin = "0$endMinute";
    } else {
      eMilMin = "$endMinute";
    }

    militaryTime = "$sMilHour:$sMilMin-$eMilHour:$eMilMin";
    return militaryTime;
  }

  @override
  String toString() {
    return getMilitaryTime();
  }
}