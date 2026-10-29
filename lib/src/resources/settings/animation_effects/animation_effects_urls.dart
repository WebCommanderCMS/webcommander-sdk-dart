/// Animation effects path templates; the client fills `{api_version}`.
class AnimationEffectsUrls {
  AnimationEffectsUrls._();

  static const String animationEffects =
      '/api/{api_version}/admin/settings/animation_effects';

  static const String animationEffectsSection =
      '/api/{api_version}/admin/settings/animation_effects/{section}';
}
