class ApiResponse {
  Object? data;
  String? error;

  Map<String, List<String>>? errors;

  ApiResponse({this.data, this.error, this.errors});
}
