import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:poll_pe_assignment/domain/models/post_model.dart';
import 'package:poll_pe_assignment/presentation/feed/bloc/post_cubit.dart';

class CommentModal extends StatelessWidget {
  final Post post;
  final Box<Post> postBox;
  final PostCubit postCubit;
  final TextEditingController _commentController = TextEditingController();

  CommentModal({
    super.key,
    required this.post,
    required this.postBox,
    required this.postCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(post, postBox),
      child: BlocBuilder<PostCubit, Post>(
        builder: (context, postState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Expanded(
                  child: postState.comments.isNotEmpty
                      ? ListView.builder(
                          itemCount: postState.comments.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(postState.comments[index]),
                                  leading: const Icon(Icons.account_circle),
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: Text('No comments yet'),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_commentController.text.trim().isNotEmpty) {
                            postCubit
                                .addComment(_commentController.text.trim());
                            _commentController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
