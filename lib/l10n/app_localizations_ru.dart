// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get app_tittle => 'men2r';

  @override
  String get auth_login_title => 'Вход';

  @override
  String get auth_register_title => 'Регистрация';

  @override
  String get auth_field_login => 'Логин';

  @override
  String get auth_field_password => 'Пароль';

  @override
  String get auth_btn_login => 'Войти';

  @override
  String get auth_btn_register => 'Создать аккаунт';

  @override
  String get auth_no_account => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get auth_have_account => 'Уже есть аккаунт? Войти';

  @override
  String get auth_error_invalid => 'Неверный логин или пароль';

  @override
  String get auth_logout => 'Выйти';

  @override
  String get settings_title => 'Настройки';

  @override
  String get settings_menu_title => 'Настройки';

  @override
  String get settings_theme_title => 'Переключение темы';

  @override
  String get settings_theme_dark => 'Тёмная тема';

  @override
  String get settings_theme_light => 'Светлая тема';

  @override
  String get settings_language => 'Язык';

  @override
  String get settings_language_ru => 'Русский';

  @override
  String get settings_language_en => 'Английский';

  @override
  String get settings_role => 'Роль (тестирование)';

  @override
  String get settings_role_admin => 'Админ';

  @override
  String get settings_role_student => 'Студент';

  @override
  String get generic_save => 'Сохранить';

  @override
  String get generic_delete => 'Удалить';

  @override
  String get generic_edit => 'Изменить';

  @override
  String get generic_time_hours => 'ч.';

  @override
  String get generic_time_years => 'л.';

  @override
  String get generic_currency_byn => 'бун';

  @override
  String get generic_succes_message => 'Успех';

  @override
  String get generic_remind_message => 'Напоминание';

  @override
  String get generic_api_error => 'Ошибка API';

  @override
  String get generic_field_required_error => 'Необходимо ввести поле';

  @override
  String get tutor_menu_title => 'Репетиторы';

  @override
  String get tutor_list_title => 'Репетиторы';

  @override
  String get tutor_details_screen_title => 'Подробная информация';

  @override
  String get tutor_details_id => 'Идентификатор';

  @override
  String get tutor_details_firstname => 'Имя';

  @override
  String get tutor_details_lastname => 'Фамилия';

  @override
  String get tutor_details_patronymic => 'Отчество';

  @override
  String get tutor_details_experience => 'Опыт работы';

  @override
  String get tutor_details_description => 'Описание';

  @override
  String get tutor_details_subjects => 'Преподаваемые предметы';

  @override
  String get tutor_form_edit_title => 'Редактирование репетитора';

  @override
  String get tutor_form_create_title => 'Создание репетитора';

  @override
  String get tutor_form_subject_count => 'Предм.';

  @override
  String get tutor_form_select_subject_title => 'Выбрать предметы';

  @override
  String get course_menu_title => 'Курсы';

  @override
  String get course_list_title => 'Курсы';

  @override
  String get course_details_screen_title => 'Подробная информация';

  @override
  String get course_details_id => 'Идентификатор';

  @override
  String get course_details_title => 'Название';

  @override
  String get course_details_description => 'Описание';

  @override
  String get course_details_start_date => 'Дата начала обучения';

  @override
  String get course_details_end_date => 'Дата окончания обучения';

  @override
  String get course_details_hours => 'Часы обучения';

  @override
  String get course_details_price => 'Цена обучения';

  @override
  String get course_details_tutor => 'Репетитор';

  @override
  String get course_details_date_period => 'Период обучения';

  @override
  String get course_form_edit_title => 'Редактирование курса';

  @override
  String get course_form_create_title => 'Создание курса';

  @override
  String get filter_sort_title => 'Фильтрация и сортировка';

  @override
  String get filter_sort_course_by_price => 'По цене';

  @override
  String get filter_sort_course_by_hours => 'По часам обучения';

  @override
  String get filter_sort_reset => 'Сбросить фильтры и сортировку';

  @override
  String get filter_sort_direction => 'Направление сортировки';

  @override
  String get notification_channel_name => 'Напоминания о курсах';

  @override
  String get notification_channel_desc =>
      'Уведомления о начале ваших онлайн-курсов';

  @override
  String get notification_title_start => 'Скоро начало курса!';

  @override
  String notification_body_start(Object time, Object title) {
    return 'Курс \"$title\" начнется в $time';
  }

  @override
  String get notification_title_end => 'Скоро конец курса!';

  @override
  String notification_body_end(Object time, Object title) {
    return 'Курс \"$title\" закончится в $time';
  }

  @override
  String get image_source_camera => 'Камера';

  @override
  String get image_source_gallery => 'Галерея';

  @override
  String get share_course_subject => 'Рекомендация курса';

  @override
  String share_course_text(Object hours, Object price, Object title) {
    return 'Зацени курс \"$title\" на платформе men2r_app!\nЦена: $price BYN.\nДлительность: $hours ч.';
  }

  @override
  String get share_tutor_subject => 'Рекомендация репетитора';

  @override
  String share_tutor_text(Object exp, Object name, Object subjects) {
    return 'Рекомендую отличного репетитора: $name!\nСпециализация: $subjects\nОпыт: $exp лет.';
  }
}
