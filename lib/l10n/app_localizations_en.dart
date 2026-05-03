// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_tittle => 'men2r';

  @override
  String get auth_login_title => 'Login';

  @override
  String get auth_register_title => 'Registration';

  @override
  String get auth_field_login => 'Username';

  @override
  String get auth_field_password => 'Password';

  @override
  String get auth_btn_login => 'Sign In';

  @override
  String get auth_btn_register => 'Sign Up';

  @override
  String get auth_no_account => 'Don\'t have an account? Register';

  @override
  String get auth_have_account => 'Already have an account? Login';

  @override
  String get auth_error_invalid => 'Invalid login or password';

  @override
  String get auth_logout => 'Logout';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_menu_title => 'Settings';

  @override
  String get settings_theme_title => 'Toggle theme';

  @override
  String get settings_theme_dark => 'Dark';

  @override
  String get settings_theme_light => 'Light';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_language_ru => 'Russian';

  @override
  String get settings_language_en => 'English';

  @override
  String get settings_role => 'Role';

  @override
  String get settings_role_admin => 'Admin';

  @override
  String get settings_role_student => 'Student';

  @override
  String get generic_save => 'Save';

  @override
  String get generic_delete => 'Delete';

  @override
  String get generic_edit => 'Edit';

  @override
  String get generic_time_hours => 'h.';

  @override
  String get generic_time_years => 'y.';

  @override
  String get generic_currency_byn => 'byn';

  @override
  String get generic_succes_message => 'Success';

  @override
  String get generic_remind_message => 'Remind';

  @override
  String get generic_api_error => 'API Error';

  @override
  String get generic_field_required_error => 'Field is required';

  @override
  String get tutor_menu_title => 'Tutors';

  @override
  String get tutor_list_title => 'Tutors';

  @override
  String get tutor_details_screen_title => 'Detailed information';

  @override
  String get tutor_details_id => 'ID';

  @override
  String get tutor_details_firstname => 'Firstname';

  @override
  String get tutor_details_lastname => 'Lastname';

  @override
  String get tutor_details_patronymic => 'Patronymic';

  @override
  String get tutor_details_experience => 'Experience';

  @override
  String get tutor_details_description => 'Description';

  @override
  String get tutor_details_subjects => 'Subjects taught';

  @override
  String get tutor_form_edit_title => 'Edit tutor';

  @override
  String get tutor_form_create_title => 'Create tutor';

  @override
  String get tutor_form_subject_count => 'Subj.';

  @override
  String get tutor_form_select_subject_title => 'Select subjects';

  @override
  String get course_menu_title => 'Courses';

  @override
  String get course_list_title => 'Courses';

  @override
  String get course_details_screen_title => 'Detailed information';

  @override
  String get course_details_id => 'ID';

  @override
  String get course_details_title => 'Title';

  @override
  String get course_details_description => 'Description';

  @override
  String get course_details_start_date => 'Start date of training';

  @override
  String get course_details_end_date => 'End date of training';

  @override
  String get course_details_hours => 'Training hours';

  @override
  String get course_details_price => 'Price of training';

  @override
  String get course_details_tutor => 'Tutor';

  @override
  String get course_details_date_period => 'Training period';

  @override
  String get course_form_edit_title => 'Edit course';

  @override
  String get course_form_create_title => 'Create course';

  @override
  String get filter_sort_title => 'Filter and sort';

  @override
  String get filter_sort_course_by_price => 'By price';

  @override
  String get filter_sort_course_by_hours => 'By hours';

  @override
  String get filter_sort_reset => 'Reset filter & sort';

  @override
  String get filter_sort_direction => 'Sort direction';

  @override
  String get notification_channel_name => 'Course Reminders';

  @override
  String get notification_channel_desc =>
      'Notifications about your online courses starting';

  @override
  String get notification_title_start => 'Course starting soon!';

  @override
  String notification_body_start(Object time, Object title) {
    return 'Course \"$title\" will start at $time';
  }

  @override
  String get notification_title_end => 'Course ending soon!';

  @override
  String notification_body_end(Object time, Object title) {
    return 'Course \"$title\" will end at $time';
  }

  @override
  String get image_source_camera => 'Camera';

  @override
  String get image_source_gallery => 'Gallery';

  @override
  String get share_course_subject => 'Course Recommendation';

  @override
  String share_course_text(Object hours, Object price, Object title) {
    return 'Check out course \"$title\" on men2r_app!\nPrice: $price BYN.\nDuration: $hours h.';
  }

  @override
  String get share_tutor_subject => 'Tutor Recommendation';

  @override
  String share_tutor_text(Object exp, Object name, Object subjects) {
    return 'I recommend a great tutor: $name!\nSpecialization: $subjects\nExperience: $exp years.';
  }
}
