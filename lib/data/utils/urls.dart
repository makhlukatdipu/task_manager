class Urls{

  static String baseUrl = 'http://35.73.30.144:2005/api/v1';
  static String registrationUrl = '$baseUrl/Registration';
  static String logInUrl = '$baseUrl/Login';
  static String createTaskUrl = '$baseUrl/createTask';
  static String taskCountUrl = '$baseUrl/taskStatusCount';
  static String getProfileUrl = '$baseUrl/ProfileDetails';
  static String updateProfileUrl = '$baseUrl/ProfileUpdate';
  static String newTaskUrl = '$baseUrl/listTaskByStatus/New';
  static String progressTaskUrl = '$baseUrl/listTaskByStatus/Progress';
  static String completedTaskUrl = '$baseUrl/listTaskByStatus/Complete';
  static String cancelTaskUrl = '$baseUrl/listTaskByStatus/Cancel';
  static String deleteTaskUrl(String id) => '$baseUrl/deleteTask/$id';
  static String changeStatus(String taskId,String status) => '$baseUrl/updateTaskStatus/$taskId/$status';
}