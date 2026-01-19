class OpenRouterMessage {
  final String role;
  final dynamic content;

  const OpenRouterMessage._({required this.role, required this.content});

  factory OpenRouterMessage.user(String content) =>
      OpenRouterMessage._(role: 'user', content: content);

  factory OpenRouterMessage.system(String content) =>
      OpenRouterMessage._(role: 'system', content: content);

  factory OpenRouterMessage.assistent(String content) =>
      OpenRouterMessage._(role: 'assistant', content: content);

  factory OpenRouterMessage.userWithImage({
    required String text,
    required String base64Image,
  }) => OpenRouterMessage._(
    role: 'user',
    content: [
      {'type': 'text', 'text': text},
      {
        'type': 'image_url',
        'image_url': {'url': base64Image},
      },
    ],
  );

  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}
