class ReportModel {
  String problemSource;
  String location;
  String selectedProblems;
  String comments;
  String problemUID;
  String reportStatus;
  String senderName;
  String senderEmail;
  String senderPhoneNumber;
  String senderStatus;
  String dateSubmitted;

  ReportModel({
    required this.problemSource,
    required this.location,
    required this.selectedProblems,
    required this.comments,
    required this.problemUID,
    required this.reportStatus,
    required this.senderName,
    required this.senderEmail,
    required this.senderPhoneNumber,
    required this.senderStatus,
    required this.dateSubmitted
  });

  Map<String, String> getModelData() {
    return {
      "problem_date_submitted" : dateSubmitted,
      "problem_status" : reportStatus,
      "problem_source" : problemSource,
      "problem_location" : location,
      "problem_selected_problems" : selectedProblems,
      "problem_comments" : comments,
      "problem_problem_uid" : problemUID,
      "problem_sender_name" : senderName,
      "problem_sender_email" : senderEmail,
      "problem_sender_phone_number" : senderPhoneNumber,
      "problem_sender_status" : senderStatus,
    };
  }

  factory ReportModel.fromFirestore(Map<String, dynamic> data) {
    return ReportModel(
      dateSubmitted: data["problem_date_submitted"],
      problemSource: data["problem_source"],
      location: data["problem_location"],
      selectedProblems: data["problem_selected_problems"],
      comments: data["problem_comments"],
      problemUID: data["problem_problem_uid"],
      reportStatus: data["problem_status"],
      senderName: data["problem_sender_name"],
      senderEmail: data["problem_sender_email"],
      senderPhoneNumber: data["problem_sender_phone_number"],
      senderStatus: data["problem_sender_status"],
    );
  }
}