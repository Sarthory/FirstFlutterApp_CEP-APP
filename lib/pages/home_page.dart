import 'package:cep_app_flutter/models/endereco_model.dart';
import 'package:cep_app_flutter/repositories/cep_repository.dart';
import 'package:cep_app_flutter/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EnderecoModel? enderecoModel;
  final CepRepository cepRepository = CepRepositoryImpl();
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEP APP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O CEP é obrigatório';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    final valid = formKey.currentState?.validate() ?? false;

                    if (valid) {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final endereco = await cepRepository.getCep(cepEC.text);

                        setState(() {
                          isLoading = false;
                          enderecoModel = endereco;
                        });
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                          enderecoModel = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Erro ao buscar informações')));
                      }
                    }
                  },
                  child: const Text('Buscar CEP')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      enderecoModel = null;
                      cepEC.text = "";
                    });
                  },
                  child: const Text('Limpar')),
              Visibility(
                  visible: isLoading, child: const CircularProgressIndicator()),
              Visibility(
                  visible: enderecoModel != null,
                  child: Column(
                    children: [
                      Text("CEP: ${enderecoModel?.cep}"),
                      Text("Logradouro: ${enderecoModel?.logradouro}"),
                      Text("Complemento: ${enderecoModel?.complemento}"),
                      Text("Bairro: ${enderecoModel?.bairro}"),
                      Text("Localidade: ${enderecoModel?.localidade}"),
                      Text("UF: ${enderecoModel?.uf}"),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
