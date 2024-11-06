import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poll_pe_assignment/domain/models/post_model.dart';

class PostCubit extends Cubit<Post> {
  PostCubit(super.post);

  void likePost() {
    final newLikeCount =
        state.isLiked ? state.likeCount - 1 : state.likeCount + 1;
    emit(
      state.copyWith(
        likeCount: newLikeCount,
        isLiked: !state.isLiked,
      ),
    );
  }

  void addComment(String comment) {
    List<String> allComments = state.comments;
    allComments.add(comment);
    emit(state.copyWith(comments: allComments));
  }

  void voteForOption(String optionLabel) {
    final totalVotes = state.voteOptions.fold<double>(
      0,
      (sum, option) => sum + option.value,
    );

    final updatedOptions = state.voteOptions.map((option) {
      if (option.label == optionLabel) {
        return option.copyWith(
          value:
              ((option.value * totalVotes + 1) / (totalVotes + 1)) * 100,
        );
      } else {
        return option.copyWith(
          value:
              ((option.
              value * totalVotes) / (totalVotes + 1)) * 100,
        );
      }
    }).toList();

    emit(state.copyWith(voteOptions: updatedOptions));
  }
}