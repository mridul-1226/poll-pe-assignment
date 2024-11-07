import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:poll_pe_assignment/domain/models/post_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poll_pe_assignment/presentation/feed/screens/feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(VoteOptionAdapter());
  final postBox = await Hive.openBox<Post>('postBox');

  runApp(
    MaterialApp(
      home: SocialMediaFeedPost(
        posts: Hive.box<Post>('postBox').values.toList(),
        postBox: postBox,
      ),
    ),
  );
}