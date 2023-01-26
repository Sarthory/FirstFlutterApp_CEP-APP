import 'dart:developer';

import 'package:cep_app_flutter/models/endereco_model.dart';
import 'package:dio/dio.dart';

import './cep_repository.dart';

class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {
      final res = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      return EnderecoModel.fromMap(res.data);
    } on DioError catch (e) {
      log('Erro ao buscar CEP', error: e);
      throw Exception('Erro ao buscar CEP');
    }
  }
}
