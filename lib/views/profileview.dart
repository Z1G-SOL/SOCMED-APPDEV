import 'package:flutter/material.dart';

import '../model/usercomment.dart';
import '../model/userdata.dart';
import '../model/userpost.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.userPost,
    this.openComments = false, // true = scroll to the comments when opened
  });

  final Userpost userPost;
  final bool openComments;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Userdata userData = Userdata();
  final ScrollController scrollController = ScrollController();
  // Marks where the comment section starts.
  final GlobalKey commentsKey = GlobalKey();

  var nametxtStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  void initState() {
    super.initState();
    if (widget.openComments) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) goToComments();
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // Scrolls so the comment section is at the top of the screen.
  void goToComments() {
    final ctx = commentsKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

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
                  // FIX: Comment scrolls down to the comment section.
                  onPressed: goToComments,
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

  Widget commenters(Userpost userPost) => Padding(
        key: commentsKey,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX: this showed the number of SHARES, not comments.
            Text(
              userPost.numcomments,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'All Comments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
      );

  Widget userpostdetails(Usercomment userComment) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(userComment.commenterImg),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userComment.commenterName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(userComment.commentContent),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Row(
                      children: [
                        Text(userComment.commentTime,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 12),
                        const Text('Like', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 12),
                        const Text('Reply', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

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

  @override
  Widget build(BuildContext context) {
    final userPost = widget.userPost;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
        ),
      ),
      // FIX: one scrolling page with the comments inside it (the old
      // ListView inside a ListView fought over scrolling, and the Comment
      // button needs every part of the page built to scroll to it).
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userline(userPost),
            postimage(userPost),
            buttons(userPost),
            commenters(userPost),
            ...userData.commentList.map(userpostdetails),
          ],
        ),
      ),
    );
  }
}