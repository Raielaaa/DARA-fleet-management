class ReportModel {
  String problemSource;
  String location;
  String selectedProblems;
  String comments;
  String problemUID;

  ReportModel({
    required this.problemSource,
    required this.location,
    required this.selectedProblems,
    required this.comments,
    required this.problemUID
  });

  Map<String, String> getModelData() {
    return {
      "problem_source" : problemSource,
      "problem_location" : location,
      "problem_selected_problems" : selectedProblems,
      "problem_comments" : comments,
      "problem_problem_uid" : problemUID
    };
  }
}