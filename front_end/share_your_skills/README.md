# Share Your Skills

Welcome to the Share Your Skills project! This is a Flutter-based app where you can share your skills and connect with others who share similar interests. 

## Getting Started

To begin developing with Flutter, follow these steps:

1. **Install the Flutter SDK**: Download and install the Flutter SDK by following the instructions in the official [Flutter documentation](https://docs.flutter.dev/get-started/install).

2. **Set Up Your Environment**

   - Open your terminal.
   - To configure Flutter to be accessible from your terminal, open or create your shell configuration file. If you're using macOS and Zsh, you can use the `vim` text editor for this purpose:

     ```shell
     vim ~/.zshrc
     ```

   - Press "i" to enter insert mode in `vim`.
   - Insert the following line, replacing `<YOUR_FLUTTER_PATH>` with the actual path to your Flutter installation directory:

     ```shell
     export PATH="$PATH:<YOUR_FLUTTER_PATH>/flutter/bin"
     ```

   - Save your changes and exit `vim` by pressing `Esc`, typing `:wq`, and pressing Enter.
   - Close and reopen your terminal or run the following command to apply the changes immediately:

     ```shell
     source ~/.zshrc
     ```

   Now, you're ready to work with Flutter from your terminal.
to check all dependencences are in place use flutter doctor.
3. **Development Tools**

   - For iOS development, you'll need [Xcode](https://developer.apple.com/xcode/) installed on your macOS machine.
   - For Android development, consider using [Android Studio](https://developer.android.com/studio). Ensure it's set up correctly for Flutter development.

   - **Verify Dependencies**: To confirm that all necessary Flutter dependencies are correctly installed and configured, run the following command in your terminal:

     ```shell
     flutter doctor
     ```

     The `flutter doctor` command will check your environment and provide guidance on any missing or misconfigured dependencies. Resolve any issues reported by `flutter doctor` to ensure a smooth development experience.
     