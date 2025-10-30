/// Widgets Module
/// 
/// This directory contains reusable UI components.
/// 
/// Responsibilities:
/// - Create custom, reusable widgets
/// - Encapsulate common UI patterns
/// - Handle widget-specific state and logic
/// - Ensure widgets are composable and testable
/// - Follow Material Design guidelines
/// 
/// Categories of Widgets:
/// 
/// 1. **Display Widgets**: Show information
///    - task_card.dart: Display task in a card format
///    - task_list_item.dart: Display task in list view
///    - empty_state.dart: Show when no data exists
/// 
/// 2. **Input Widgets**: Capture user input
///    - custom_text_field.dart: Styled text input
///    - date_picker_field.dart: Date selection widget
///    - priority_selector.dart: Select task priority
/// 
/// 3. **Action Widgets**: Trigger actions
///    - custom_button.dart: Styled button variants
///    - floating_action_button.dart: FAB for creating tasks
/// 
/// 4. **Feedback Widgets**: Provide feedback
///    - loading_indicator.dart: Show loading state
///    - error_message.dart: Display errors
///    - success_snackbar.dart: Show success messages
/// 
/// Best Practices:
/// - Keep widgets small and focused (Single Responsibility)
/// - Make widgets configurable via parameters
/// - Extract magic numbers to constants
/// - Use const constructors when possible
/// - Write widget tests for each component
/// 
/// Example:
/// ```dart
/// class TaskCard extends StatelessWidget {
///   final Task task;
///   final VoidCallback onTap;
///   final VoidCallback onComplete;
///   
///   const TaskCard({
///     Key? key,
///     required this.task,
///     required this.onTap,
///     required this.onComplete,
///   }) : super(key: key);
///   
///   @override
///   Widget build(BuildContext context) {
///     return Card(...);
///   }
/// }
/// ```
