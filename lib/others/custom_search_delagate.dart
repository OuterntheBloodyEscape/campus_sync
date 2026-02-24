import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_pair.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomSearchDelagate extends SearchDelegate {
  final List<Pair<String, String>> si;
  CustomSearchDelagate({required this.si});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new, size: 20),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Pair<String, String>> matchQuary = [];
    for (Pair<String, String> f in si) {
      if (f.first.toLowerCase().contains(query.toLowerCase())) {
        matchQuary.add(f);
      }
    }
    return ListView.separated(
      itemCount: matchQuary.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.link, color: Colors.grey),
          title: Text(
            matchQuary[index].first,
            style: TextStyle(color: Colors.black),
          ),
          style: ListTileStyle.list,
          subtitle: Text(matchQuary[index].second),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 20, thickness: 2);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Pair<String, String>> matchQuary = [];
    for (Pair<String, String> f in si) {
      if (f.first.toLowerCase().contains(query.toLowerCase())) {
        matchQuary.add(f);
      }
    }
    return ListView.separated(
      itemCount: matchQuary.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.link, color: Colors.grey),
          title: Text(
            matchQuary[index].first,
            style: TextStyle(color: Colors.black),
          ),
          style: ListTileStyle.list,
          subtitle: Text(matchQuary[index].second),
          onTap: () async {
            if (!await launchUrl(
              Uri.parse(matchQuary[index].second),
              mode: LaunchMode.inAppBrowserView,
            )) {
              throw Exception("cant run");
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 20, thickness: 2);
      },
    );
  }
}
