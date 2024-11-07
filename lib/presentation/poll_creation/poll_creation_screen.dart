import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poll_pe_assignment/presentation/feed/screens/feed_screen.dart';
import '../../domain/models/post_model.dart';

class PollCreationScreen extends StatefulWidget {
  final Box<Post> postBox;
  const PollCreationScreen({super.key, required this.postBox});

  @override
  State<PollCreationScreen> createState() => _PollCreationScreenState();
}

class _PollCreationScreenState extends State<PollCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _caption = '';
  String _imageUrl = '';
  final List<String> _options = ['', ''];
  final int _maxOptions = 5;

  Box<Post> get _postBox => Hive.box<Post>('postBox');

  void _savePoll() async {
    if (_formKey.currentState!.validate()) {
      final newPost = Post(
        id: DateTime.now().toString(),
        text: _caption,
        imageUrl: _imageUrl.isNotEmpty ? _imageUrl : null,
        likeCount: 0,
        comments: [],
        isLiked: false,
        voteOptions:
            _options.map((option) => VoteOption(label: option)).toList(),
      );
      await _postBox.put(newPost.id,newPost);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SocialMediaFeedPost(
            posts: _postBox.values.toList(),
            postBox: widget.postBox,
          ),
        ),
        (route) => false,
      );
    }
  }

  void _addOption() {
    if (_options.length < _maxOptions) {
      setState(() {
        _options.add('');
      });
    }
  }

  void _removeOption(int index) {
    if (_options.length > 2) {
      setState(() {
        _options.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Poll'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Poll',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Caption/Question',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a caption or question';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _caption = value;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Image URL',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Image URL',
                        ),
                        onChanged: (value) {
                          _imageUrl = value;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Options',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      for (int i = 0; i < _options.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Option ${i + 1}',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an option';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _options[i] = value;
                                  },
                                ),
                              ),
                              if (_options.length > 2)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    _removeOption(i);
                                  },
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 20),
                        onPressed: _savePoll,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Create Poll',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 20,
                          backgroundColor: Colors.deepPurple,
                        ),
                        onPressed: _addOption,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Add Option',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
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
