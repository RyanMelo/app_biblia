import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:clipboard/clipboard.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final _FormVersiculoKey = GlobalKey<FormState>();
  final _livro = TextEditingController();
  final _capitulo = TextEditingController();
  final _verso = TextEditingController();

  String isLoading = "";
  String versiculo = "";
  String referencia = "";

  void pesquisaVersiculo() async {

    setState(() {
      isLoading = "carregando";
    });

    var jsonResponse;
    var url = Uri.parse("https://bible-api.com/${_livro.text}+${_capitulo.text}:${_verso.text}?translation=almeida");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        versiculo = jsonResponse['text'];
        referencia = jsonResponse['reference'];
        isLoading = "carregou";
      });
    } else if (response.statusCode == 404) {
      final snackBar = const SnackBar(content: Text("Versículo não encontrado!"), duration: Duration(seconds: 5),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    print('$jsonResponse');

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.book,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Text(
                    "Pesquise um versículos",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
              Form(
                key: _FormVersiculoKey,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 7),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Livro",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffD9D9D9))
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffD9D9D9))
                            ),
                            filled: true,
                          ),
                          controller: _livro,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira o nome do livro';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 7),
                      child: SizedBox(
                        width: 90,
                        height: 50,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Capítulo",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffD9D9D9))
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffD9D9D9))
                            ),
                            filled: true,
                          ),
                          controller: _capitulo,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira o nome do capítulo';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 7),
                      child: SizedBox(
                        width: 80,
                        height: 50,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Verso",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffD9D9D9))
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffD9D9D9))
                            ),
                            filled: true,
                          ),
                          controller: _verso,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Insira o nome do Verso';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          child: Container(
                            // ignore: sort_child_properties_last
                            child: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onTap: () {
                            _FormVersiculoKey.currentState?.save();
                            if(_livro.text.isEmpty || _capitulo.text.isEmpty || _verso.text.isEmpty) {
                              final snackBar = const SnackBar(content: Text("Preencha todos os campos!"), duration: Duration(seconds: 5),backgroundColor: Colors.red,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else {
                              pesquisaVersiculo();
                              _livro.clear();
                              _capitulo.clear();
                              _verso.clear();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              const SizedBox(height: 30,),
              Center(
                child: isLoading == "carregando"
                ? const CircularProgressIndicator() 
                : RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: versiculo != "" ? "“" : "",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                      TextSpan(
                        text: "$versiculo",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                      TextSpan(
                        text: versiculo != "" ? "”" : "",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                "$referencia",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              ),
            
              const SizedBox(height: 30,),
              SizedBox(
                width: 150,
                height: 50,
                child: GestureDetector(
                  child: Container(
                    // ignore: sort_child_properties_last
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          " Copiar verso",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary
                          ),
                        )
                      ]
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: () {
                    var snackBar = const SnackBar(content: Text("Versiculo copiado! Cole onde quiser!"), duration: Duration(seconds: 5),backgroundColor: Colors.green,);
                    FlutterClipboard.copy("$versiculo \n($referencia)").then(( value ) => 
                      ScaffoldMessenger.of(context).showSnackBar(snackBar)); 
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}