import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poll_pe_assignment/presentation/poll_creation/poll_creation_screen.dart';
import 'package:poll_pe_assignment/domain/models/post_model.dart';
import 'package:poll_pe_assignment/presentation/feed/bloc/post_cubit.dart';
import 'package:poll_pe_assignment/presentation/feed/widgets/comment_modal.dart';
import 'package:poll_pe_assignment/presentation/feed/widgets/vote_modal.dart';

class SocialMediaFeedPost extends StatefulWidget {
  final List<Post> posts;

  const SocialMediaFeedPost({
    super.key,
    required this.posts,
  });

  @override
  State<SocialMediaFeedPost> createState() => _SocialMediaFeedPostState();
}

class _SocialMediaFeedPostState extends State<SocialMediaFeedPost>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;
  bool _isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartAnimation = Tween<double>(begin: 0, end: 1.4).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _handleLikeAnimation() {
    setState(() {
      _isLikeAnimating = true;
    });
    _heartAnimationController.forward().then((_) {
      _heartAnimationController.reverse();
      setState(() {
        _isLikeAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PollCreationScreen(),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
            itemCount: widget.posts.length,
            itemBuilder: (context, index) {
              return BlocProvider(
                create: (_) => PostCubit(widget.posts[index]),
                child: BlocBuilder<PostCubit, Post>(
                  builder: (context, post) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (post.imageUrl != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                  ),
                                  child: Image.network(
                                    post.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 300,
                                  child: Text(
                                    post.text,
                                    softWrap: true,
                                    maxLines: 4,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildActionButton(
                                  icon: post.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      post.isLiked ? Colors.red : Colors.grey,
                                  label: '${post.likeCount}',
                                  onTap: () {
                                    context.read<PostCubit>().likePost();
                                    if (!post.isLiked) {
                                      _handleLikeAnimation();
                                    }
                                  },
                                ),
                                _buildActionButton(
                                  icon: Icons.comment_outlined,
                                  color: Colors.grey,
                                  label: '${post.comments.length}',
                                  onTap: () {
                                    final postCubit = context.read<PostCubit>();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (_) => CommentModal(
                                        post: post,
                                        postCubit: postCubit,
                                      ),
                                    );
                                  },
                                ),
                                _buildActionButton(
                                  icon: Icons.how_to_vote_outlined,
                                  color: Colors.grey,
                                  label: 'Vote',
                                  onTap: () {
                                    final postCubit = context.read<PostCubit>();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (_) => VoteModal(
                                        post: post,
                                        postCubit: postCubit,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (_isLikeAnimating)
            AnimatedBuilder(
              animation: _heartAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartAnimation.value,
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Colors.red.withOpacity(
                      1 - _heartAnimation.value / 2,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
