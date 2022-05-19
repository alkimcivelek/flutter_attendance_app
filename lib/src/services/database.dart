import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:yoklama_sistemi/src/helpers/functions.dart';
import 'package:yoklama_sistemi/src/models/student.dart';

class DatabaseMethods {
  Future<void> saveGeneratedCode(String code) async {
    var email = FirebaseAuth.instance.currentUser!.email;
    var teacherDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    var courseName = await teacherDoc.docs[0].get("courseName");
    var studyToGeneratedCode = await FirebaseFirestore.instance
        .collection("studies")
        .where("name", isEqualTo: courseName)
        .get();
    var id = studyToGeneratedCode.docs[0].id;
    await FirebaseFirestore.instance
        .collection("studies")
        .doc(id)
        .update({"code": code});
  }

  Future<void> updateCountDownTimer(int time) async {
    var email = FirebaseAuth.instance.currentUser!.email;
    var teacherDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    var courseName = await teacherDoc.docs[0].get("courseName");
    var studyToGeneratedCode = await FirebaseFirestore.instance
        .collection("studies")
        .where("name", isEqualTo: courseName)
        .get();
    var id = studyToGeneratedCode.docs[0].id;
    await FirebaseFirestore.instance
        .collection("studies")
        .doc(id)
        .update({"time": time});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCode() async {
    String code = "";
    var email = FirebaseAuth.instance.currentUser!.email;
    var teacherDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    var courseName = await teacherDoc.docs[0].get("courseName");
    var studyToGeneratedCode = await FirebaseFirestore.instance
        .collection("studies")
        .where("name", isEqualTo: courseName)
        .get();
    var id = await studyToGeneratedCode.docs[0].id;

    return await FirebaseFirestore.instance.collection("studies").doc(id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassTime() async {
    return await FirebaseFirestore.instance
        .collection("studies")
        .where("code", isNotEqualTo: "")
        .get();
  }

  Future<void> updateCode() async {
    var email = FirebaseAuth.instance.currentUser!.email;
    var teacherDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    var courseName = await teacherDoc.docs[0].get("courseName");
    var studyToGeneratedCode = await FirebaseFirestore.instance
        .collection("studies")
        .where("name", isEqualTo: courseName)
        .get();
    var id = studyToGeneratedCode.docs[0].id;
    await FirebaseFirestore.instance
        .collection("studies")
        .doc(id)
        .update({"code": ""});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserInfo(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future takeAttendance(String className) async {
    Student? student;
    String? id;
    CollectionReference attendance =
        FirebaseFirestore.instance.collection('attendances');
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: await HelperFunctions.getUserEmail())
        .get()
        .then((value) {
      id = value.docs[0].id;
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(id!)
        .get()
        .then((value) async {
      student = Student.fromJson(value.data()!);
    });

    // await FirebaseFirestore.instance
    //     .collection("students")
    //     .doc(id!)
    //     .set(student!.toJson()!);

    await attendance.add({
      'studentId': student!.studentId,
      'className': className,
      'date': getClassDate(),
      'isAttended': student!.isAttended,
      'studentName': student!.firstName,
      'studentSurname': student!.lastName,
    });
  }

  String getClassDate() {
    return DateTime.now().day.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();
  }

  Future<Student> getStudent() async {
    Student? student;
    String? id;
    CollectionReference attendance =
        FirebaseFirestore.instance.collection('attendances');
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: await HelperFunctions.getUserEmail())
        .get()
        .then((value) {
      id = value.docs[0].id;
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(id!)
        .get()
        .then((value) async {
      student = Student.fromJson(value.data()!);
    });

    return student!;
  }

  Future<bool> getClassNameOnSpecificDate(String date, String classname) async {
    var isTrue = false;

    await FirebaseFirestore.instance
        .collection("attendances")
        .where("date", isEqualTo: date)
        .where("className", isEqualTo: classname)
        .where("studentId",
            isEqualTo: await getStudent().then((value) {
              return value.studentId;
            }))
        .get()
        .then((value) {
      isTrue = value.size > 0 ? true : false;
    });

    return isTrue;
  }

  Future getHomepageCards() async {
    return await FirebaseFirestore.instance
        .collection("cards")
        .get()
        .then((value) => debugPrint("Card değeri: " + value.toString()));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudies() async {
    return await FirebaseFirestore.instance.collection("studies").get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudy(
      String day, int hour) async {
    return await FirebaseFirestore.instance
        .collection("studies")
        .where("day", isEqualTo: day)
        .where("startHour", isLessThanOrEqualTo: hour)
        .get();
  }
}
