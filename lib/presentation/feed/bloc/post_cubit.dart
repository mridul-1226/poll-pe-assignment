import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:poll_pe_assignment/domain/models/post_model.dart';

class PostCubit extends Cubit<Post> {
  final Box<Post> postBox;

  PostCubit(super.post, this.postBox);

  void likePost() {
    final newLikeCount =
        state.isLiked ? state.likeCount - 1 : state.likeCount + 1;
    final updatedPost = state.copyWith(
      likeCount: newLikeCount,
      isLiked: !state.isLiked,
    );

    emit(updatedPost);
    _savePost(updatedPost);
  }

  void addComment(String comment) async {
    final updatedComments = List<String>.from(state.comments)..add(comment);
    final updatedPost = state.copyWith(comments: updatedComments);

    await _savePost(updatedPost);

    emit(updatedPost);
  }

  void voteForOption(String optionLabel) {
    final updatedOptions = state.voteOptions.map((option) {
      if (option.label == optionLabel) {
        return option.copyWith(value: (option.value + 1));
      } else {
        return option.copyWith(
          value: ((option.value)),
        );
      }
    }).toList();

    final updatedPost = state.copyWith(voteOptions: updatedOptions);

    emit(updatedPost);
    _savePost(updatedPost);
  }

  Future<void> _savePost(Post updatedPost) {
    return postBox.put(updatedPost.id, updatedPost);
  }
}
