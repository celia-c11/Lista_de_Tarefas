import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onEdit,
  });

  final Todo todo; // A tarefa que será mostrada neste item
  final Function(Todo)
  onDelete; // Função que será chamada quando o usuário quiser DELETAR a tarefa
  final Function(Todo)
  onEdit; // Função que será chamada quando o usuário quiser EDITAR a tarefa

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Widget que permite deslizar o item para mostrar botões (como "deletar" e "editar")
      endActionPane: ActionPane(
        // Painel que aparece quando o usuário desliza o item
        motion: const StretchMotion(), // Efeito de esticar ao deslizar
        extentRatio: 0.40, // Ocupa 40% da largura quando desliza

        children: [
          SlidableAction(
            onPressed: (_) {
              onDelete(todo); // Chama a função para deletar a tarefa
            },
            backgroundColor: Colors.red,
            icon: Icons.delete, // Ícone de lixeira
            label: 'Deletar', // Texto do botão
          ),
          SlidableAction(
            onPressed: (_) {
              onEdit(todo); // Chama a função para editar a tarefa
            },
            backgroundColor: Colors.blue,
            icon: Icons.edit, // Ícone de lápis
            label: 'Editar', // Texto do botão
          ),
        ],
      ),

      // O visual do quadrado do item da lista
      child: Container(
        width: double.infinity, // Ocupa toda a largura disponível
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), // Arredonda os cantos
          color: const Color.fromARGB(255, 227, 225, 225),
        ),

        margin: const EdgeInsets.symmetric(
          vertical: 1, // Espaço entre os itens da lista
        ),
        padding: const EdgeInsets.all(16), // Espaço interno

        child: Column(
          // Organiza os textos um em cima do outro
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Alinha os textos à esquerda
          children: [
            Text(
              DateFormat(
                'dd/MM/yyyy - HH:mm',
              ).format(todo.dateTime), // Mostra a data e hora da tarefa
              style: TextStyle(fontSize: 13), // Tamanho pequeno para a data
            ),
            Text(
              todo.title, // Mostra o título da tarefa adicionada
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600, // Fonte maior e em negrito
              ),
            ),
          ],
        ),
      ),
    );
  }
}
