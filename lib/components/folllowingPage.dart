import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/components/constants.dart';
import 'package:instaclone/components/profilesearchresultpage.dart';

class FollowingPage extends StatefulWidget {
  final Map<String, dynamic> users;
  final String username;
  FollowingPage({Key key, @required this.users, @required this.username})
      : super(key: key);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username,
          style: appBarTitleTextStyle,
        ),
        backgroundColor: dynamicuicolor,
        elevation: 0,
      ),
      body: Column(
        children: [
          TabBar(controller: tabController, tabs: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Followers",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text("Following"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text("Suggestions"),
            ),
          ]),
          Flexible(
            child: TabBarView(controller: tabController, children: [
              _ListView(data: widget.users['followers']),
              _ListView(data: widget.users['follows']),
              _ListView(data: []),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<dynamic> data;
  const _ListView({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return ListTile(
          title: Text(item['username']),
          subtitle: Text(
            item['profile_name'],
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            clipBehavior: Clip.hardEdge,
            child: CircleAvatar(
              radius: 25,
              child: CachedNetworkImage(
                imageUrl: item['profile_pic'],
                fit: BoxFit.fill,
              ),
            ),
          ),
          trailing: InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.lightBlue,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
              child: Text(
                "Visit Profile",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileSearchResultPage(
                            uidretrieve: item['user_uid'],
                          )));
            },
          ),
        );
      },
    );
  }
}
