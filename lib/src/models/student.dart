class Student {
  String studentId;
  String firstName;
  String lastName;
  bool isAttended;

  Student({
    required this.studentId,
    me,
    required this.firstName,
    required this.lastName,
    required this.isAttended,
  });

  Student.fromJson(Map<String, dynamic> json)
      : studentId = json['email'],
        firstName = json['name'],
        lastName = json['surname'],
        isAttended = true;

  Map<String, dynamic>? toJson() => {
        'studentId': studentId,
        'studentName': firstName,
        'studentSurname': lastName,
        'isAttended': isAttended,
      };
}
