import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class Post {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  int likeCount;

  @HiveField(4)
  List<String> comments;

  @HiveField(5)
  bool isLiked;

  @HiveField(6)
  final List<VoteOption> voteOptions;

  Post({
    required this.id,
    required this.text,
    this.imageUrl,
    this.likeCount = 0,
    this.comments = const [],
    this.isLiked = false,
    required this.voteOptions,
  });

  Post copyWith({
    int? likeCount,
    List<String>? comments,
    List<VoteOption>? voteOptions,
    bool? isLiked,
  }) {
    return Post(
      id: id,
      text: text,
      imageUrl: imageUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
      voteOptions: voteOptions ?? this.voteOptions,
    );
  }
}

@HiveType(typeId: 1)
class VoteOption {
  @HiveField(0)
  final String label;

  @HiveField(1)
  double value;

  VoteOption({
    required this.label,
    this.value = 0,
  });

  VoteOption copyWith({double? value}) {
    return VoteOption(
      label: label,
      value: value ?? this.value,
    );
  }
}
