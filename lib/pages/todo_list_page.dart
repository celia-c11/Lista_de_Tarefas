// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

//--- Tela principal da lista de todos
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo?
  deletedTodo; // Armazena temporariamente a tarefa deletada para poder restaurar caso o usuário clique em "Desfazer"
  int?
  deletedTodoPos; // Guarda a posição original da tarefa deletada na lista, para inserir de volta no mesmo lugar

  String?
  errorText; // Usado para exibir uma mensagem de erro (por exemplo, se o campo de texto estiver vazio)

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(223, 255, 245, 245),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16), //--- Espaço lateral
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //--- Ocupa o mínimo de espaço vertical
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController, //--- Lê o que foi digitado
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex: Estudar Flutter',
                          errorText: // mostra a msg de erro quando adiciona uma tarefa vazia
                              errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              // muda a cor da linha da tarefa
                              color: const Color.fromARGB(255, 39, 78, 110),
                              width: 2, // O tamanho da borda
                            ),
                          ),

                          //Cor e tamanho do 'Adicone uma tarefa'
                          labelStyle: TextStyle(
                            fontSize: 17,
                            color: const Color.fromARGB(255, 21, 74, 117),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8), //--- Espaço entre o linha e o botão +

                    ElevatedButton(
                      onPressed: () {
                        String text =
                            todoController.text; //--- Pega o texto digitado

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O título não pode ser vazio!';
                          });
                          return; //função q impede adicionar tarefa vazia
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText =
                              null; // faz com oq a msg da tarefa vazia suma quando adicionamos outra
                        });

                        todoController
                            .clear(); // Limpa o campo de texto depois de adicionar a todo
                        todoRepository.saveTodoList(
                          todos,
                        ); // Salva as listas sem sumir quando voltar
                      },
                      //-----------------------------------------------------------------------//
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ), //--- Ícone +
                    ),
                    //-------------------------------------------------------------------------//
                  ],
                ),
                SizedBox(height: 30), //--- Espaçamento entre a linha e a tarefa
                //----------------------------------- L I S T A S ---------------------//
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                          onEdit: onEdit,
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 30), //--- Espaço antes da linha final
                //-------------------------------------------------------------------------//
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} Tarefas pendentes',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),

                    //-------------------------------------------------------------------------//
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        style: TextStyle(color: Colors.white),
                        'Limpar tudo',
                      ),
                    ),
                    //--------------------------------------------------------------------------//
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função que exclui uma tarefa e mostra um mensagem com opção de desfazer

  void onDelete(Todo todo) {
    // Armazena a tarefa excluída para possível restauração
    deletedTodo = todo; // Salva a posição original da tarefa na lista

    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo); // Remove a tarefa da lista e atualiza a interface

      todoRepository.saveTodoList(todos); // Salva as tarefas quando fecha o app
    });

    ScaffoldMessenger.of(
      context,
    ).clearMaterialBanners(); //Exibe uma mensagem temporária no rodapé da tela

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi excluida com sucesso!', // Mensagem informando a exclusão da tarefa
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: Color.fromARGB(255, 143, 168, 193),
        action: SnackBarAction(
          //Rótulo do botão para desfazer que fica do lado da mensagem
          label: 'Desfazer',
          textColor: const Color.fromARGB(255, 0, 0, 0),

          onPressed: () {
            setState(() {
              todos.insert(
                deletedTodoPos!, // Coloca a tarefa de volta no mesmo lugar que estava antes
                deletedTodo!,
              );
              todoRepository.saveTodoList(
                todos,
              ); // Salva as tarefas quando fecha o app
            });
          },
        ),
        duration: const Duration(seconds: 5), //Duração da msg que fica na tela
      ),
    );
  }
  //------------------------------------------------//---------------------------------------------------------//

  void onEdit(Todo todo) {
    TextEditingController controller = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          // Aqui muda as cores dentro do editar tarefa
          data: Theme.of(context).copyWith(
            // Cores padrão dos textos e botões
            textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          child: AlertDialog(
            // Título da botão de editar
            title: Text('Editar Tarefa'),
            // Campo onde o usuário digita o novo título
            content: TextField(controller: controller),

            actions: [
              // Botão para fechar sem salvar
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              // Botão para salvar o novo título e fechar
              TextButton(
                onPressed: () {
                  setState(() {
                    todo.title = controller.text;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  //------------------------------------------------//---------------------------------------------------------//

  void showDeleteTodosConfirmationDialog() {
    // Função que mostra um alerta perguntando se o usuário quer limpar tudo
    showDialog(
      context: context, // Contexto necessário para exibir o diálogo
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'), // Título do alerta
        content: Text(
          'Você tem certeza que deseja limpar tudo? ',
        ), // Mensagem de confirmação

        actions: [
          // Ação do botão "Cancelar"
          TextButton(
            onPressed: () {
              // Fecha o diálogo quando aperta cancelar
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: Text('Cancelar'), // Texto e cor do botão
          ),

          // Ação do botão "Limpar tudo"
          TextButton(
            onPressed: () {
              // Fecha o diálogo que está aberto na tela
              Navigator.of(context).pop();
              deleteAllTodos(); // Chama a função que apaga todas as tarefas
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Limpar tudo'), // Texto do botão
          ),
        ],
      ),
    );
  }

  // Função que apaga todas as tarefas da lista
  void deleteAllTodos() {
    // O setState avisa o Flutter para atualizar a tela com a lista vazia
    // Sem ele a tela não limpa visialmente
    setState(() {
      todos.clear(); // Limpa a lista de tarefas, removendo tudo
    });
    todoRepository.saveTodoList(todos);
  }
}
