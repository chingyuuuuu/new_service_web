import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/user/Forget_provider.dart';
import 'package:go_router/go_router.dart';

class Forget1 extends StatelessWidget {
  const Forget1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forgetProvider = Provider.of<ForgetProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: const Center(
              child: Text(
                'Service',
                style: TextStyle(
                  fontSize: 120,
                  fontFamily: 'Kapakana',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF223888),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '驗證',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: forgetProvider.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: forgetProvider.isSending
                        ? null
                        : () async {
                      await forgetProvider.sendResetCode(context, () => context.push('/Forget2'),
                      );
                    },
                    child: forgetProvider .isSending
                        ? const CircularProgressIndicator()
                        : const Text('確認'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF36FDE6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                if (forgetProvider .message.isNotEmpty)
                  Center(
                    child: Text(
                      forgetProvider .message,
                      style: TextStyle(
                        color: forgetProvider.message.startsWith('Failed')
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
