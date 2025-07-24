#include <iostream>

extern "C" {
    void trigger_bug();
}

int main() {
    std::cout << "calling rust\n";
    trigger_bug();
    return 0;
}
