import 'package:meta/meta.dart';
import 'dart:convert';

List<ModelGithubRepo> modelGithubRepoFromMap(var str) =>
    List<ModelGithubRepo>.from(str.map((x) => ModelGithubRepo.fromMap(x)));

String modelGithubRepoToMap(ModelGithubRepo data) => json.encode(data.toMap());

class ModelGithubRepo {
  ModelGithubRepo({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    required this.openIssues,
    required this.watchers,
    required this.language,
  });

  final int id;
  final String name;
  final String fullName;
  final String description;
  final int openIssues;
  final String language;
  final int watchers;

  factory ModelGithubRepo.fromMap(Map<String, dynamic> json) => ModelGithubRepo(
        id: json["id"],
        name: json["name"],
        fullName: json["full_name"] ?? json["fullName"],
        description: json["description"] ?? '',
        openIssues: json["open_issues"] == null || json["open_issues"] == ''
            ? json["openIssues"] ?? 0
            : json["open_issues"],
        watchers: json["watchers"] == null || json["watchers"] == ''
            ? 0
            : json["watchers"],
        language: json["language"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "fullName": fullName,
        "description": description,
        "openIssues": openIssues,
        "watchers": watchers,
        "language": language,
      };
}
