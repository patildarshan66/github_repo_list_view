import 'package:flutter/material.dart';
import 'package:github_repositories_list/biometric/view/biometric_login_view.dart';
import 'package:github_repositories_list/github/view/github_list_repo.dart';
import 'package:github_repositories_list/routes/screen_arguments.dart';
import 'package:page_transition/page_transition.dart';
import 'my_routes_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var name = settings.name;
    final args = settings.arguments;
    // var arg = args as ScreenArguments;
    switch (name) {
      case MyRoutes.githubRepoList:
        return PageTransition(
          settings: settings,
          type: PageTransitionType.rightToLeft,
          child: const GithubRepoList(),
        );
      case MyRoutes.initialRoute:
      case MyRoutes.biometricLogin:
      default:
        return PageTransition(
          settings: settings,
          type: PageTransitionType.rightToLeft,
          child: const BiometricLogin(),
        );
    }
  }
}
