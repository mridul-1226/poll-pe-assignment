import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      home: SocialMediaFeedPost(
        post: Post(
          id: '1',
          text: 'abc',
          likeCount: 0,
          commentCount: 0,
          voteOptions: [
            VoteOption(label: '1st', percentage: 2),
            VoteOption(label: '2nd', percentage: 0),
          ],
        ),
      ),
    ),
  );
}

// Models
class Post {
  final String id;
  final String text;
  final String? imageUrl;
  int likeCount;
  int commentCount;
  bool isLiked;
  final List<VoteOption> voteOptions;

  Post({
    required this.id,
    required this.text,
    this.imageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    required this.voteOptions,
  });

  Post copyWith(
      {int? likeCount, int? commentCount, List<VoteOption>? voteOptions, bool? isLiked,}) {
    return Post(
      id: id,
      text: text,
      imageUrl: imageUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      commentCount: commentCount ?? this.commentCount,
      voteOptions: voteOptions ?? this.voteOptions,
    );
  }
}

class VoteOption {
  final String label;
  double percentage;

  VoteOption({
    required this.label,
    this.percentage = 0,
  });

  VoteOption copyWith({double? percentage}) {
    return VoteOption(
      label: label,
      percentage: percentage ?? this.percentage,
    );
  }
}


class SocialMediaFeedPost extends StatefulWidget {
  final Post post;

  const SocialMediaFeedPost({super.key, required this.post});

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
    return BlocProvider(
      create: (_) => PostCubit(widget.post),
      child: BlocBuilder<PostCubit, Post>(
        builder: (context, post) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Card(
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        post.text,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (post.imageUrl != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                        ),
                        child: Image.network(
                          post.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
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
                            color: post.isLiked ? Colors.red : Colors.grey,
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
                            label: '${post.commentCount}',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) => CommentModal(post: post),
                              );
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.how_to_vote_outlined,
                            color: Colors.grey,
                            label: 'Vote',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) => VoteModal(post: post),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
          );
        },
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

// Updated PostCubit
class PostCubit extends Cubit<Post> {
  PostCubit(Post post) : super(post);

  void likePost() {
    final newLikeCount = state.isLiked ? state.likeCount - 1 : state.likeCount + 1;
    emit(state.copyWith(
      likeCount: newLikeCount,
      isLiked: !state.isLiked,
    ));
  }

  void addComment(String comment) {
    emit(state.copyWith(commentCount: state.commentCount + 1));
  }

  void voteForOption(String optionLabel) {
    final totalVotes = state.voteOptions.fold<double>(
      0,
      (sum, option) => sum + option.percentage,
    );

    final updatedOptions = state.voteOptions.map((option) {
      if (option.label == optionLabel) {
        return option.copyWith(
          percentage: ((option.percentage * totalVotes + 1) / (totalVotes + 1)) * 100,
        );
      } else {
        return option.copyWith(
          percentage: ((option.percentage * totalVotes) / (totalVotes + 1)) * 100,
        );
      }
    }).toList();

    emit(state.copyWith(voteOptions: updatedOptions));
  }
}

// CommentModal with enhanced UI
class CommentModal extends StatelessWidget {
  final Post post;
  final TextEditingController _commentController = TextEditingController();

  CommentModal({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
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
          const Expanded(
            child: Center(
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
                      context
                          .read<PostCubit>()
                          .addComment(_commentController.text);
                      _commentController.clear();
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// VoteModal with enhanced UI
class VoteModal extends StatelessWidget {
  final Post post;

  const VoteModal({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            post.text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ...post.voteOptions.map((option) => _buildVoteOption(
                context,
                option,
              )),
        ],
      ),
    );
  }

  Widget _buildVoteOption(BuildContext context, VoteOption option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          context.read<PostCubit>().voteForOption(option.label);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: option.label,
                groupValue: null,
                onChanged: (_) {
                  context.read<PostCubit>().voteForOption(option.label);
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text(
                  option.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${option.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}