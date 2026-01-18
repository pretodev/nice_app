class OpenRouterMessage {
  final String role;
  final String content;

  const OpenRouterMessage._({
    required this.role,
    required this.content,
  });

  factory OpenRouterMessage.user(String content) =>
      OpenRouterMessage._(role: 'user', content: content);

  factory OpenRouterMessage.system(String content) =>
      OpenRouterMessage._(role: 'system', content: content);

  factory OpenRouterMessage.assistent(String content) =>
      OpenRouterMessage._(role: 'assistant', content: content);

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };
}
