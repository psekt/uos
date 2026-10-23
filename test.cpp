#include <iostream>
using namespace std;

int main() {
    // Declare a variable to store the user's name
    string name;

    // Prompt the user to enter their name
    cout << "Enter your name: ";

    // Read the user's input
    cin >> name;

    // Output a greeting message using the user's name
    cout << "Hello, " << name << "!" << endl;

    // Return 0 to indicate successful execution
    return 0;
}
