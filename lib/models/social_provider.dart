enum SocialType { google, apple }

class SocialProvider {
  final String name;
  final SocialType type;

  const SocialProvider({required this.name, required this.type});

  static const google = SocialProvider(name: 'Google', type: SocialType.google);
  static const apple = SocialProvider(name: 'Apple', type: SocialType.apple);

  static const all = [google, apple];
}