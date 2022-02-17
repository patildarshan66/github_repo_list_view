import 'package:get/get.dart';
import 'package:github_repositories_list/github/model/model_github_repo.dart';
import 'package:github_repositories_list/https/http_methods.dart';
import 'package:github_repositories_list/sqlLite/sql_lite_db_manager.dart';
import 'package:github_repositories_list/utils/ui_helper.dart';

enum WIDGET_STATE { fullLoading, error, view, paginationLoading }

class GithubListController extends GetxController {
  RxList<ModelGithubRepo> repoList = <ModelGithubRepo>[].obs;

  Rx<WIDGET_STATE> widgetState = WIDGET_STATE.fullLoading.obs;
  bool isEmptyResSQl = false;
  bool isEmptyRes = false;
  int perPage = 15;
  int page = 1;
  int offset = 0;

  Future<void> getRepoList() async {
    try {
      if (isEmptyRes) {
        showSnackBar('Not more data available.');
        return;
      }
      final url =
          "https://api.github.com/users/JakeWharton/repos?page=$page&per_page=$perPage";
      if (page != 1) {
        widgetState.value = WIDGET_STATE.paginationLoading;
      } else {
        offset = 0;
        repoList.value = [];
        widgetState.value = WIDGET_STATE.fullLoading;
      }
      final res = await HttpMethods.getRequest(url);
      final ls = modelGithubRepoFromMap(res);
      if (ls.isNotEmpty) {
        repoList.addAll(ls);
        page += 1;
        SqlLiteDBManager.insertRecords(ls);
        isEmptyResSQl = false;
      } else {
        isEmptyRes = true;
        showSnackBar('Not more data available.');
      }
      widgetState.value = WIDGET_STATE.view;
    } catch (e) {
      if (page == 1) {
        widgetState.value = WIDGET_STATE.error;
      }
      showSnackBar(e.toString());
    }
  }

  Future<void> getRepoListSQLLite() async {
    try {
      if (isEmptyResSQl) {
        showSnackBar('Not more data available.');
        return;
      }
      if (offset != 0) {
        widgetState.value = WIDGET_STATE.paginationLoading;
      } else {
        page = 0;
        repoList.value = [];
        isEmptyRes = false;
        widgetState.value = WIDGET_STATE.fullLoading;
        Future.delayed(const Duration(seconds: 1)).then(
            (value) => showSnackBar('Connect internet to get updated records'));
      }
      final ls = await SqlLiteDBManager.getRecords(offset);
      if (ls.isNotEmpty) {
        repoList.addAll(ls);
        offset += 15;
      } else {
        isEmptyResSQl = true;
        if (offset == 0) {
          Future.delayed(const Duration(seconds: 2)).then((value) =>
              showSnackBar('No internet. Please connect to internet.'));
        } else {
          showSnackBar('Not more data available.');
        }
      }
      widgetState.value = WIDGET_STATE.view;
    } catch (e) {
      if (page == 1) {
        widgetState.value = WIDGET_STATE.error;
      }
      showSnackBar(e.toString());
    }
  }
}
