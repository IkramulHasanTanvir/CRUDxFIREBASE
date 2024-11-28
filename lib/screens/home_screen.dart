import 'package:crud/models/note_model.dart';
import 'package:crud/services/firestore.dart';
import 'package:crud/widgets/note_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FireStoreService _fireStoreService = FireStoreService();
  final TextEditingController _notesTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(color: Colors.grey[300]),
        ),
        backgroundColor: Colors.grey[600],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
            stream: _fireStoreService.notes.snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              final note = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: note.length,
                  itemBuilder: (context, index) {
                    final NoteModel noteModel =
                    NoteModel.fromFireStore(note[index]);
                    return NoteTile(
                      noteModel: noteModel,
                      onTapUpdate: () => openNoteBox(noteModel.id),
                    );
                  });
            }),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.grey[600],
      foregroundColor: Colors.grey[300],
      onPressed: () {
        openNoteBox();
      },
      child: const Icon(Icons.add),
    );
  }

  Future<void> openNoteBox([String? docId]) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notes Add'),
            content: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _notesTEController,
              validator: (value){
                if(value!.trim().isEmpty){
                  return 'Enter a value';
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if(_notesTEController.text.isEmpty) return;
                  if (docId == null) {
                    _fireStoreService.addNote(_notesTEController.text.trim());
                  } else {
                    _fireStoreService.updateNotes(
                        docId, _notesTEController.text.trim());
                  }
                  _notesTEController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }
}
