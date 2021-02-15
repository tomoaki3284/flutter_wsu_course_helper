class Hours {

  final int startHours, startMinute, endHour, endMinute;
  String militaryTime;
  String hoursString;

  Hours({this.startHours, this.startMinute, this.endHour, this.endMinute});

  factory Hours.fromJson(Map<String, dynamic> json) {
    return Hours(
      startHours: json["startHour"],
      startMinute: json["startMinute"],
      endHour: json["endHour"],
      endMinute: json["endMinute"],
    );
  }

  /// Get the interval from of open hours
  ///
  /// @return the interval form of int[] {startHour*60 + startMin, endHour*60 + endMin}
  List<int> getInIntervalForm() {
    List<int> result = new List();
    result.add(startHours*60 + startMinute);
    result.add(endHour*60 + endMinute);
    return result;
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

    if (startHours < 10) {
      sMilHour = "0$startHours";
    } else {
      sMilHour = "$startHours";
    }
    if (startHours < 10) {
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