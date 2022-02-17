import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:github_repositories_list/connectivity/connectivity_controller.dart';
import 'package:github_repositories_list/github/model/model_github_repo.dart';
import 'package:github_repositories_list/github/vm/github_list_contoller.dart';
import 'package:github_repositories_list/utils/loading_shimmer.dart';
import 'package:github_repositories_list/utils/ui_helper.dart';

class GithubRepoList extends StatefulWidget {
  const GithubRepoList({Key? key}) : super(key: key);

  @override
  _GithubRepoListState createState() => _GithubRepoListState();
}

class _GithubRepoListState extends State<GithubRepoList> {
  late final GithubListController _controller;
  final ScrollController _scrollController = ScrollController();
  late ConnectivityController _connectivityController;
  @override
  void initState() {
    _connectivityController = Get.find<ConnectivityController>();
    _controller = Get.put(GithubListController());
    // TODO: implement initState
    _dataCall();
    super.initState();
  }

  void callApi() {
    _controller.getRepoList();
  }

  void getLocalData() {
    _controller.getRepoListSQLLite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jake's Git"),
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return Obx(() {
      switch (_controller.widgetState.value) {
        case WIDGET_STATE.error:
          return const Center(
            child: Text(
              'Internal Server Error',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          );

        case WIDGET_STATE.view:
        case WIDGET_STATE.paginationLoading:
          return _getListView();
        case WIDGET_STATE.fullLoading:
        default:
          return SingleChildScrollView(
            child: Column(
              children: const [
                LoadingShimmer(),
                LoadingShimmer(),
                LoadingShimmer(),
                LoadingShimmer(),
                LoadingShimmer(),
                LoadingShimmer(),
              ],
            ),
          );
      }
    });
  }

  _getListView() {
    return Obx(() {
      if (_controller.repoList.isEmpty) {
        return const Center(
          child: Text(
            'No Data Available',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        );
      } else {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return _getListItem(_controller.repoList[i]);
                },
                itemCount: _controller.repoList.length,
              ),
            ),
            if (_controller.widgetState.value == WIDGET_STATE.paginationLoading)
              const LoadingShimmer()
          ],
        );
      }
    });
  }

  _getListItem(ModelGithubRepo item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.book, size: 60),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (item.language != '')
                          const Expanded(child: Icon(Icons.code)),
                        if (item.language != '')
                          Expanded(
                              flex: 2,
                              child: Text(
                                item.language,
                                style: TextStyle(color: Colors.grey[600]),
                              )),
                        const Expanded(child: Icon(Icons.bug_report)),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.openIssues.toString(),
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                        const Expanded(child: Icon(Icons.face)),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.watchers.toString(),
                              style: TextStyle(color: Colors.grey[600]),
                            ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(thickness: 2)
      ],
    );
  }

  void _dataCall() async {
    if (_connectivityController.isConnected.value) {
      callApi();
    } else {
      getLocalData();
    }

    // lazy loading (pagination scroll api calling)
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_connectivityController.isConnected.value) {
            callApi();
          } else {
            getLocalData();
          } //called in normal case
        }
      },
    );
    _connectivityController.isConnected.listen((value) {
      if (value) {
        callApi();
      } else {
        showSnackBar('Connect internet to get updated records');
        getLocalData();
      }
    });
  }
}
