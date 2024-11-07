import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:poll_pe_assignment/domain/models/post_model.dart';

class FeedCubit extends Cubit<List<Post>> {
  final Box<Post> postBox;

  FeedCubit(this.postBox) : super(postBox.values.toList());

  void refreshPosts() {
    emit(postBox.values.toList());
  }

  void updatePost(Post updatedPost) {
    postBox.put(updatedPost.id, updatedPost); 
    refreshPosts();
  }
}
