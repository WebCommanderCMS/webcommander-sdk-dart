/// Animation effects path templates; the client fills `{api_version}`.
class AnimationEffectsUrls {
  AnimationEffectsUrls._();

  static const String animationEffects =
      '/api/{api_version}/admin/settings/animation_effects';

  static const String animationEffectsSection =
      '/api/{api_version}/admin/settings/animation_effects/{section}';

  /// The custom preloader image: `POST` uploads it, `DELETE` removes it.
  static const String animationEffectsCustomLoader =
      '/api/{api_version}/admin/settings/animation_effects/custom_loader';
}
