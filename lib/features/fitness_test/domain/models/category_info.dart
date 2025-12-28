/// Category information for fitness test results
class CategoryInfo {
  final String category;
  final String strengthTitle;
  final String strengthReason;
  final String weaknessTitle;
  final String weaknessReason;

  const CategoryInfo({
    required this.category,
    required this.strengthTitle,
    required this.strengthReason,
    required this.weaknessTitle,
    required this.weaknessReason,
  });

  static const Map<String, CategoryInfo> categoryMapping = {
    'LOWER': CategoryInfo(
      category: 'LOWER',
      strengthTitle: 'Lower Body Strength',
      strengthReason: 'Your squat score suggests solid leg strength and control.',
      weaknessTitle: 'Lower Body Foundation',
      weaknessReason:
          'We\'ll start with simple leg patterns to build strength safely and quickly.',
    ),
    'PUSH': CategoryInfo(
      category: 'PUSH',
      strengthTitle: 'Upper Body Push Strength',
      strengthReason:
          'Your push-up result shows good pressing strength and core stability.',
      weaknessTitle: 'Upper Body Push Foundation',
      weaknessReason:
          'We\'ll build push strength with easier variations and steady progression.',
    ),
    'PULL': CategoryInfo(
      category: 'PULL',
      strengthTitle: 'Upper Back Control',
      strengthReason:
          'Your reverse snow angels show good posture control and upper-back endurance.',
      weaknessTitle: 'Upper Back Strength',
      weaknessReason:
          'We\'ll strengthen your upper back to improve posture and shoulder stability.',
    ),
    'CORE': CategoryInfo(
      category: 'CORE',
      strengthTitle: 'Core Stability',
      strengthReason:
          'Your plank time shows strong core endurance and body control.',
      weaknessTitle: 'Core Foundation',
      weaknessReason:
          'We\'ll improve core stability step by step to support every exercise.',
    ),
    'COND': CategoryInfo(
      category: 'COND',
      strengthTitle: 'Cardio & Conditioning',
      strengthReason:
          'Your mountain climbers score suggests good work capacity and endurance.',
      weaknessTitle: 'Conditioning Base',
      weaknessReason:
          'We\'ll build your stamina gradually without overloading your joints.',
    ),
  };
}
