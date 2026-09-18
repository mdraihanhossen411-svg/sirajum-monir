import '../models/accessibility_option.dart';

class AccessibilityData {
  static const options = <AccessibilityOption>[
    AccessibilityOption(
      title: 'Text Size',
      subtitle: 'লেখার আকার সহজে পড়ার উপযোগী করুন',
      key: 'text_size',
    ),
    AccessibilityOption(
      title: 'High Contrast',
      subtitle: 'লেখা ও উপাদানের contrast বাড়ান',
      key: 'high_contrast',
    ),
    AccessibilityOption(
      title: 'Reduce Motion',
      subtitle: 'অ্যানিমেশন ও motion কমিয়ে দিন',
      key: 'reduce_motion',
    ),
    AccessibilityOption(
      title: 'Larger Buttons',
      subtitle: 'বাটন ও touch area বড় করুন',
      key: 'larger_buttons',
    ),
    AccessibilityOption(
      title: 'Screen Reader Support',
      subtitle: 'Screen reader ব্যবহারের জন্য প্রস্তুতি',
      key: 'screen_reader',
    ),
    AccessibilityOption(
      title: 'Arabic Text Display',
      subtitle: 'আরবি লেখা সহজে পড়ার সুবিধা',
      key: 'arabic_text',
    ),
    AccessibilityOption(
      title: 'Accessibility Settings',
      subtitle: 'অ্যাক্সেসিবিলিটির অন্যান্য সেটিংস',
      key: 'general',
    ),
  ];
}
