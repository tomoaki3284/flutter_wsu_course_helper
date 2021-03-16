class Review {
  String courseCode;
  double rate;
  double difficulty;
  DateTime date;
  bool usedTextbook;
  bool attendance;
  double grade;
  List<String> tags;
  String review;

  Review(
      {this.courseCode,
      this.rate,
      this.difficulty,
      this.date,
      this.usedTextbook,
      this.attendance,
      this.grade,
      this.tags,
      this.review});
}
