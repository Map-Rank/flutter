import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import 'package:mapnrank/color_constants.dart';

class AccountView extends GetView<ProfileController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'General',
                style: TextStyle(color: Colors.black87, fontSize: 30.0),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage("assets/images/im.jpg"),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 3,
                        child: GestureDetector(
                          onTap: () async {
                            // Uint8List imga =
                            //     await getImage(ImageSource.gallery);
                            // setState(() {
                            //   img = imga;
                            //   base64Image = base64Encode(imga);
                            // });
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: const BoxDecoration(
                                color: interfaceColor,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      readOnly: false,
                      labelText: 'First Name',
                      hintText: "Kamdem",
                      initialValue: '',
                      keyboardType: TextInputType.text,
                      // onSaved: (input) =>
                      //     controller.currentUser.value.firstName = input,
                      // onChanged: (value) => {
                      //   controller.currentUser.value.firstName = value,
                      // },
                      validator: (input) => input!.length < 3
                          ? 'Enter at least 3 characters'
                          : null,
                      iconData: Icons.person,
                      key: null,
                      errorText: '',
                      suffixIcon: const Icon(null),
                      suffix: const Icon(null),
                    ),
                    TextFieldWidget(
                      isFirst: true,
                      readOnly: false,
                      labelText: 'Last Name',
                      hintText: "Flanklin Junior",
                      initialValue: '',
                      keyboardType: TextInputType.text,
                      // onSaved: (input) =>
                      //     controller.currentUser.value.lastName = input,
                      // onChanged: (value) => {
                      //   controller.currentUser.value.lastName = value,
                      // },
                      validator: (input) => input!.length < 3
                          ? 'Enter at least 3 characters'
                          : null,
                      iconData: Icons.person,
                      key: null,
                      errorText: '',
                      suffixIcon: const Icon(null),
                      suffix: const Icon(null),
                    ),
                    TextFieldWidget(
                      readOnly: true,
                      labelText: 'Email',
                      hintText: "kamdemj21@gmail.com",
                      initialValue: '',
                      keyboardType: TextInputType.emailAddress,
                      // onSaved: (input) =>
                      //     controller.currentUser.value.email = input,
                      // onChanged: (value) =>
                      //     {controller.currentUser.value.email = value},
                      validator: (input) {
                        return !input!.contains('@')
                            ? 'Enter a valid email address'
                            : null;
                      },
                      iconData: Icons.alternate_email,
                      key: null,
                      errorText: '',
                      suffixIcon: const Icon(null),
                      suffix: const Icon(null),
                    ),
                    TextFieldWidget(
                      readOnly: false,
                      labelText: 'Phone',
                      hintText: "677777777",
                      initialValue: '',
                      keyboardType: TextInputType.number,
                      // onSaved: (input) =>
                      //     controller.currentUser.value.phoneNumber = input,
                      // onChanged: (value) =>
                      //     {controller.currentUser.value.phoneNumber = value},
                      validator: (input) =>
                          input!.length < 9 || input.length > 9
                              ? 'Enter exactly 9 characters'
                              : null,
                      iconData: Icons.phone,
                      key: null,
                      errorText: '',
                      suffixIcon: const Icon(null),
                      suffix: const Icon(null),
                    ),
                     TextFieldWidget(
                      readOnly: true,
                      labelText: 'Gender',
                      hintText: "Male",
                      initialValue: '',
                      keyboardType: TextInputType.number,
                      // onSaved: (input) =>
                      //     controller.currentUser.value.phoneNumber = input,
                      // onChanged: (value) =>
                      //     {controller.currentUser.value.phoneNumber = value},
                      iconData: Icons.person,
                      key: null,
                      errorText: '',
                      suffixIcon:const Icon(null),
                      suffix:const Icon(null),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: BlockButtonWidget(
                    onPressed: () async {},
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      'Update Information',
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: 20.0,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
