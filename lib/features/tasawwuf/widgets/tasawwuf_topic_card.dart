import 'package:flutter/material.dart';

import '../models/tasawwuf_topic_model.dart';

class TasawwufTopicCard extends StatelessWidget {
  final TasawwufTopicModel topic;

  const TasawwufTopicCard({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.self_improvement,
          color: Color(0xFF087A3B),
        ),
        title: Text(topic.title),
        subtitle: Text(topic.description),
      ),
    );
  }
}
