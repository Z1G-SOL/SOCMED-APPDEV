import 'package:flutter/material.dart';

import '../model/userdata.dart';
import '../model/userpost.dart';
import 'profileview.dart';

class Postlist extends StatefulWidget {
  const Postlist({super.key, required this.userdata});

  final Userdata userdata;

  @override
  State<Postlist> createState() => _PostlistState();
}

class _PostlistState extends State<Postlist> {
  var nametxtStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  // Opens a screen, then refreshes this list when you come back
  // (so a Like pressed on the post screen shows here too).
  Future<void> gotoPage(BuildContext context, Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    if (mounted) setState(() {});
  }

  Widget userline(Userpost userPost) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage(userPost.userimg),
              radius: 20,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userPost.username, style: nametxtStyle),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(userPost.time),
                  const Text('.'),
                  const Icon(Icons.group, size: 15, color: Colors.grey),
                ],
              ),
            ],
          ),
        ],
      );

  Widget postimage(Userpost userPost) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [Text(userPost.postcontent)]),
            const SizedBox(height: 15),
            Container(
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(userPost.posting),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      );

  Widget counts(Userpost userPost) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('${userPost.numcomments} Comments'),
            const SizedBox(width: 20),
            Text('${userPost.numshare} Shares'),
          ],
        ),
      );

  Widget buttons(Userpost userPost) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    // FIX: colors were swapped (liked showed grey).
                    foregroundColor:
                        userPost.isLiked ? Colors.blue : Colors.grey,
                  ),
                  // FIX: Like now works.
                  onPressed: () {
                    setState(() => userPost.isLiked = !userPost.isLiked);
                  },
                  icon: const Icon(Icons.thumb_up, size: 20),
                  label: const Text('Like'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  // FIX: Comment opens the post and goes to its comments.
                  onPressed: () {
                    gotoPage(
                      context,
                      ProfileView(userPost: userPost, openComments: true),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble, size: 20),
                  label: const Text('Comment'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  // FIX: Share now responds.
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post shared!')),
                    );
                  },
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text('Share'),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      );

  Widget showPost(Userpost userPost) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userline(userPost),
          postimage(userPost),
          counts(userPost),
          const Divider(),
          buttons(userPost),
          SizedBox(height: 10, child: Container(color: Colors.grey)),
          const SizedBox(height: 15),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // FIX: a plain Column. The old ListView inside a SingleChildScrollView
    // inside the page's ListView fought over scrolling.
    return Column(
      children: widget.userdata.userList.map((userPost) {
        return InkWell(
          onTap: () {
            gotoPage(context, ProfileView(userPost: userPost));
          },
          child: showPost(userPost),
        );
      }).toList(),
    );
  }
}