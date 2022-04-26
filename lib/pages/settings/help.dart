import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _messageC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(),
        toolbarHeight: AppSizes.minToolBarHeight,
        flexibleSpace: AnimatedContainer(
          padding: const EdgeInsets.all(15),
          duration: const Duration(seconds: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.themeColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 20.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Help',
                    style: TextStyle(
                        fontSize: AppSizes.titleFont.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear_outlined),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.pagePading),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Write something to us',
                style: TextStyle(fontSize: AppSizes.titleFont.sp),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameC,
                cursorColor: AppColors.themeColor,
                decoration: AppStyles().textFieldDecoration(
                    label: 'Your Name', hintText: 'Somebody'),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Your name is required';
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                  minLines: 3,
                  controller: _messageC,
                  cursorColor: AppColors.themeColor,
                  maxLines: null,
                  decoration: AppStyles().textFieldDecoration(
                      label: 'Message', hintText: 'Write something...'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'A message is required';
                    }
                    return null;
                  }),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(
          Icons.message_outlined,
          color: Colors.white,
        ),
        heroTag: 'Send',
        label: Text(
          'Send',
          style: TextStyle(
              color: Colors.white, fontSize: AppSizes.normalFontSize.sp),
        ),
        backgroundColor: AppColors.themeColor,
        onPressed: sendMessage,
        tooltip: 'Send',
      ),
    );
  }

  void sendMessage() async {
    final Email mail = Email(
      body: _messageC.value.text,
      subject: 'Message from ${_nameC.value.text} via Budget Buddy',
      recipients: ['lebrightdesigns@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(mail).then((value) {
      ToastService(context: context).showSuccessToast('Message sent');
      Navigator.pop(context);
    });
  }
}
