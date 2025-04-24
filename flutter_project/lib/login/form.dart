import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    required this.email,
    required this.passwd,
    required this.isLoading,
    this.error,
    required this.onSubmit,
    required this.btnLabel,
    required this.label,
    required this.hreflabel,
    required this.routeName
  });

  final TextEditingController email;
  final TextEditingController passwd;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onSubmit;
  final String btnLabel;
  final String label;
  final String hreflabel;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: 
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              offset: Offset(0, 2)
            )]
          ),
          padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                btnLabel,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
                ),
              
              SizedBox(height: 30),


              if (error != null)...[
                Text(
                  error!,
                  style: TextStyle(color: Colors.redAccent)
                ),

                SizedBox(height: 10)
              ],

              TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'email',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 189, 189, 189)
                  ),
                  ),
              ),

              SizedBox(height: 10),

              TextField(
                controller: passwd,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 189, 189, 189)
                  ),
                  ),
              ),

              SizedBox(height: 40),

              isLoading ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white
                  ),
                  child: Text(btnLabel)
              ),

              SizedBox(height: 10),
              
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, routeName), 
                    child: Text(
                      hreflabel,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blueAccent,
                        decorationColor: Colors.blueAccent,
                      ),
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
