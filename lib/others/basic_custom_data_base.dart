class User {
  late String pass, name, dept, university;
  late double present;
  late int year, semester;
  late bool admin;
  User() {
    name = "No_name";
    dept = university = "N/A";
    present = 0.7;
    admin = true;
    semester = year = 0;
  }
}

class Note {
  late String documentName, documentLink, dept, university;
  late int year, semester;
  late bool adminAccept;
  Note() {
    adminAccept = false;
  }
}
