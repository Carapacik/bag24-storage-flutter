import 'package:flutter/material.dart';

class const PassportData({
  required final String lastName,
  required final String firstName,
  required final String? middleName,
  required final String birthDate,
  required final String passportNumber,
  required final String issueDate,
  required final String issuedBy,
}) {
  String? isValidLastName(BuildContext context) {
    if (lastName.isEmpty) {
      return 'Фамилия не может быть пустой';
    }
    if (lastName.length > 50) {
      return 'Фамилия должна быть меньше 50 символов';
    }
    if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ]+$').hasMatch(lastName)) {
      return 'Фамилия может содержать только буквы';
    }
    return null;
  }

  String? isValidFirstName(BuildContext context) {
    if (firstName.isEmpty) {
      return 'Имя не может быть пустым';
    }
    if (firstName.length > 50) {
      return 'Имя должно быть меньше 50 символов';
    }
    if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ]+$').hasMatch(firstName)) {
      return 'Имя может содержать только буквы';
    }
    return null;
  }

  String? isValidMiddleName(BuildContext context) {
    if (middleName == null) {
      return null;
    }
    if (middleName!.isEmpty) {
      return 'Отчество не может быть пустым';
    }
    if (middleName!.length > 50) {
      return 'Отчество должно быть меньше 50 символов';
    }
    if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ]+$').hasMatch(middleName!)) {
      return 'Отчество может содержать только буквы';
    }
    return null;
  }

  String? isValidPassportNumber(BuildContext context) {
    if (passportNumber.isEmpty) {
      return 'Номер паспорта не может быть пустым';
    }
    if (!RegExp(r'^\d{4} \d{6}$').hasMatch(passportNumber)) {
      return 'Номер паспорта должен быть в формате "XXXX XXXXXX"';
    }
    return null;
  }

  String? isValidIssueDate(BuildContext context) {
    if (issueDate.isEmpty) {
      return 'Дата выдачи не может быть пустой';
    }
    if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(issueDate)) {
      return 'Дата выдачи должна быть в формате ДД.ММ.ГГГГ';
    }
    return null;
  }

  String? isValidBirthDate(BuildContext context) {
    if (birthDate.isEmpty) {
      return 'Дата рождения не может быть пустой';
    }
    if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(birthDate)) {
      return 'Дата рождения должна быть в формате ДД.ММ.ГГГГ';
    }
    return null;
  }

  String? isValidIssuedBy(BuildContext context) {
    if (issuedBy.isEmpty) {
      return 'Орган, выдавший паспорт, не может быть пустым';
    }
    if (issuedBy.length > 200) {
      return 'Название органа должно быть меньше 200 символов';
    }
    return null;
  }
}
